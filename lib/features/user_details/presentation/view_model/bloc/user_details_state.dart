// lib/features/user_details/presentation/view_model/bloc/user_details_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entity/user_details_entity.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

class UserDetailsInitial extends UserDetailsState {
  const UserDetailsInitial();
}

class UserDetailsLoading extends UserDetailsState {
  const UserDetailsLoading();
}

class UserDetailsLoaded extends UserDetailsState {
  final UserDetailsEntity userDetails;

  const UserDetailsLoaded(this.userDetails);

  @override
  List<Object?> get props => [userDetails];
}

class UserDetailsError extends UserDetailsState {
  final String message;

  const UserDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}