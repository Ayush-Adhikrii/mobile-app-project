// lib/features/subscription/domain/entities/subscription_entity.dart
class SubscriptionEntity {
  final String userId;
  final String subscriptionType;
  final DateTime subscribedOn;
  final DateTime expiresOn;

  SubscriptionEntity({
    required this.userId,
    required this.subscriptionType,
    required this.subscribedOn,
    required this.expiresOn,
  });
}