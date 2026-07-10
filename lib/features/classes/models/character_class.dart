import '../../../core/constants/enums.dart';

class CharacterClassModel {
  final CharacterClass classType;
  final String name;
  final String description;
  final String iconName;
  final double xpMultiplierMasmorra;
  final double xpMultiplierHeroesMarch;
  final double xpMultiplierGeneral;

  const CharacterClassModel({
    required this.classType,
    required this.name,
    required this.description,
    required this.iconName,
    this.xpMultiplierMasmorra = 1.0,
    this.xpMultiplierHeroesMarch = 1.0,
    this.xpMultiplierGeneral = 1.0,
  });

  String get id => classType.id;

  static const novice = CharacterClassModel(
    classType: CharacterClass.novice,
    name: 'Novice',
    description: 'A beginner starting their fitness journey. Balanced stats.',
    iconName: 'person_outline',
  );

  static const warrior = CharacterClassModel(
    classType: CharacterClass.warrior,
    name: 'Warrior',
    description: 'Masters of strength and gym workouts. Bonus XP for Masmorra check-ins.',
    iconName: 'fitness_center',
    xpMultiplierMasmorra: 1.2,
  );

  static const ranger = CharacterClassModel(
    classType: CharacterClass.ranger,
    name: 'Ranger',
    description: 'Masters of endurance and cardio. Bonus XP for Marcha do Herói.',
    iconName: 'directions_run',
    xpMultiplierHeroesMarch: 1.2,
  );
  
  static const mage = CharacterClassModel(
    classType: CharacterClass.mage,
    name: 'Mage',
    description: 'Masters of flexibility and balance. Bonus general XP.',
    iconName: 'self_improvement',
    xpMultiplierGeneral: 1.1,
  );

  static const values = [novice, warrior, ranger, mage];

  static CharacterClassModel getById(String id) {
    final classType = CharacterClass.fromId(id);
    return values.firstWhere(
      (c) => c.classType == classType, 
      orElse: () => novice,
    );
  }

  static CharacterClassModel getByType(CharacterClass type) {
    return values.firstWhere(
      (c) => c.classType == type,
      orElse: () => novice,
    );
  }
}
