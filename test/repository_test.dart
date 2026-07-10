import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitquest/core/models/user_profile.dart';
import 'package:fitquest/core/models/achievement_model.dart';
import 'package:fitquest/core/models/title_model.dart';
import 'package:fitquest/core/constants/enums.dart';
import 'package:fitquest/core/repositories/repository_interfaces.dart';

// Manual mock implementations for testing
class MockUserProfileRepository implements UserProfileRepository {
  UserProfile? _profile;

  @override
  Future<void> init() async {}

  @override
  Future<void> close() async {}

  @override
  Stream<UserProfile?> watchProfile() => Stream.value(_profile);

  @override
  Future<UserProfile?> getProfile() async => _profile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> updateSteps(int steps) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(stepCount: steps);
    }
  }

  @override
  Future<void> addExperience(int xp) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(evolutionPoints: _profile!.evolutionPoints + xp);
    }
  }

  @override
  Future<void> updateLevel(int level) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(level: level);
    }
  }

  @override
  Future<void> setCharacterClass(String classId) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(currentClassType: classId);
    }
  }

  @override
  Future<void> setSelectedTitle(String? titleId) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(selectedTitleId: titleId);
    }
  }
}

class MockAchievementRepository implements AchievementRepository {
  final List<Achievement> _achievements = [];

  @override
  Future<void> init() async {
    // Initialize with default achievements
    _achievements.addAll([
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
        id: AchievementType.bossDefeated.id,
        name: AchievementType.bossDefeated.name,
        description: AchievementType.bossDefeated.description,
        icon: AchievementType.bossDefeated.icon,
      ),
      Achievement(
        id: AchievementType.firstGym.id,
        name: AchievementType.firstGym.name,
        description: AchievementType.firstGym.description,
        icon: AchievementType.firstGym.icon,
      ),
      Achievement(
        id: AchievementType.levelUp.id,
        name: AchievementType.levelUp.name,
        description: AchievementType.levelUp.description,
        icon: AchievementType.levelUp.icon,
      ),
    ]);
  }

  @override
  Future<void> close() async {}

  @override
  Stream<List<Achievement>> watchAllAchievements() => Stream.value(_achievements);

  @override
  Future<List<Achievement>> getAllAchievements() async => _achievements;

  @override
  Future<Achievement?> getAchievement(String id) async {
    return _achievements.firstWhere(
      (achievement) => achievement.id == id,
      orElse: () => throw StateError('Achievement not found: $id'),
    );
  }

  @override
  Future<void> unlockAchievement(String id) async {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final achievement = _achievements[index];
      _achievements[index] = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<List<Achievement>> getUnlockedAchievements() async {
    return _achievements.where((a) => a.isUnlocked).toList();
  }
}

class MockTitleRepository implements TitleRepository {
  final List<TitleModel> _titles = [];

  @override
  Future<void> init() async {
    _titles.addAll([
      TitleModel(id: 'title_novice', name: 'Novice'),
      TitleModel(id: 'title_warrior', name: 'Warrior'),
      TitleModel(id: 'title_hero', name: 'Hero'),
    ]);
  }

  @override
  Future<void> close() async {}

  @override
  Stream<List<TitleModel>> watchAllTitles() => Stream.value(_titles);

  @override
  Future<List<TitleModel>> getAllTitles() async => _titles;

