library core_constants_enums;

/// Core enums and constants for type safety across the application

enum CharacterClass {
  novice('novice', 'Novato', 'O início da sua jornada'),
  warrior('warrior', 'Guerreiro', 'Lutador forte e resiliente'),
  ranger('ranger', 'Ranger', 'Aventureiro ágil e preciso'), 
  mage('mage', 'Mago', 'Sábio detentor de conhecimentos antigos');

  const CharacterClass(this.id, this.displayName, this.description);
  
  final String id;
  final String displayName;
  final String description;

  static CharacterClass fromId(String id) {
    return CharacterClass.values.firstWhere(
      (classType) => classType.id == id,
      orElse: () => CharacterClass.novice,
    );
  }
}

enum AchievementType {
  steps1000('PASSOS_1000', 'Mil Passos', 'Caminhe 1.000 passos.', '🚶'),
  steps10000('PASSOS_10000', 'Dez Mil Passos', 'Caminhe 10.000 passos.', '🏃'),
  firstGym('PRIMEIRO_GYM', 'Primeira Masmorra', 'Visite sua primeira masmorra.', '🏛️'),
  bossDefeated('BOSS_DEFEATED', 'Matador de Chefes', 'Derrote o seu primeiro chefe.', '⚔️'),
  levelUp('LEVEL_UP', 'Subir de Nível', 'Alcance um novo nível de personagem.', '✨');

  const AchievementType(this.id, this.name, this.description, this.icon);
  
  final String id;
  final String name;
  final String description;
  final String icon;

  static AchievementType fromId(String id) {
    return AchievementType.values.firstWhere(
      (achievement) => achievement.id == id,
      orElse: () => throw ArgumentError('Unknown achievement ID: $id'),
    );
  }
}

enum QuestType {
  daily('daily', 'Daily Quest', Duration(days: 1)),
  weekly('weekly', 'Weekly Quest', Duration(days: 7)),
  special('special', 'Special Event', Duration(days: 30));

  const QuestType(this.id, this.displayName, this.duration);
  
  final String id;
  final String displayName;
  final Duration duration;

  static QuestType fromId(String id) {
    return QuestType.values.firstWhere(
      (type) => type.id == id,
      orElse: () => QuestType.daily,
    );
  }
}

enum AccountType {
  free('free', 'Free Account', 0),
  premium('premium', 'Premium Account', 1), 
  admin('admin', 'Admin Account', 2);

  const AccountType(this.id, this.displayName, this.level);
  
  final String id;
  final String displayName;
  final int level;

  static AccountType fromId(String id) {
    return AccountType.values.firstWhere(
      (type) => type.id == id,
      orElse: () => AccountType.free,
    );
  }
}

enum BossType {
  training('training', 'Training Dummy', 100, Duration(minutes: 5)),
  goblin('goblin', 'Goblin Warrior', 300, Duration(minutes: 15)),
  orc('orc', 'Orc Champion', 500, Duration(minutes: 30)),
  dragon('dragon', 'Ancient Dragon', 1000, Duration(hours: 1));

  const BossType(this.id, this.name, this.health, this.timeLimit);
  
  final String id;
  final String name;
  final int health;
  final Duration timeLimit;

  static BossType fromId(String id) {
    return BossType.values.firstWhere(
      (boss) => boss.id == id,
      orElse: () => BossType.training,
    );
  }
}