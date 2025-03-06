import 'dart:io';

import 'package:flutter/material.dart';

class RegisterEvent {}

class RegisterUser extends RegisterEvent {
  final BuildContext context;
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

  RegisterUser({
    required this.context,
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
}

class UploadImage extends RegisterEvent {
  final BuildContext context;
  final File file;

  UploadImage(this.context, this.file);
}
