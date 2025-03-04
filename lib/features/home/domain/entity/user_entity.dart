import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String userName;
  final String? gender;
  final String? birthDate;
  final String? starSign;
  final String? bio;
  final String? profilePhoto;

  const UserEntity({
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

  // Empty User for Default State
  const UserEntity.empty()
      : id = '',
        name = '',
        email = null,
        phoneNumber = null,
        userName = '',
        gender = null,
        birthDate = null,
        starSign = null,
        bio = null,
        profilePhoto = null;

   factory UserEntity.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception('User data is null');
    }
    return UserEntity(
      id: json['_id'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String?,
      email: json['email'] as String,
      birthDate: json['birthDate'] as String?,
      starSign: json['starSign'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      userName: json['userName'] as String,
      profilePhoto: json['profilePhoto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'birthDate': birthDate,
      'starSign': starSign,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'userName': userName,
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
