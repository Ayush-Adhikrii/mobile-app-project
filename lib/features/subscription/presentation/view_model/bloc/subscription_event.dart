// lib/features/subscription/presentation/bloc/subscription_event.dart
abstract class SubscriptionEvent {}

class GetSubscriptionExpiryEvent extends SubscriptionEvent {
  final String userId;

  GetSubscriptionExpiryEvent(this.userId);
}

class SaveSubscriptionEvent extends SubscriptionEvent {
  final String userId;
  final String subscriptionType;
  final int months;

  SaveSubscriptionEvent(this.userId, this.subscriptionType, this.months);
}