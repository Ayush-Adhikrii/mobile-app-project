import 'dart:io';
import 'package:flutter/material.dart';

class EditProfileEvent {}

class UpdateProfile extends EditProfileEvent {
  final BuildContext context;
  final String userId;
  final String? name;
  final String? gender;
  final String? email;
  final DateTime? birthDate;
  final String? starSign;
  final String? phoneNumber;
  final String? bio;
  final String? userName;

  UpdateProfile({
    required this.context,
    required this.userId,
    this.name,
    this.gender,
    this.email,
    this.birthDate,
    this.starSign,
    this.phoneNumber,
    this.bio,
    this.userName,
  });
}

class UploadProfilePhoto extends EditProfileEvent {
  final BuildContext context;
  final String userId;
  final File image;

  UploadProfilePhoto({
    required this.context,
    required this.userId,
    required this.image,
  });
}