import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:softwarica_student_management_bloc/app/constants/hive_table_constant.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? phoneNumber;
  @HiveField(4)
  final String userName;
  @HiveField(5)
  final String password;
  @HiveField(6)
  final String? gender;
  @HiveField(7)
  final String? birthDate;
  @HiveField(8)
  final String? starSign;
  @HiveField(9)
  final String? bio;
  @HiveField(10)
  final String? profilePhoto;

  AuthHiveModel({
    String? userId,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.userName,
    required this.password,
    this.gender,
    this.birthDate,
    this.starSign,
    this.bio,
    this.profilePhoto,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : userId = '',
        name = '',
        email = null,
        phoneNumber = null,
        userName = '',
        password = '',
        gender = null,
        birthDate = null,
        starSign = null,
        bio = null,
        profilePhoto = null;

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId, // Map to userId
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      userName: entity.userName,
      password: entity.password,
      gender: entity.gender,
      birthDate: entity.birthDate,
      starSign: entity.starSign,
      bio: entity.bio,
      profilePhoto: entity.profilePhoto,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId, // Map to userId
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      userName: userName,
      password: password,
      gender: gender,
      birthDate: birthDate,
      starSign: starSign,
      bio: bio,
      profilePhoto: profilePhoto,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        email,
        phoneNumber,
        userName,
        password,
        gender,
        birthDate,
        starSign,
        bio,
        profilePhoto,
      ];
}
