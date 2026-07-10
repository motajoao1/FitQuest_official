import 'package:hive/hive.dart';

class TitleModel {
  final String id;
  final String name;
  final bool isUnlocked;

  TitleModel({
    required this.id,
    required this.name,
    this.isUnlocked = false,
  });

  TitleModel copyWith({
    String? id,
    String? name,
    bool? isUnlocked,
  }) {
    return TitleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class TitleModelAdapter extends TypeAdapter<TitleModel> {
  @override
  final int typeId = 4;

  @override
  TitleModel read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final isUnlocked = reader.readBool();
    return TitleModel(
      id: id,
      name: name,
      isUnlocked: isUnlocked,
    );
  }

  @override
  void write(BinaryWriter writer, TitleModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeBool(obj.isUnlocked);
  }
}
