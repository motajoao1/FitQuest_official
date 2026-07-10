import 'package:hive/hive.dart';
import '../constants/enums.dart';

class UserProfile {
  int stepCount;
  int evolutionPoints;
  int level;
  String? selectedTitleId;
  String currentClassType;

  UserProfile({
    this.stepCount = 0,
    this.evolutionPoints = 0,
    this.level = 1,
    this.selectedTitleId,
    this.currentClassType = 'novice', // default to novice as string for backward compatibility
  });

  // Helper getter to get type-safe enum
  CharacterClass get characterClass => CharacterClass.fromId(currentClassType);

  // Helper setter to set from enum
  void setCharacterClass(CharacterClass classType) {
    currentClassType = classType.id;
  }

  UserProfile copyWith({
    int? stepCount,
    int? evolutionPoints,
    int? level,
    String? selectedTitleId,
    String? currentClassType,
    CharacterClass? characterClass,
  }) {
    return UserProfile(
      stepCount: stepCount ?? this.stepCount,
      evolutionPoints: evolutionPoints ?? this.evolutionPoints,
      level: level ?? this.level,
      selectedTitleId: selectedTitleId ?? this.selectedTitleId,
      currentClassType: characterClass?.id ?? currentClassType ?? this.currentClassType,
    );
  }
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final stepCount = reader.readInt();
    final evolutionPoints = reader.readInt();
    final level = reader.readInt();
    String? selectedTitleId;
    String currentClassType = 'novice';
    if (reader.availableBytes > 0) {
      selectedTitleId = reader.readString();
      if (selectedTitleId.isEmpty) selectedTitleId = null;
    }
    // Read class type if available
    try {
      if (reader.availableBytes > 0) {
        currentClassType = reader.readString();
      }
    } catch(e) {
      // Fallback for old data
    }
    return UserProfile(
      stepCount: stepCount,
      evolutionPoints: evolutionPoints,
      level: level,
      selectedTitleId: selectedTitleId,
      currentClassType: currentClassType,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer.writeInt(obj.stepCount);
    writer.writeInt(obj.evolutionPoints);
    writer.writeInt(obj.level);
    if (obj.selectedTitleId != null) {
      writer.writeString(obj.selectedTitleId!);
    } else {
      writer.writeString(''); // or write nothing, but we need consistency for next reads
    }
    writer.writeString(obj.currentClassType);
  }
}
