// lib/features/home/presentation/view_model/bloc/user_state.dart
import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';

abstract class UserState extends Equatable {
  final List<UserEntity> users;
  final String? swipeFeedback;

  const UserState({this.users = const [], this.swipeFeedback});

  @override
  List<Object?> get props => [users, swipeFeedback];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading({super.users});
}

class UserLoaded extends UserState {
  const UserLoaded(List<UserEntity> users, {String? swipeFeedback}) : super(users: users, swipeFeedback: swipeFeedback);

  @override
  List<Object?> get props => [users, swipeFeedback];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message, {super.users});

  @override
  List<Object?> get props => [message, users];
}