  @override
  Future<TitleModel?> getTitle(String id) async {
    try {
      return _titles.firstWhere((title) => title.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> unlockTitle(String id) async {
    final index = _titles.indexWhere((t) => t.id == id);
    if (index != -1) {
      final title = _titles[index];
      _titles[index] = title.copyWith(isUnlocked: true);
    }
  }

  @override
  Future<List<TitleModel>> getUnlockedTitles() async {
    return _titles.where((t) => t.isUnlocked).toList();
  }
}

void main() {
  group('Repository Unit Tests', () {
    late MockUserProfileRepository userRepo;
    late MockAchievementRepository achievementRepo;
    late MockTitleRepository titleRepo;

    setUp(() {
      userRepo = MockUserProfileRepository();
      achievementRepo = MockAchievementRepository();
      titleRepo = MockTitleRepository();
    });

    group('UserProfile Repository', () {
      test('should save and retrieve user profile', () async {
        // Arrange
        final profile = UserProfile(
          stepCount: 1000,
          level: 2,
          evolutionPoints: 150,
          currentClassType: CharacterClass.warrior.id,
        );

        // Act
        await userRepo.saveProfile(profile);
        final result = await userRepo.getProfile();

        // Assert
        expect(result, isNotNull);
        expect(result!.stepCount, 1000);
        expect(result.level, 2);
        expect(result.evolutionPoints, 150);
        expect(result.currentClassType, CharacterClass.warrior.id);
      });

      test('should update step count correctly', () async {
        // Arrange
        final profile = UserProfile(stepCount: 500);
        await userRepo.saveProfile(profile);

        // Act
        await userRepo.updateSteps(1200);
        final result = await userRepo.getProfile();

        // Assert
        expect(result!.stepCount, 1200);
      });

      test('should add experience points', () async {
        // Arrange
        final profile = UserProfile(evolutionPoints: 100);
        await userRepo.saveProfile(profile);

        // Act
        await userRepo.addExperience(50);
        final result = await userRepo.getProfile();

        // Assert
        expect(result!.evolutionPoints, 150);
      });

      test('should set character class with type-safe enum', () async {
        // Arrange
        final profile = UserProfile();
        await userRepo.saveProfile(profile);

        // Act
        await userRepo.setCharacterClass(CharacterClass.ranger.id);
        final result = await userRepo.getProfile();

        // Assert
        expect(result!.currentClassType, CharacterClass.ranger.id);
        expect(result.characterClass, CharacterClass.ranger);
      });
    });

    group('Achievement Repository', () {
      test('should initialize with default achievements', () async {
        // Act
        await achievementRepo.init();
        final achievements = await achievementRepo.getAllAchievements();

        // Assert
        expect(achievements, isNotEmpty);
        expect(
          achievements.any((a) => a.id == AchievementType.steps1000.id),
          true,
        );
        expect(
          achievements.any((a) => a.id == AchievementType.bossDefeated.id),
          true,
        );
      });

      test('should unlock achievement and track unlock time', () async {
        // Arrange
        await achievementRepo.init();
        final achievementId = AchievementType.steps1000.id;

        // Act
        await achievementRepo.unlockAchievement(achievementId);
        final achievement = await achievementRepo.getAchievement(achievementId);

        // Assert
        expect(achievement, isNotNull);
        expect(achievement!.isUnlocked, true);
        expect(achievement.unlockedAt, isNotNull);
      });

      test('should return only unlocked achievements', () async {
        // Arrange
        await achievementRepo.init();
        await achievementRepo.unlockAchievement(AchievementType.steps1000.id);

        // Act
        final unlockedAchievements = await achievementRepo.getUnlockedAchievements();

        // Assert
        expect(unlockedAchievements.length, 1);
        expect(unlockedAchievements.first.id, AchievementType.steps1000.id);
        expect(unlockedAchievements.every((a) => a.isUnlocked), true);
      });
    });

    group('Title Repository', () {
      test('should initialize with default titles', () async {
        // Act
        await titleRepo.init();
        final titles = await titleRepo.getAllTitles();

        // Assert
        expect(titles, isNotEmpty);
        expect(titles.any((t) => t.id == 'title_novice'), true);
        expect(titles.any((t) => t.id == 'title_warrior'), true);
        expect(titles.any((t) => t.id == 'title_hero'), true);
      });

      test('should unlock title successfully', () async {
        // Arrange
        await titleRepo.init();

        // Act
        await titleRepo.unlockTitle('title_warrior');
        final title = await titleRepo.getTitle('title_warrior');

        // Assert
        expect(title!.isUnlocked, true);
      });

      test('should return only unlocked titles', () async {
        // Arrange
        await titleRepo.init();
        await titleRepo.unlockTitle('title_warrior');
        await titleRepo.unlockTitle('title_hero');

        // Act
        final unlockedTitles = await titleRepo.getUnlockedTitles();

        // Assert
        expect(unlockedTitles.length, 2);
        expect(unlockedTitles.every((t) => t.isUnlocked), true);
      });
    });

    group('Enum Type Safety', () {
      test('CharacterClass enum should provide type safety and conversion', () {
        // Test enum values
        expect(CharacterClass.novice.id, 'novice');
        expect(CharacterClass.warrior.id, 'warrior');
        expect(CharacterClass.ranger.id, 'ranger');
        expect(CharacterClass.mage.id, 'mage');

        // Test display names
        expect(CharacterClass.warrior.displayName, 'Warrior');
        expect(CharacterClass.ranger.displayName, 'Ranger');

        // Test enum conversion
        expect(CharacterClass.fromId('warrior'), CharacterClass.warrior);
        expect(CharacterClass.fromId('ranger'), CharacterClass.ranger);
        expect(CharacterClass.fromId('invalid'), CharacterClass.novice); // fallback
      });

      test('AchievementType enum should provide complete achievement data', () {
        // Test steps achievements
        expect(AchievementType.steps1000.id, 'PASSOS_1000');
        expect(AchievementType.steps1000.name, 'A Thousand PASSOS');
        expect(AchievementType.steps1000.description, 'Take 1,000 PASSOS.');
        expect(AchievementType.steps1000.icon, '🚶');

        expect(AchievementType.steps10000.id, 'PASSOS_10000');
        expect(AchievementType.steps10000.name, 'Ten Thousand PASSOS');
        expect(AchievementType.steps10000.icon, '🏃');

        // Test boss achievement
        expect(AchievementType.bossDefeated.id, 'BOSS_DEFEATED');
        expect(AchievementType.bossDefeated.name, 'Boss Slayer');
        expect(AchievementType.bossDefeated.icon, '⚔️');
      });

      test('should throw error for invalid achievement ID', () {
        expect(
          () => AchievementType.fromId('invalid_id'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('QuestType enum should provide quest configuration', () {
        expect(QuestType.daily.id, 'daily');
        expect(QuestType.daily.displayName, 'Daily Quest');
        expect(QuestType.daily.duration, const Duration(days: 1));

        expect(QuestType.weekly.id, 'weekly');
        expect(QuestType.weekly.duration, const Duration(days: 7));

        expect(QuestType.special.duration, const Duration(days: 30));
      });

      test('BossType enum should provide boss data', () {
        expect(BossType.training.id, 'training');
        expect(BossType.training.name, 'Training Dummy');
        expect(BossType.training.health, 100);
        expect(BossType.training.timeLimit, const Duration(minutes: 5));

        expect(BossType.dragon.id, 'dragon');
        expect(BossType.dragon.name, 'Ancient Dragon');
        expect(BossType.dragon.health, 1000);
        expect(BossType.dragon.timeLimit, const Duration(hours: 1));
      });
    });

    group('UserProfile Model Integration', () {
      test('UserProfile should work with CharacterClass enum', () {
        // Create profile with default class
        final profile = UserProfile();
        expect(profile.characterClass, CharacterClass.novice);

        // Create profile with specific class
        final warriorProfile = UserProfile(
          currentClassType: CharacterClass.warrior.id,
        );
        expect(warriorProfile.characterClass, CharacterClass.warrior);

        // Test copyWith using enum
        final updatedProfile = profile.copyWith(
          characterClass: CharacterClass.mage,
        );
        expect(updatedProfile.characterClass, CharacterClass.mage);
        expect(updatedProfile.currentClassType, CharacterClass.mage.id);
      });

      test('UserProfile should handle invalid class types gracefully', () {
        final profile = UserProfile(currentClassType: 'invalid_class');
        expect(profile.characterClass, CharacterClass.novice); // fallback
      });
    });
  });
}