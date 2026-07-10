library repository_interfaces;

import '../models/user_profile.dart';
import '../models/achievement_model.dart';
import '../models/title_model.dart';
import '../models/activity_record_model.dart';

/// Base interface for all repositories
abstract class Repository {
  Future<void> init();
  Future<void> close();
}

/// Repository for managing user profile data
abstract class UserProfileRepository extends Repository {
  Stream<UserProfile?> watchProfile();
  Future<UserProfile?> getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> updateSteps(int steps);
  Future<void> addExperience(int xp);
  Future<void> updateLevel(int level);
  Future<void> setCharacterClass(String classId);
  Future<void> setSelectedTitle(String? titleId);
}

/// Repository for managing achievements
abstract class AchievementRepository extends Repository {
  Stream<List<Achievement>> watchAllAchievements();
  Future<List<Achievement>> getAllAchievements();
  Future<Achievement?> getAchievement(String id);
  Future<void> unlockAchievement(String id);
  Future<List<Achievement>> getUnlockedAchievements();
}

/// Repository for managing titles
abstract class TitleRepository extends Repository {
  Stream<List<TitleModel>> watchAllTitles();
  Future<List<TitleModel>> getAllTitles();
  Future<TitleModel?> getTitle(String id);
  Future<void> unlockTitle(String id);
  Future<List<TitleModel>> getUnlockedTitles();
}

/// Repository for managing activity records
abstract class ActivityRepository extends Repository {
  Stream<List<ActivityRecord>> watchAllActivities();
  Future<List<ActivityRecord>> getAllActivities();
  Future<void> saveActivity(ActivityRecord activity);
  Future<void> deleteActivity(String activityId);
  Future<List<ActivityRecord>> getActivitiesByDateRange(DateTime start, DateTime end);
}

/// Repository for managing step data
abstract class StepRepository extends Repository {
  Stream<int> watchStepCount();
  Future<int> getCurrentStepCount();
  Future<void> updateStepCount(int steps);
  Future<void> resetDailySteps();
  Future<Map<DateTime, int>> getStepHistory(int days);
}