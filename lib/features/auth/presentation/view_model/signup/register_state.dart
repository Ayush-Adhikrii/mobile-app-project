import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;
  final String? errorMessage;
  final bool isOffline;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
    this.errorMessage,
    this.isOffline = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
    String? errorMessage,
    bool? isOffline,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
      errorMessage: errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  factory RegisterState.initial() {
    return const RegisterState(
      isLoading: false,
      isSuccess: false,
      imageName: null,
      errorMessage: null,
      isOffline: false,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, imageName, errorMessage, isOffline];
}