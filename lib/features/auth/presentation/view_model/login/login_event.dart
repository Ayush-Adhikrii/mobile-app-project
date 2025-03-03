// lib/features/auth/presentation/view_model/login/login_event.dart
part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class NavigateRegisterScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateRegisterScreenEvent({
    required this.context,
    required this.destination,
  });

  @override
  List<Object?> get props => [context, destination];
}

class NavigateHomeScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateHomeScreenEvent({
    required this.context,
    required this.destination,
  });

  @override
  List<Object?> get props => [context, destination];
}

class LoginUserEvent extends LoginEvent {
  final String userName;
  final String password;
  final BuildContext context;

  const LoginUserEvent({
    required this.userName,
    required this.password,
    required this.context,
  });

  @override
  List<Object?> get props => [userName, password, context];
}

class FetchCurrentUserEvent extends LoginEvent {
  final BuildContext context;

  const FetchCurrentUserEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class LogoutUserEvent extends LoginEvent {
  final BuildContext context;

  const LogoutUserEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class ChangePasswordEvent extends LoginEvent {
  final String oldPassword;
  final String newPassword;
  final BuildContext context;

  const ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
    required this.context,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword, context];
}