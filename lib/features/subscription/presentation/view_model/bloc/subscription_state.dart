// lib/features/subscription/presentation/bloc/subscription_state.dart
import 'package:softwarica_student_management_bloc/features/subscription/domain/entities/subscription_entity.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final SubscriptionEntity subscription;
  final bool isValid;

  SubscriptionLoaded(this.subscription, this.isValid);
}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);
}

class SubscriptionNotFound extends SubscriptionState {
  final bool isValid;

  SubscriptionNotFound(this.isValid);
}