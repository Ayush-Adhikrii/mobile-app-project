import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String userName;
  final String password;
  final String? gender;
  final DateTime? birthDate;
  final String? starSign;
  final String? bio;
  final String? profilePhoto;

  const AuthApiModel({
    this.userId,
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
  });

  /// Converts JSON to `AuthApiModel`
  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  /// Converts `AuthApiModel` to JSON
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  /// Converts `AuthApiModel` to `AuthEntity`
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
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

  /// Creates `AuthApiModel` from `AuthEntity`
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      userId: entity.userId,
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
