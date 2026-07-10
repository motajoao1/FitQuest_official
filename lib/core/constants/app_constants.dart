library core_constants_app;

/// App-wide constants and configuration values

class AppConstants {
  // Experience and leveling
  static const int baseXpRequired = 100;
  static const double xpMultiplierPerLevel = 1.2;
  static const int maxLevel = 100;
  
  // Steps and movement
  static const int defaultDailyStepGoal = 10000;
  static const int stepsPerXp = 10; // 1 XP per 10 steps
  
  // boss battles
  static const int baseDamagePerStep = 1;
  static const Duration bossRespawnTime = Duration(hours: 24);
  
  // Quests
  static const int maxDailyQuests = 3;
  static const int maxWeeklyQuests = 1;
  static const int baseQuestXpReward = 50;
  
  // Gym check-ins
  static const double gymCheckInRadius = 100.0; // meters
  static const int xpPerGymVisit = 25;
  
  // Activity multipliers (MET values)
  static const Map<String, double> activityMets = {
    'caminhada': 3.5,
    'corrida': 8.0,
    'ciclismo': 6.8,
    'natacao': 7.0,
    'musculacao': 3.0,
    'yoga': 2.5,
    'danca': 4.8,
  };
  
  // Class XP multipliers
  static const Map<String, double> classXpMultipliers = {
    'novice': 1.0,
    'warrior': 1.1,
    'ranger': 1.15,
    'mage': 1.2,
  };
  
  // App settings
  static const String appName = 'FitQuest';
  static const String appVersion = '1.0.0';
  static const Duration locationUpdateInterval = Duration(seconds: 30);
  static const Duration stepCountUpdateInterval = Duration(seconds: 1);
  
  // Notification settings
  static const String dailyReminderChannelId = 'daily_reminders';
  static const String achievementChannelId = 'achievements';
  static const String questChannelId = 'quests';
  
  // Storage keys
  static const String userProfileKey = 'user_profile';
  static const String achievementsKey = 'achievements';
  static const String questsKey = 'quests';
  static const String stepsKey = 'steps';
  static const String activitiesKey = 'activities';
}

class AppTheme {
  // RPG Colors
  static const int parchmentColor = 0xFFF4E5C2;
  static const int inkColor = 0xFF2D1810;
  static const int accentColor = 0xFF8B4513;
  static const int successColor = 0xFF228B22;
  static const int warningColor = 0xFFDAA520;
  static const int errorColor = 0xFF8B0000;
  
  // Font families
  static const String primaryFont = 'MedievalSharp';
  static const String secondaryFont = 'Cinzel';
}