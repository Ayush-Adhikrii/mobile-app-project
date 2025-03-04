// lib/features/subscription/data/repositories/subscription_repository_impl.dart
import 'package:softwarica_student_management_bloc/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/entities/subscription_entity.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/repositories/subscription_repository.dart';

import '../models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<SubscriptionEntity> getSubscriptionExpiry(String userId) async {
    return await remoteDataSource.getSubscriptionExpiry(userId);
  }

  @override
  Future<void> saveSubscription(SubscriptionEntity subscriptionData) async {
    await remoteDataSource.saveSubscription(subscriptionData as SubscriptionModel);
  }
}