// lib/features/subscription/data/models/subscription_model.dart
import 'package:softwarica_student_management_bloc/features/subscription/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    required super.userId,
    required super.subscriptionType,
    required super.subscribedOn,
    required super.expiresOn,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      userId:
          json['userId'] as String? ?? '', // Default to empty string if null
      subscriptionType: json['subscriptionType'] as String? ??
          'Unknown', // Default to 'Unknown' if null
      subscribedOn: DateTime.parse(
          json['subscribedOn'] as String? ?? DateTime.now().toIso8601String()),
      expiresOn: DateTime.parse(json['expiresOn'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'subscriptionType': subscriptionType,
      'subscribedOn': subscribedOn.toIso8601String(),
      'expiresOn': expiresOn.toIso8601String(),
    };
  }
}
