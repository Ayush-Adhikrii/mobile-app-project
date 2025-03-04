// lib/features/auth/presentation/bloc/edit_profile_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfile extends EditProfileEvent {
  final String userId;
  final String name;
  final String gender;
  final String email;
  final DateTime birthDate;
  final String phoneNumber;
  final String bio;
  final String userName;

  const UpdateProfile({
    required this.userId,
    required this.name,
    required this.gender,
    required this.email,
    required this.birthDate,
    required this.phoneNumber,
    required this.bio,
    required this.userName,
  });

  @override
  List<Object?> get props => [userId, name, gender, email, birthDate, phoneNumber, bio, userName];
}

class UploadProfilePhoto extends EditProfileEvent {
  final String userId;
  final File image;

  const UploadProfilePhoto({required this.userId, required this.image});

  @override
  List<Object?> get props => [userId, image];
}