// lib/features/auth/presentation/bloc/edit_profile_state.dart
import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

class EditProfileSuccess extends EditProfileState {
  final AuthEntity updatedUser;

  const EditProfileSuccess(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

class EditProfileError extends EditProfileState {
  final String message;

  const EditProfileError(this.message);

  @override
  List<Object?> get props => [message];
}