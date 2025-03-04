// lib/features/subscription/domain/repositories/subscription_repository.dart
import 'package:softwarica_student_management_bloc/features/subscription/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionEntity> getSubscriptionExpiry(String userId);
  Future<void> saveSubscription(SubscriptionEntity subscriptionData);
}