// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated adapters for DynamicQuest and related classes

import 'package:hive/hive.dart';
import '../models/dynamic_quest_model.dart';
import '../../../core/constants/enums.dart';

class DynamicQuestAdapter extends TypeAdapter<DynamicQuest> {
  @override
  final int typeId = 8;

  @override
  DynamicQuest read(BinaryReader reader) {
    return DynamicQuest(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      type: QuestType.values[reader.readByte()],
      category: QuestCategory.values[reader.readByte()],
      targetValue: reader.readInt(),
      currentValue: reader.readInt(),
      xpReward: reader.readInt(),
      difficulty: QuestDifficulty.values[reader.readByte()],
      isCompleted: reader.readBool(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      requirements: (reader.readList()).cast<QuestRequirement>(),
      rewards: (reader.readList()).cast<QuestReward>(),
      completedAt: (() {
        final val = reader.readString();
        return val.isEmpty ? null : val;
      })(),
      isPersonalized: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, DynamicQuest obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeByte(obj.type.index);
    writer.writeByte(obj.category.index);
    writer.writeInt(obj.targetValue);
    writer.writeInt(obj.currentValue);
    writer.writeInt(obj.xpReward);
    writer.writeByte(obj.difficulty.index);
    writer.writeBool(obj.isCompleted);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.expiresAt.millisecondsSinceEpoch);
    writer.writeList(obj.requirements);
    writer.writeList(obj.rewards);
    writer.writeString(obj.completedAt ?? '');
    writer.writeBool(obj.isPersonalized);
  }
}

class QuestCategoryAdapter extends TypeAdapter<QuestCategory> {
  @override
  final int typeId = 9;

  @override
  QuestCategory read(BinaryReader reader) {
    return QuestCategory.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, QuestCategory obj) {
    writer.writeByte(obj.index);
  }
}

class QuestDifficultyAdapter extends TypeAdapter<QuestDifficulty> {
  @override
  final int typeId = 10;

  @override
  QuestDifficulty read(BinaryReader reader) {
    return QuestDifficulty.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, QuestDifficulty obj) {
    writer.writeByte(obj.index);
  }
}

class QuestRequirementAdapter extends TypeAdapter<QuestRequirement> {
  @override
  final int typeId = 11;

  @override
  QuestRequirement read(BinaryReader reader) {
    return QuestRequirement(
      type: reader.readString(),
      minValue: reader.readInt(),
      description: (() {
        final val = reader.readString();
        return val.isEmpty ? null : val;
      })(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestRequirement obj) {
    writer.writeString(obj.type);
    writer.writeInt(obj.minValue);
    writer.writeString(obj.description ?? '');
  }
}

class QuestRewardAdapter extends TypeAdapter<QuestReward> {
  @override
  final int typeId = 12;

  @override
  QuestReward read(BinaryReader reader) {
    return QuestReward(
      type: reader.readString(),
      value: reader.readString(),
      description: (() {
        final val = reader.readString();
        return val.isEmpty ? null : val;
      })(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestReward obj) {
    writer.writeString(obj.type);
    writer.writeString(obj.value);
    writer.writeString(obj.description ?? '');
  }
}