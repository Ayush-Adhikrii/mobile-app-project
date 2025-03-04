// lib/features/user_details/presentation/view_model/bloc/user_details_event.dart
import 'package:equatable/equatable.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserDetails extends UserDetailsEvent {
  final String userId;

  const FetchUserDetails(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserDetails extends UserDetailsEvent {
  final String key;
  final String value;
  final String userId;

  const UpdateUserDetails(this.userId, this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}
