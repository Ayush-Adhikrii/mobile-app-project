import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final AuthEntity? authUser;
  final String? errorMessage;
  final bool isOffline;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.authUser,
    this.errorMessage,
    this.isOffline = false,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    AuthEntity? authUser,
    String? errorMessage,
    bool? isOffline,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      authUser: authUser ?? this.authUser,
      errorMessage: errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  factory LoginState.initial() {
    return const LoginState(
      isLoading: false,
      isSuccess: false,
      authUser: null,
      errorMessage: null,
      isOffline: false,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isSuccess, authUser, errorMessage, isOffline];
}
