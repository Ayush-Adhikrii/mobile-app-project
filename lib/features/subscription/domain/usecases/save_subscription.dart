// lib/features/subscription/domain/usecases/save_subscription.dart
import 'package:softwarica_student_management_bloc/features/subscription/domain/entities/subscription_entity.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/repositories/subscription_repository.dart';

class SaveSubscription {
  final SubscriptionRepository repository;

  SaveSubscription(this.repository);

  Future<void> call(SubscriptionEntity subscriptionData) async {
    await repository.saveSubscription(subscriptionData);
  }
}
