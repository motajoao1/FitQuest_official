import 'package:hive/hive.dart';

class ActivityRecord {
  final String id;
  final String activityType; // e.g. walking, cycling, swimming, yoga
  final int durationMinutes;
  final double metValue; // Metabolic Equivalent of Task
  final DateTime timestamp;
  final int xpEarned;

  ActivityRecord({
    required this.id,
    required this.activityType,
    required this.durationMinutes,
    required this.metValue,
    required this.timestamp,
    required this.xpEarned,
  });

  ActivityRecord copyWith({
    String? id,
    String? activityType,
    int? durationMinutes,
    double? metValue,
    DateTime? timestamp,
    int? xpEarned,
  }) {
    return ActivityRecord(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      metValue: metValue ?? this.metValue,
      timestamp: timestamp ?? this.timestamp,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }
}

class ActivityRecordAdapter extends TypeAdapter<ActivityRecord> {
  @override
  final int typeId = 2;

  @override
  ActivityRecord read(BinaryReader reader) {
    final id = reader.readString();
    final activityType = reader.readString();
    final durationMinutes = reader.readInt();
    final metValue = reader.readDouble();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final xpEarned = reader.readInt();
    return ActivityRecord(
      id: id,
      activityType: activityType,
      durationMinutes: durationMinutes,
      metValue: metValue,
      timestamp: timestamp,
      xpEarned: xpEarned,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityRecord obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.activityType);
    writer.writeInt(obj.durationMinutes);
    writer.writeDouble(obj.metValue);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeInt(obj.xpEarned);
  }
}
