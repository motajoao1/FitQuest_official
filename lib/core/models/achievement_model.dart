import 'package:hive/hive.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 3;

  @override
  Achievement read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final description = reader.readString();
    final icon = reader.readString();
    final isUnlocked = reader.readBool();
    final hasUnlockedAt = reader.readBool();
    DateTime? unlockedAt;
    if (hasUnlockedAt) {
      unlockedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }

    return Achievement(
      id: id,
      name: name,
      description: description,
      icon: icon,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.icon);
    writer.writeBool(obj.isUnlocked);
    writer.writeBool(obj.unlockedAt != null);
    if (obj.unlockedAt != null) {
      writer.writeInt(obj.unlockedAt!.millisecondsSinceEpoch);
    }
  }
}
