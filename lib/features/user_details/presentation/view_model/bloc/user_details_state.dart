part of 'user_details_bloc.dart';

class UserDetailsState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const UserDetailsState({
    required this.isLoading,
    required this.isSuccess,
  });

  const UserDetailsState.initial()
      : isLoading = false,
        isSuccess = false;

  UserDetailsState copyWith({
    bool? isLoading,
    bool? isSuccess,
  }) {
    return UserDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
}
