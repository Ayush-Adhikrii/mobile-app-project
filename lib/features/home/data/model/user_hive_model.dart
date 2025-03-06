import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../app/constants/hive_table_constant.dart';
import '../../../auth/domain/entity/auth_entity.dart';
import '../../domain/entity/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userHomeTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? phoneNumber;
  @HiveField(4)
  final String userName;
  @HiveField(5)
  final String? gender;
  @HiveField(6)
  final String? birthDate;
  @HiveField(7)
  final String? starSign;
  @HiveField(8)
  final String? bio;
  @HiveField(9)
  final String? profilePhoto;

  const UserHiveModel({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.userName,
    this.gender,
    this.birthDate,
    this.starSign,
    this.bio,
    this.profilePhoto,
  });

  // Convert from UserEntity
  factory UserHiveModel.fromEntity(AuthEntity entity) {
    return UserHiveModel(
      id: entity.userId!,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      userName: entity.userName,
      gender: entity.gender,
      birthDate: entity.birthDate,
      starSign: entity.starSign,
      bio: entity.bio,
      profilePhoto: entity.profilePhoto,
    );
  }

  // Convert to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      userName: userName,
      gender: gender,
      birthDate: birthDate,
      starSign: starSign,
      bio: bio,
      profilePhoto: profilePhoto,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'gender': gender,
      'birthDate': birthDate,
      'starSign': starSign,
      'bio': bio,
      'profilePhoto': profilePhoto,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        userName,
        gender,
        birthDate,
        starSign,
        bio,
        profilePhoto,
      ];
}
