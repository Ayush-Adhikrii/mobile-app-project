part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUser extends RegisterEvent {
  final BuildContext context;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String userName;
  final String password;
  final String confirmPassword;
  final String? gender;
  final DateTime? birthDate;
  final String? starSign;
  final String? bio;
  final String? profilePhoto;

  const RegisterUser({
    required this.context,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.userName,
    required this.password,
    required this.confirmPassword,
    this.gender,
    this.birthDate,
    this.starSign,
    this.bio,
    this.profilePhoto,
  });

  @override
  List<Object> get props => [
        context,
        name,
        email ?? '',
        phoneNumber ?? '',
        userName,
        password,
        gender ?? '',
        birthDate ?? DateTime(0),
        starSign ?? '',
        bio ?? '',
        profilePhoto ?? '',
      ];
}
