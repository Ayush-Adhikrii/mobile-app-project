// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_hive_model.dart';

// ************************************************************************** 
// TypeAdapterGenerator 
// ************************************************************************** 

class AuthHiveModelAdapter extends TypeAdapter<AuthHiveModel> {
  @override
  final int typeId = 0;

  @override
  AuthHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthHiveModel(
      userId: fields[0] as String?, // Changed studentId to userId
      name: fields[1] as String,
      email: fields[2] as String?,
      phoneNumber: fields[3] as String?,
      userName: fields[4] as String,
      password: fields[5] as String,
      gender: fields[6] as String?,
      birthDate: fields[7] as DateTime?,
      starSign: fields[8] as String?,
      bio: fields[9] as String?,
      profilePhoto: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthHiveModel obj) {
    writer
      ..writeByte(11) // Updated field count to match total fields
      ..writeByte(0)
      ..write(obj.userId) // Changed studentId to userId
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.userName)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.birthDate)
      ..writeByte(8)
      ..write(obj.starSign)
      ..writeByte(9)
      ..write(obj.bio)
      ..writeByte(10)
      ..write(obj.profilePhoto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
