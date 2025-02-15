// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsHiveModelAdapter extends TypeAdapter<UserDetailsHiveModel> {
  @override
  final int typeId = 1;

  @override
  UserDetailsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetailsHiveModel(
      userId: fields[0] as String,
      profession: fields[1] as String?,
      education: fields[2] as String?,
      height: fields[3] as double?,
      exercise: fields[4] as String?,
      drinks: fields[5] as String?,
      smoke: fields[6] as String?,
      kids: fields[7] as String?,
      religion: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetailsHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.profession)
      ..writeByte(2)
      ..write(obj.education)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.exercise)
      ..writeByte(5)
      ..write(obj.drinks)
      ..writeByte(6)
      ..write(obj.smoke)
      ..writeByte(7)
      ..write(obj.kids)
      ..writeByte(8)
      ..write(obj.religion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
