import 'package:flutter/material.dart';

class LoginEvent {}

class NavigateRegisterScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  NavigateRegisterScreenEvent(this.context, this.destination);
}

class NavigateHomeScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  NavigateHomeScreenEvent({required this.context, required this.destination});
}

class LoginUserEvent extends LoginEvent {
  final String userName;
  final String password;
  final BuildContext context;

  LoginUserEvent({
    required this.userName,
    required this.password,
    required this.context,
  });
}

class FetchCurrentUserEvent extends LoginEvent {
  final BuildContext context;

  FetchCurrentUserEvent(this.context);
}

class LogoutUserEvent extends LoginEvent {
  final BuildContext context;

  LogoutUserEvent(this.context);
}

class ChangePasswordEvent extends LoginEvent {
  final String oldPassword;
  final String newPassword;
  final BuildContext context;

  ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
    required this.context,
  });
}