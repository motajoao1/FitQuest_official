import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitquest/core/services/achievement_service.dart';
import 'package:fitquest/core/repositories/repository_providers.dart';
import 'package:fitquest/core/constants/enums.dart';
import 'repository_test.dart'; // Import mock repositories

void main() {
  // Initialize test bindings to handle SnackBar and other UI-related calls
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AchievementService Integration Tests', () {
    late ProviderContainer container;
    late AchievementService achievementService;
    late MockAchievementRepository mockAchievementRepo;
    late MockTitleRepository mockTitleRepo;

    setUp(() async {
      mockAchievementRepo = MockAchievementRepository();
      mockTitleRepo = MockTitleRepository();
      
      await mockAchievementRepo.init();
      await mockTitleRepo.init();

      container = ProviderContainer(
        overrides: [
          achievementRepositoryProvider.overrideWithValue(mockAchievementRepo),
          titleRepositoryProvider.overrideWithValue(mockTitleRepo),
        ],
      );

      achievementService = container.read(achievementServiceProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize achievement service properly', () async {
      // Act
      await achievementService.init();

      // Assert - achievements should be available
      final achievements = await mockAchievementRepo.getAllAchievements();
      expect(achievements, isNotEmpty);
      expect(
        achievements.any((a) => a.id == AchievementType.steps1000.id),
        true,
      );
    });

    test('should unlock achievement for 1000 steps', () async {
      // Arrange
      await achievementService.init();

      // Act
      await achievementService.checkStepAchievements(1000);

      // Assert
      final achievement = await mockAchievementRepo.getAchievement(
        AchievementType.steps1000.id,
      );
      expect(achievement, isNotNull);
      expect(achievement!.isUnlocked, true);

      // Title should also be unlocked
      final title = await mockTitleRepo.getTitle('title_walker');
      expect(title!.isUnlocked, true);
    });

    test('should unlock achievement for 10000 steps', () async {
      // Arrange  
      await achievementService.init();

      // Act
      await achievementService.checkStepAchievements(10000);

      // Assert
      final achievement = await mockAchievementRepo.getAchievement(
        AchievementType.steps10000.id,
      );
      expect(achievement, isNotNull);
      expect(achievement!.isUnlocked, true);

      // Title should also be unlocked
      final title = await mockTitleRepo.getTitle('title_runner');
      expect(title!.isUnlocked, true);
    });

    test('should unlock level achievements correctly', () async {
      // Arrange
      await achievementService.init();

      // Act - check level 5 achievement
      await achievementService.checkLevelAchievements(5);

      // Assert
      final achievement = await mockAchievementRepo.getAchievement(
        AchievementType.levelUp.id,
      );
      expect(achievement, isNotNull);
      expect(achievement!.isUnlocked, true);

      final title = await mockTitleRepo.getTitle('title_warrior');
      expect(title!.isUnlocked, true);
    });

    test('should unlock boss defeated achievement', () async {
      // Arrange
      await achievementService.init();

      // Act
      await achievementService.checkBossDefeated();

      // Assert
      final achievement = await mockAchievementRepo.getAchievement(
        AchievementType.bossDefeated.id,
      );
      expect(achievement, isNotNull);
      expect(achievement!.isUnlocked, true);
    });

    test('should unlock first gym achievement', () async {
      // Arrange
      await achievementService.init();

      // Act
      await achievementService.checkFirstGymVisit();

      // Assert
      final achievement = await mockAchievementRepo.getAchievement(
        AchievementType.firstGym.id,
      );
      expect(achievement, isNotNull);
      expect(achievement!.isUnlocked, true);
    });

    test('should not unlock achievement multiple times', () async {
      // Arrange
      await achievementService.init();
      await achievementService.checkStepAchievements(1000);
      
      // Get timestamp of first unlock
      final firstUnlock = await mockAchievementRepo.getAchievement(
        AchievementType.steps1000.id,
      );
      expect(firstUnlock, isNotNull);
      final firstUnlockTime = firstUnlock!.unlockedAt;

      // Act - try to unlock again
      await achievementService.checkStepAchievements(1500);

      // Assert - timestamp should remain the same
      final secondUnlock = await mockAchievementRepo.getAchievement(
        AchievementType.steps1000.id,
      );
      expect(secondUnlock, isNotNull);
      expect(secondUnlock!.unlockedAt, firstUnlockTime);
    });

    test('should handle multiple achievements at once', () async {
      // Arrange
      await achievementService.init();

      // Act - trigger multiple achievements with high step count
      await achievementService.checkStepAchievements(15000);  // Should unlock both 1k and 10k

      // Assert
      final achievement1k = await mockAchievementRepo.getAchievement(
        AchievementType.steps1000.id,
      );
      final achievement10k = await mockAchievementRepo.getAchievement(
        AchievementType.steps10000.id,
      );

      expect(achievement1k, isNotNull);
      expect(achievement10k, isNotNull);
      expect(achievement1k!.isUnlocked, true);
      expect(achievement10k!.isUnlocked, true);

      // Both titles should be unlocked
      final walkerTitle = await mockTitleRepo.getTitle('title_walker');
      final runnerTitle = await mockTitleRepo.getTitle('title_runner');
      expect(walkerTitle!.isUnlocked, true);
      expect(runnerTitle!.isUnlocked, true);
    });
  });
}