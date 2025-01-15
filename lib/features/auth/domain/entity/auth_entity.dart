import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
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
