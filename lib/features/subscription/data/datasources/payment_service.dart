// lib/features/payment/data/datasources/payment_service.dart
import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';

class PaymentService {
  final Dio _dio;

  PaymentService(this._dio);

  Future<Map<String, dynamic>> createPayment({
    required String userId,
    required String subscriptionType,
    required int amount,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}payment/create',
        data: {
          'userId': userId,
          'subscriptionType': subscriptionType,
          'amount': amount,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Payment created successfully with response: ${response.data}');
        // Expect a response with formData
        if (response.data['formData'] != null) {
          return response.data;
        } else {
          throw Exception('Unexpected response format: Missing formData field');
        }
      } else {
        throw Exception('Failed to create payment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print(
          'DioException in createPayment: ${e.type}, Message: ${e.message}, Response: ${e.response?.data}, Error: ${e.error}');
      throw Exception(
          'Failed to create payment: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      print('Unexpected error in createPayment: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}