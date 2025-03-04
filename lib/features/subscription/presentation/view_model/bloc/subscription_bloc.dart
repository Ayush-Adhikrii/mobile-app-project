// lib/features/subscription/presentation/bloc/subscription_bloc.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/entities/subscription_entity.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/usecases/get_subscription_expiry.dart';
import 'package:softwarica_student_management_bloc/features/subscription/domain/usecases/save_subscription.dart';

import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptionExpiry getSubscriptionExpiry;
  final SaveSubscription saveSubscription;

  SubscriptionBloc(this.getSubscriptionExpiry, this.saveSubscription)
      : super(SubscriptionInitial()) {
    on<GetSubscriptionExpiryEvent>(_onGetSubscriptionExpiry);
    on<SaveSubscriptionEvent>(_onSaveSubscription);
  }

  Future<void> _onGetSubscriptionExpiry(
      GetSubscriptionExpiryEvent event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final subscription = await getSubscriptionExpiry(event.userId);
      final isValid = subscription.expiresOn.isAfter(DateTime.now());
      print(
          'Subscription expiry: ${subscription.expiresOn}, Is valid: $isValid');
      emit(SubscriptionLoaded(subscription, isValid));
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print(
            'No subscription found for user ${event.userId}, emitting SubscriptionNotFound');
        emit(SubscriptionNotFound(false));
      } else {
        String errorMessage = 'Failed to fetch subscription';
        if (e is DioException && e.response != null) {
          errorMessage = e.response?.data['message']?.toString() ??
              e.message ??
              errorMessage;
        } else {
          errorMessage = e.toString();
        }
        print('Error fetching subscription: $errorMessage');
        emit(SubscriptionError(errorMessage));
      }
    }
  }

  Future<void> _onSaveSubscription(
      SaveSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final subscriptionData = SubscriptionEntity(
        userId: event.userId,
        subscriptionType: event.subscriptionType,
        subscribedOn: DateTime.now(),
        expiresOn: DateTime.now().add(Duration(days: event.months * 30)),
      );
      await saveSubscription(subscriptionData);
      final isValid = subscriptionData.expiresOn.isAfter(DateTime.now());
      emit(SubscriptionLoaded(subscriptionData, isValid));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
