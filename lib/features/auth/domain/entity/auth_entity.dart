import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String userName;
  final String password;
  final String? gender;
  final String? birthDate;
  final String? starSign;
  final String? bio;
  final String? profilePhoto;

  const AuthEntity({
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

  const AuthEntity.empty()
      : userId = 'empty_user_id',
        name = 'empty_user_id',
        email = 'empty_user_email',
        phoneNumber = 'empty_user_phonenumber',
        gender = 'empty_user_gender',
        birthDate = null,
        starSign = 'empty_user_starsign',
        bio = 'empty_user_bio',
        userName = 'empty_user_username',
        password = 'empty_user_password',
        profilePhoto = 'empty_user_photo';

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
