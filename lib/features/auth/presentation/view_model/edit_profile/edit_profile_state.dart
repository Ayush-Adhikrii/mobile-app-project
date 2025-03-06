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
  final AuthEntity user;

  const EditProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class EditProfileError extends EditProfileState {
  final String message;
  final bool isOffline;

  const EditProfileError(this.message, {this.isOffline = false});

  @override
  List<Object?> get props => [message, isOffline];
}