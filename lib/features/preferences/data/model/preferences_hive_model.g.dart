// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferencesHiveModelAdapter extends TypeAdapter<PreferencesHiveModel> {
  @override
  final int typeId = 2;

  @override
  PreferencesHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreferencesHiveModel(
      userId: fields[0] as String,
      preferredGender: fields[1] as String?,
      minAge: fields[2] as int?,
      maxAge: fields[3] as int?,
      relationType: fields[4] as String?,
      preferredStarSign: fields[5] as String?,
      preferredReligion: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PreferencesHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.preferredGender)
      ..writeByte(2)
      ..write(obj.minAge)
      ..writeByte(3)
      ..write(obj.maxAge)
      ..writeByte(4)
      ..write(obj.relationType)
      ..writeByte(5)
      ..write(obj.preferredStarSign)
      ..writeByte(6)
      ..write(obj.preferredReligion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferencesHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
