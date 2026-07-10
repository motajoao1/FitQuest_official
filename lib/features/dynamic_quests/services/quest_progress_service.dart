library quest_progress_service;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dynamic_quest_provider.dart';
import '../models/dynamic_quest_model.dart';
import '../../heroes_march/providers/step_provider.dart';
import '../../../core/services/error_handler_service.dart';

/// Service that tracks various activities and updates quest progress
class QuestProgressService {
  final Ref ref;
  
  QuestProgressService(this.ref);

  /// Initialize step tracking integration
  void initializeProgressTracking() {
    // Listen to step changes and update relevant quests
    ref.listen(stepCountProvider, (previous, next) {
      if (previous != null && next.hasValue && previous.value != next.value) {
        final stepCount = next.value ?? 0;
        if (stepCount > 0) {
          _updateStepQuests(stepCount);
        }
      }
    });
  }

  /// Update step-related quests
  Future<void> _updateStepQuests(int currentSteps) async {
    try {
      final questsAsync = ref.read(dynamicQuestManagerProvider);
      questsAsync.whenData((quests) async {
        final stepQuests = quests.where((quest) => 
          quest.category == QuestCategory.movement ||
          quest.category == QuestCategory.endurance
        ).where((quest) => !quest.isCompleted);

        for (final quest in stepQuests) {
          await ref.read(dynamicQuestManagerProvider.notifier).updateQuestProgress(quest.id, currentSteps);
        }
      });
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Step quest update');
    }
  }

  /// Update gym visit quests
  Future<void> updateGymVisitQuests() async {
    try {
      final questsAsync = ref.read(dynamicQuestManagerProvider);
      questsAsync.whenData((quests) async {
        final gymQuests = quests.where((quest) => 
          quest.category == QuestCategory.strength ||
          quest.category == QuestCategory.exploration
        ).where((quest) => !quest.isCompleted);

        for (final quest in gymQuests) {
          await ref.read(dynamicQuestManagerProvider.notifier).updateQuestProgress(quest.id, quest.currentValue + 1);
        }
      });
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Gym quest update');
    }
  }

  /// Update activity-based quests (for when user logs activities)
  Future<void> updateActivityQuests(String activityType, int duration) async {
    try {
      final questsAsync = ref.read(dynamicQuestManagerProvider);
      questsAsync.whenData((quests) async {
        // Different activities update different quest categories
        QuestCategory? category;
        switch (activityType.toLowerCase()) {
          case 'musculacao':
          case 'weightlifting':
            category = QuestCategory.strength;
            break;
          case 'corrida':
          case 'running':
          case 'ciclismo':
          case 'cycling':
            category = QuestCategory.endurance;
            break;
          case 'caminhada':
          case 'walking':
            category = QuestCategory.movement;
            break;
        }

        if (category != null) {
          final relevantQuests = quests.where((quest) => 
            quest.category == category && !quest.isCompleted
          );

          for (final quest in relevantQuests) {
            // For activity duration quests, add the duration
            await ref.read(dynamicQuestManagerProvider.notifier).updateQuestProgress(quest.id, quest.currentValue + duration);
          }
        }
      });
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Activity quest update');
    }
  }

  /// Update consistency quests (daily login, workout streaks)
  Future<void> updateConsistencyQuests() async {
    try {
      final questsAsync = ref.read(dynamicQuestManagerProvider);
      questsAsync.whenData((quests) async {
        final consistencyQuests = quests.where((quest) => 
          quest.category == QuestCategory.consistency && !quest.isCompleted
        );

        for (final quest in consistencyQuests) {
          await ref.read(dynamicQuestManagerProvider.notifier).updateQuestProgress(quest.id, quest.currentValue + 1);
        }
      });
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Consistency quest update');
    }
  }

  /// Update level-based achievement quests
  Future<void> updateAchievementQuests() async {
    try {
      final questsAsync = ref.read(dynamicQuestManagerProvider);
      questsAsync.whenData((quests) async {
        final achievementQuests = quests.where((quest) => 
          quest.category == QuestCategory.achievement && !quest.isCompleted
        );

        for (final quest in achievementQuests) {
          await ref.read(dynamicQuestManagerProvider.notifier).updateQuestProgress(quest.id, quest.currentValue + 1);
        }
      });
    } catch (e) {
      ref.read(errorHandlerServiceProvider).handleException(e, context: 'Achievement quest update');
    }
  }

  /// Manual quest progress update (for testing or manual completion)
  Future<void> updateQuestProgress(String questId, int progress) async {
    await ref.read(dynamicQuestManagerProvider.notifier).updateQuestProgress(questId, progress);
  }

  /// Complete quest manually (for testing or admin functions)
  Future<void> completeQuest(String questId) async {
    await ref.read(dynamicQuestManagerProvider.notifier).completeQuest(questId);
  }
}

/// Quest progress service provider
final questProgressServiceProvider = Provider<QuestProgressService>((ref) {
  return QuestProgressService(ref);
});

/// Initialize quest progress tracking
final questProgressInitializerProvider = Provider<void>((ref) {
  final progressService = ref.read(questProgressServiceProvider);
  progressService.initializeProgressTracking();
  return;
});