// lib/features/home/presentation/view_model/bloc/user_event.dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  const FetchUsers();
}

class SwipeLeft extends UserEvent {
  final String userId;

  const SwipeLeft(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SwipeRight extends UserEvent {
  final String userId;

  const SwipeRight(this.userId);

  @override
  List<Object?> get props => [userId];
}