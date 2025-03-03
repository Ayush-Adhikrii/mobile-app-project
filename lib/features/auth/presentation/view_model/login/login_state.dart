// lib/features/auth/presentation/view_model/login/login_state.dart
part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final AuthEntity? authUser;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.authUser,
  });

  factory LoginState.initial() => const LoginState(
        isLoading: false,
        isSuccess: false,
        authUser: null,
      );

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    AuthEntity? authUser,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      authUser: authUser ?? this.authUser,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, authUser];
}
