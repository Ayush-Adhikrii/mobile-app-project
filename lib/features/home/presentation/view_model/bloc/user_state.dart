// lib/features/home/presentation/view_model/bloc/user_state.dart
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  final List<UserEntity>? users;

  const UserLoading({this.users});
}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  final String? swipeFeedback;

  const UserLoaded(this.users, {this.swipeFeedback});
}

class LikersLoaded extends UserState {
  final List<UserEntity> likers;
  final String? swipeFeedback;

  const LikersLoaded(this.likers, {this.swipeFeedback});
}

class UserError extends UserState {
  final String message;
  final List<UserEntity>? users;

  const UserError(this.message, {this.users});
}

class UserMatchFound extends UserState {
  final List<UserEntity> users;
  final String? swipeFeedback;

  const UserMatchFound({required this.users, this.swipeFeedback});

  @override
  List<Object?> get props => [users, swipeFeedback];
}
