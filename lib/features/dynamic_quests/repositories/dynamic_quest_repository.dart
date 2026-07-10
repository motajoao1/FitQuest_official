library dynamic_quest_repository;

import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/dynamic_quest_model.dart';
import '../../../core/constants/enums.dart';
import '../../../core/errors/app_errors.dart';

/// Repository for managing dynamic quests
class DynamicQuestRepository {
  static const String _boxName = 'dynamicQuestsBox';
  late Box<DynamicQuest> _box;
  
  Future<void> init() async {
    try {
      _box = await Hive.openBox<DynamicQuest>(_boxName);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to initialize dynamic quest repository',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  Future<void> close() async {
    await _box.close();
  }

  /// Watch all quests
  Stream<List<DynamicQuest>> watchAllQuests() {
    return _box.watch().asyncMap((_) async => await getAllQuests());
  }

  /// Get all quests
  Future<List<DynamicQuest>> getAllQuests() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to retrieve quests',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Get quests by type
  Future<List<DynamicQuest>> getQuestsByType(QuestType type) async {
    try {
      return _box.values.where((quest) => quest.type == type).toList();
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to retrieve quests by type',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Get active quests (not completed and not expired)
  Future<List<DynamicQuest>> getActiveQuests() async {
    try {
      final now = DateTime.now();
      return _box.values.where((quest) => 
        !quest.isCompleted && now.isBefore(quest.expiresAt)
      ).toList();
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to retrieve active quests',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Get daily quests
  Future<List<DynamicQuest>> getDailyQuests() async {
    return getQuestsByType(QuestType.daily);
  }

  /// Get weekly quests
  Future<List<DynamicQuest>> getWeeklyQuests() async {
    return getQuestsByType(QuestType.weekly);
  }

  /// Get special quests
  Future<List<DynamicQuest>> getSpecialQuests() async {
    return getQuestsByType(QuestType.special);
  }

  /// Save quest
  Future<void> saveQuest(DynamicQuest quest) async {
    try {
      await _box.put(quest.id, quest);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to save quest',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Save multiple quests
  Future<void> saveQuests(List<DynamicQuest> quests) async {
    try {
      final questMap = {for (var quest in quests) quest.id: quest};
      await _box.putAll(questMap);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to save multiple quests',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Get quest by ID
  Future<DynamicQuest?> getQuest(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to retrieve quest',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Update quest progress
  Future<void> updateQuestProgress(String questId, int progress) async {
    try {
      final quest = _box.get(questId);
      if (quest == null) {
        throw BusinessError.now(message: 'Quest not found: $questId');
      }

      final updatedQuest = quest.copyWith(
        currentValue: progress,
        isCompleted: progress >= quest.targetValue,
        completedAt: progress >= quest.targetValue ? DateTime.now().toIso8601String() : null,
      );

      await _box.put(questId, updatedQuest);
    } catch (e) {
      if (e is AppError) rethrow;
      throw RepositoryError.now(
        message: 'Failed to update quest progress',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Complete quest
  Future<void> completeQuest(String questId) async {
    try {
      final quest = _box.get(questId);
      if (quest == null) {
        throw BusinessError.now(message: 'Quest not found: $questId');
      }

      final completedQuest = quest.copyWith(
        isCompleted: true,
        currentValue: quest.targetValue,
        completedAt: DateTime.now().toIso8601String(),
      );

      await _box.put(questId, completedQuest);
    } catch (e) {
      if (e is AppError) rethrow;
      throw RepositoryError.now(
        message: 'Failed to complete quest',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Delete quest
  Future<void> deleteQuest(String questId) async {
    try {
      await _box.delete(questId);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to delete quest',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Clear expired quests
  Future<int> clearExpiredQuests() async {
    try {
      final now = DateTime.now();
      final expiredQuests = _box.values.where(
        (quest) => now.isAfter(quest.expiresAt) && !quest.isCompleted,
      ).toList();

      for (final quest in expiredQuests) {
        await _box.delete(quest.id);
      }

      return expiredQuests.length;
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to clear expired quests',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Clear all quests (for testing/reset)
  Future<void> clearAllQuests() async {
    try {
      await _box.clear();
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to clear all quests',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  /// Get quest statistics
  Future<QuestStats> getQuestStats() async {
    try {
      final allQuests = await getAllQuests();
      final now = DateTime.now();

      return QuestStats(
        totalQuests: allQuests.length,
        completedQuests: allQuests.where((q) => q.isCompleted).length,
        activeQuests: allQuests.where((q) => q.isActive).length,
        expiredQuests: allQuests.where((q) => now.isAfter(q.expiresAt) && !q.isCompleted).length,
        personalizedQuests: allQuests.where((q) => q.isPersonalized).length,
      );
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to calculate quest statistics',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }
}

/// Quest statistics data
class QuestStats {
  final int totalQuests;
  final int completedQuests;
  final int activeQuests;
  final int expiredQuests;
  final int personalizedQuests;

  QuestStats({
    required this.totalQuests,
    required this.completedQuests,
    required this.activeQuests,
    required this.expiredQuests,
    required this.personalizedQuests,
  });

  double get completionRate => totalQuests > 0 ? completedQuests / totalQuests : 0.0;
}