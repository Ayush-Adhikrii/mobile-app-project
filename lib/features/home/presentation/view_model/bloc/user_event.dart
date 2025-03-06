// lib/features/home/presentation/view_model/bloc/user_event.dart
import 'package:equatable/equatable.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {}

class FetchLikers extends UserEvent {
  final String userId;

  const FetchLikers(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SwipeRight extends UserEvent {
  final String userId;

  const SwipeRight(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SwipeLeft extends UserEvent {
  final String userId;

  const SwipeLeft(this.userId);

  @override
  List<Object?> get props => [userId];
}

class NewMatchDetected extends UserEvent {
  final List<UserEntity> users;

  const NewMatchDetected({required this.users});

  @override
  List<Object?> get props => [users];
}
