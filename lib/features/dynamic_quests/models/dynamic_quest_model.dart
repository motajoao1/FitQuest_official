library dynamic_quest_model;

import 'package:hive/hive.dart';
import '../../../core/constants/enums.dart';

/// Enhanced quest model with dynamic generation support
@HiveType(typeId: 8) // New typeId to avoid conflicts
class DynamicQuest {
  @HiveField(0)
  final String id;

  @HiveField(1) 
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final QuestType type;

  @HiveField(4)
  final QuestCategory category;

  @HiveField(5)
  final int targetValue;

  @HiveField(6)
  final int currentValue;

  @HiveField(7)
  final int xpReward;

  @HiveField(8)
  final QuestDifficulty difficulty;

  @HiveField(9)
  final bool isCompleted;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime expiresAt;

  @HiveField(12)
  final List<QuestRequirement> requirements;

  @HiveField(13)
  final List<QuestReward> rewards;

  @HiveField(14)
  final String? completedAt;

  @HiveField(15)
  final bool isPersonalized; // Generated based on user behavior

  DynamicQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.targetValue,
    this.currentValue = 0,
    required this.xpReward,
    required this.difficulty,
    this.isCompleted = false,
    required this.createdAt,
    required this.expiresAt,
    this.requirements = const [],
    this.rewards = const [],
    this.completedAt,
    this.isPersonalized = false,
  });

  DynamicQuest copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    QuestCategory? category,
    int? targetValue,
    int? currentValue,
    int? xpReward,
    QuestDifficulty? difficulty,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<QuestRequirement>? requirements,
    List<QuestReward>? rewards,
    String? completedAt,
    bool? isPersonalized,
  }) {
    return DynamicQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      requirements: requirements ?? this.requirements,
      rewards: rewards ?? this.rewards,
      completedAt: completedAt ?? this.completedAt,
      isPersonalized: isPersonalized ?? this.isPersonalized,
    );
  }

  /// Calculate completion percentage
  double get completionPercentage {
    if (targetValue == 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  /// Check if quest is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if quest is active (not completed and not expired)
  bool get isActive => !isCompleted && !isExpired;

  /// Get remaining time until expiration
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return Duration.zero;
    return expiresAt.difference(now);
  }
}

/// Quest categories for better organization
@HiveType(typeId: 9)
enum QuestCategory {
  @HiveField(0)
  movement, // Steps, cardio, general movement

  @HiveField(1)
  strength, // Gym workouts, weightlifting

  @HiveField(2)
  endurance, // Long runs, extended activities

  @HiveField(3)
  consistency, // Daily streaks, regular habits

  @HiveField(4)
  social, // Friend interactions, challenges

  @HiveField(5)
  exploration, // New locations, gym check-ins

  @HiveField(6)
  achievement, // Leveling, unlocking content

  @HiveField(7)
  special, // Seasonal events, unique challenges
}

/// Quest difficulty levels
@HiveType(typeId: 10)
enum QuestDifficulty {
  @HiveField(0)
  easy,    // 1.0x XP multiplier

  @HiveField(1)
  medium,  // 1.5x XP multiplier

  @HiveField(2)
  hard,    // 2.0x XP multiplier

  @HiveField(3)
  epic,    // 3.0x XP multiplier

  @HiveField(4)
  legendary, // 5.0x XP multiplier
}

/// Quest requirements (conditions that must be met)
@HiveType(typeId: 11)
class QuestRequirement {
  @HiveField(0)
  final String type; // 'level', 'steps', 'gym_visits', etc.

  @HiveField(1)
  final int minValue;

  @HiveField(2)
  final String? description;

  QuestRequirement({
    required this.type,
    required this.minValue,
    this.description,
  });
}

/// Quest rewards (additional rewards beyond XP)
@HiveType(typeId: 12)
class QuestReward {
  @HiveField(0)
  final String type; // 'title', 'badge', 'bonus_xp', etc.

  @HiveField(1)
  final String value;

  @HiveField(2)
  final String? description;

  QuestReward({
    required this.type,
    required this.value,
    this.description,
  });
}

/// Extension methods for quest system
extension QuestDifficultyExtensions on QuestDifficulty {
  double get xpMultiplier {
    switch (this) {
      case QuestDifficulty.easy:
        return 1.0;
      case QuestDifficulty.medium:
        return 1.5;
      case QuestDifficulty.hard:
        return 2.0;
      case QuestDifficulty.epic:
        return 3.0;
      case QuestDifficulty.legendary:
        return 5.0;
    }
  }

  String get displayName {
    switch (this) {
      case QuestDifficulty.easy:
        return 'Missão de Novato';
      case QuestDifficulty.medium:
        return 'Missão de Aventureiro';
      case QuestDifficulty.hard:
        return 'Missão Heroica';
      case QuestDifficulty.epic:
        return 'Missão Épica';
      case QuestDifficulty.legendary:
        return 'Missão Lendária';
    }
  }

  String get icon {
    switch (this) {
      case QuestDifficulty.easy:
        return '⚡';
      case QuestDifficulty.medium:
        return '⚔️';
      case QuestDifficulty.hard:
        return '🛡️';
      case QuestDifficulty.epic:
        return '👑';
      case QuestDifficulty.legendary:
        return '🏆';
    }
  }
}

extension QuestCategoryExtensions on QuestCategory {
  String get displayName {
    switch (this) {
      case QuestCategory.movement:
        return "Caminho do Explorador";
      case QuestCategory.strength:
        return "Treinamento de Guerreiro";
      case QuestCategory.endurance:
        return "Prova do Maratonista";
      case QuestCategory.consistency:
        return "Devoção do Guardião";
      case QuestCategory.social:
        return "Missão de Irmandade";
      case QuestCategory.exploration:
        return "Jornada do Cartógrafo";
      case QuestCategory.achievement:
        return "Ascensão do Campeão";
      case QuestCategory.special:
        return "Evento Lendário";
    }
  }

  String get icon {
    switch (this) {
      case QuestCategory.movement:
        return '🚶';
      case QuestCategory.strength:
        return '💪';
      case QuestCategory.endurance:
        return '🏃';
      case QuestCategory.consistency:
        return '📅';
      case QuestCategory.social:
        return '👥';
      case QuestCategory.exploration:
        return '🗺️';
      case QuestCategory.achievement:
        return '🎯';
      case QuestCategory.special:
        return '✨';
    }
  }
}