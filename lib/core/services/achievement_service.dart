import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../constants/enums.dart';
import '../repositories/repository_interfaces.dart';
import '../repositories/repository_providers.dart';

class AchievementService {
  final AchievementRepository _achievementRepository;
  final TitleRepository _titleRepository;

  AchievementService(this._achievementRepository, this._titleRepository);

  Future<void> init() async {
    // Repositories handle their own initialization
    await _achievementRepository.init();
    await _titleRepository.init();
  }

  Future<void> unlockAchievement(String id) async {
    final achievementBefore = await _achievementRepository.getAchievement(id);
    if (achievementBefore != null && !achievementBefore.isUnlocked) {
      await _achievementRepository.unlockAchievement(id);
      
      // Show notification to user (only if ScaffoldMessenger is available)
      try {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('🏆 Achievement Unlocked: ${achievementBefore.name}!'),
            backgroundColor: Colors.amber[700],
            duration: const Duration(seconds: 4),
          ),
        );
      } catch (e) {
        // Handle cases where UI context is not available (e.g., during testing)
        // Silently ignore or log the error
      }
    }
  }

  Future<void> unlockTitle(String id) async {
    await _titleRepository.unlockTitle(id);
  }

  // --- Checkers for Events ---

  Future<void> checkStepAchievements(int totalPASSOS) async {
    if (totalPASSOS >= 1000) {
      await unlockAchievement(AchievementType.steps1000.id);
      await unlockTitle('title_walker');
    }

    if (totalPASSOS >= 10000) {
      await unlockAchievement(AchievementType.steps10000.id);
      await unlockTitle('title_runner');
    }
  }

  Future<void> checkLevelAchievements(int level) async {
    if (level >= 5) {
      await unlockAchievement(AchievementType.levelUp.id);
      await unlockTitle('title_warrior');
    }

    if (level >= 10) {
      await unlockAchievement('level_10'); // TODO: Add level_10 to AchievementType enum
      await unlockTitle('title_hero');
    }
  }

  Future<void> checkFirstGymVisit() async {
    await unlockAchievement(AchievementType.firstGym.id);
  }

  Future<void> checkBossDefeated() async {
    await unlockAchievement(AchievementType.bossDefeated.id);
  }
}

// Provider for AchievementService
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService(
    ref.read(achievementRepositoryProvider),
    ref.read(titleRepositoryProvider),
  );
});
