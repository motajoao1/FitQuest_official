library dynamic_quest_providers;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dynamic_quest_model.dart';
import '../repositories/dynamic_quest_repository.dart';
import '../services/quest_generation_service.dart';
import '../../../core/constants/enums.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/services/error_handler_service.dart';

/// Repository provider
final dynamicQuestRepositoryProvider = Provider<DynamicQuestRepository>((ref) {
  return DynamicQuestRepository();
});

/// Quest generation service provider
final questGenerationServiceProvider = Provider<QuestGenerationService>((ref) {
  return QuestGenerationService(ref.read(userProfileRepositoryProvider));
});

/// Dynamic quest manager
class DynamicQuestManager extends AsyncNotifier<List<DynamicQuest>> {
  late DynamicQuestRepository _repository;
  late QuestGenerationService _questGenerator;
  static const String _lastGenerationDateKey = 'lastQuestGenerationDate';

  @override
  Future<List<DynamicQuest>> build() async {
    _repository = ref.read(dynamicQuestRepositoryProvider);
    _questGenerator = ref.read(questGenerationServiceProvider);
    
    await _repository.init();
    await ref.read(userProfileRepositoryProvider).init();
    await _checkAndGenerateQuests();
    return await _repository.getActiveQuests();
  }

  /// Check if we need to generate new quests and do so if necessary
  Future<void> _checkAndGenerateQuests() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // For now, we'll use a simple check - in a real app, this would be persisted
    
    try {
      // Check if we have active daily quests for today
      final activeDailyQuests = await _repository.getDailyQuests();
      final hasActiveDailyQuests = activeDailyQuests.any((q) => q.isActive);

      if (!hasActiveDailyQuests) {
        await generateDailyQuests();
      }

      // Check for weekly quests
      final activeWeeklyQuests = await _repository.getWeeklyQuests();
      final hasActiveWeeklyQuests = activeWeeklyQuests.any((q) => q.isActive);

      if (!hasActiveWeeklyQuests) {
        await generateWeeklyQuests();
      }

      // Clean up expired quests
      await _repository.clearExpiredQuests();
      
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Quest generation check');
    }
  }

  /// Generate new daily quests
  Future<void> generateDailyQuests() async {
    try {
      state = const AsyncValue.loading();
      
      final newQuests = await _questGenerator.generateDailyQuests(
        count: 3,
        includePersonalized: true,
      );
      
      await _repository.saveQuests(newQuests);
      
      final allQuests = await _repository.getActiveQuests();
      state = AsyncValue.data(allQuests);
      
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Daily quest generation');
    }
  }

  /// Generate new weekly quests
  Future<void> generateWeeklyQuests() async {
    try {
      final newQuests = await _questGenerator.generateWeeklyQuests(count: 2);
      await _repository.saveQuests(newQuests);
      
      // Refresh the quest list
      await refresh();
      
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Weekly quest generation');
    }
  }

  /// Generate special event quest
  Future<void> generateSpecialQuest({
    required String eventTheme,
    Duration? duration,
  }) async {
    try {
      final specialQuests = await _questGenerator.generateSpecialQuests(
        eventTheme: eventTheme,
        duration: duration ?? const Duration(days: 3),
      );
      
      await _repository.saveQuests(specialQuests);
      await refresh();
      
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Special quest generation');
    }
  }

  /// Update quest progress
  Future<void> updateQuestProgress(String questId, int progress) async {
    try {
      await _repository.updateQuestProgress(questId, progress);
      
      // Check if quest is completed and handle rewards
      final quest = await _repository.getQuest(questId);
      if (quest != null && quest.isCompleted) {
        await _handleQuestCompletion(quest);
      }
      
      await refresh();
      
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Quest progress update');
    }
  }

  /// Complete a quest manually
  Future<void> completeQuest(String questId) async {
    try {
      final quest = await _repository.getQuest(questId);
      if (quest == null) return;

      await _repository.completeQuest(questId);
      await _handleQuestCompletion(quest);
      await refresh();
      
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Quest completion');
    }
  }

  /// Handle quest completion rewards and notifications
  Future<void> _handleQuestCompletion(DynamicQuest quest) async {
    try {
      // Award XP
      final userRepo = ref.read(userProfileRepositoryProvider);
      final currentUser = await userRepo.getProfile();
      if (currentUser != null) {
        await userRepo.addExperience(quest.xpReward);
      }

      // Handle additional rewards
      for (final reward in quest.rewards) {
        await _handleQuestReward(reward);
      }

      // Trigger achievement checks (commented out since we need to implement this properly)
      // final achievementService = ref.read(achievementServiceProvider);
      // await achievementService.checkLevelAchievements(currentUser?.level ?? 1);

      // TODO: Show completion notification

    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Quest completion rewards');
    }
  }

  /// Handle individual quest rewards
  Future<void> _handleQuestReward(QuestReward reward) async {
    switch (reward.type) {
      case 'title':
        // TODO: Unlock title
        break;
      case 'bonus_xp':
        final bonusXp = int.tryParse(reward.value) ?? 0;
        if (bonusXp > 0) {
          final userRepo = ref.read(userProfileRepositoryProvider);
          await userRepo.addExperience(bonusXp);
        }
        break;
      case 'badge':
        // TODO: Unlock badge
        break;
    }
  }

  /// Refresh quest list
  Future<void> refresh() async {
    try {
      state = const AsyncValue.loading();
      final quests = await _repository.getActiveQuests();
      state = AsyncValue.data(quests);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Get quest statistics
  Future<QuestStats> getQuestStats() async {
    return await _repository.getQuestStats();
  }

  /// Force regenerate all quests (for testing)
  Future<void> regenerateAllQuests() async {
    try {
      await _repository.clearAllQuests();
      await generateDailyQuests();
      await generateWeeklyQuests();
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Quest regeneration');
    }
  }
}

/// Daily quests provider
final dailyQuestsProvider = Provider<AsyncValue<List<DynamicQuest>>>((ref) {
  return ref.watch(dynamicQuestManagerProvider).whenData(
    (quests) => quests.where((q) => q.type == QuestType.daily).toList(),
  );
});

/// Weekly quests provider  
final weeklyQuestsProvider = Provider<AsyncValue<List<DynamicQuest>>>((ref) {
  return ref.watch(dynamicQuestManagerProvider).whenData(
    (quests) => quests.where((q) => q.type == QuestType.weekly).toList(),
  );
});

/// Special quests provider
final specialQuestsProvider = Provider<AsyncValue<List<DynamicQuest>>>((ref) {
  return ref.watch(dynamicQuestManagerProvider).whenData(
    (quests) => quests.where((q) => q.type == QuestType.special).toList(),
  );
});

/// Main dynamic quest manager provider
final dynamicQuestManagerProvider = AsyncNotifierProvider<DynamicQuestManager, List<DynamicQuest>>(() {
  return DynamicQuestManager();
});