import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;
  @JsonKey(name: 'userName')
  final String userName;
  @JsonKey(name: 'gender')
  final String? gender;
  @JsonKey(name: 'birthDate')
  final String? birthDate;
  @JsonKey(name: 'starSign')
  final String? starSign;
  @JsonKey(name: 'bio')
  final String? bio;
  @JsonKey(name: 'profilePhoto')
  final String? profilePhoto;

  const UserApiModel({
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

  /// Converts JSON to `UserApiModel`
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  /// Converts `UserApiModel` to JSON
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

//   /// Converts `UserApiModel` to `UserEntity`
//   AuthEntity toEntity() {
//     return AuthEntity(
//       id: id,
//       name: name,
//       email: email,
//       phoneNumber: phoneNumber,
//       userName: userName,
//       gender: gender,
//       birthDate: birthDate,
//       starSign: starSign,
//       bio: bio,
//       profilePhoto: profilePhoto,
//     );
//   }

//   /// Creates `UserApiModel` from `UserEntity`
//   factory UserApiModel.fromEntity(AuthEntity entity) {
//     return UserApiModel(
//       id: entity.id,
//       name: entity.name,
//       email: entity.email,
//       phoneNumber: entity.phoneNumber,
//       userName: entity.userName,
//       gender: entity.gender,
//       birthDate: entity.birthDate,
//       starSign: entity.starSign,
//       bio: entity.bio,
//       profilePhoto: entity.profilePhoto,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         name,
//         email,
//         phoneNumber,
//         userName,
//         gender,
//         birthDate,
//         starSign,
//         bio,
//         profilePhoto,
//       ];
}
