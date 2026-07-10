library hive_achievement_repository;

import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/achievement_model.dart';
import '../constants/enums.dart';
import 'repository_interfaces.dart';

class HiveAchievementRepository implements AchievementRepository {
  static const String _boxName = 'achievementsBox';
  late Box<Achievement> _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<Achievement>(_boxName);
    await _initializeDefaults();
  }

  @override
  Future<void> close() async {
    await _box.close();
  }

  Future<void> _initializeDefaults() async {
    if (_box.isEmpty) {
      // Initialize default achievements using type-safe enums
      final defaultAchievements = [
        Achievement(
          id: AchievementType.steps1000.id,
          name: AchievementType.steps1000.name,
          description: AchievementType.steps1000.description,
          icon: AchievementType.steps1000.icon,
        ),
        Achievement(
          id: AchievementType.steps10000.id,
          name: AchievementType.steps10000.name,
          description: AchievementType.steps10000.description,
          icon: AchievementType.steps10000.icon,
        ),
        Achievement(
          id: AchievementType.firstGym.id,
          name: AchievementType.firstGym.name,
          description: AchievementType.firstGym.description,
          icon: AchievementType.firstGym.icon,
        ),
        Achievement(
          id: AchievementType.bossDefeated.id,
          name: AchievementType.bossDefeated.name,
          description: AchievementType.bossDefeated.description,
          icon: AchievementType.bossDefeated.icon,
        ),
        Achievement(
          id: AchievementType.levelUp.id,
          name: AchievementType.levelUp.name,
          description: AchievementType.levelUp.description,
          icon: AchievementType.levelUp.icon,
        ),
      ];

      for (final achievement in defaultAchievements) {
        await _box.put(achievement.id, achievement);
      }
    }
  }

  @override
  Stream<List<Achievement>> watchAllAchievements() {
    return _box.watch().asyncMap((_) async => await getAllAchievements());
  }

  @override
  Future<List<Achievement>> getAllAchievements() async {
    return _box.values.toList();
  }

  @override
  Future<Achievement?> getAchievement(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> unlockAchievement(String id) async {
    final achievement = _box.get(id);
    if (achievement != null && !achievement.isUnlocked) {
      final updated = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _box.put(id, updated);
    }
  }

  @override
  Future<List<Achievement>> getUnlockedAchievements() async {
    return _box.values.where((achievement) => achievement.isUnlocked).toList();
  }
}