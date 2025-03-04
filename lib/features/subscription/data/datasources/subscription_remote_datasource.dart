// lib/features/subscription/data/datasources/subscription_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/subscription/data/models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<SubscriptionModel> getSubscriptionExpiry(String userId);
  Future<void> saveSubscription(SubscriptionModel subscriptionData);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio _dio;

  SubscriptionRemoteDataSourceImpl(this._dio);

  @override
  Future<SubscriptionModel> getSubscriptionExpiry(String userId) async {
    try {
      final response =
          await _dio.get('${ApiEndpoints.baseUrl}subscription/$userId');
      if (response.statusCode == 200) {
        return SubscriptionModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch subscription: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in getSubscriptionExpiry: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Error: ${e.error}');
      rethrow; // Rethrow the DioException
    } catch (e) {
      print('Unexpected error in getSubscriptionExpiry: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> saveSubscription(SubscriptionModel subscriptionData) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}subscription',
        data: subscriptionData.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to save subscription: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to save subscription: ${e.message}');
    }
  }
}
