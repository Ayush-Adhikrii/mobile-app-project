
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionExpiry {
  final SubscriptionRepository repository;

  GetSubscriptionExpiry(this.repository);

  Future<SubscriptionEntity> call(String userId) async {
    return await repository.getSubscriptionExpiry(userId);
  }
}