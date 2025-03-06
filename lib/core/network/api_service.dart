import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/core/network/dio_error_interceptor.dart';
import 'package:softwarica_student_management_bloc/app/shared_prefs/token_shared_prefs.dart';

import '../../app/di/di.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      // Enable credentials for cross-origin requests
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('Interceptor - onRequest triggered for ${options.uri}');
          String token = '';

          // Try retrieving token from TokenSharedPrefs
          final tokenSharedPrefs = getIt<TokenSharedPrefs>();
          final tokenResult = await tokenSharedPrefs.getToken();
          tokenResult.fold(
            (failure) {
              print('Interceptor - Token retrieval failed: ${failure.message}');
            },
            (retrievedToken) {
              token = retrievedToken;
            },
          );

          // Fallback to SharedPreferences if TokenSharedPrefs fails
          if (token.isEmpty) {
            final prefs = await SharedPreferences.getInstance();
            token = prefs.getString('jwt_token') ?? '';
            print('Interceptor - Fallback to SharedPreferences, token: $token');
          }

          // Attach token to Cookie header if available
          if (token.isNotEmpty) {
            options.headers['Cookie'] = 'jwt=$token';
            print('Interceptor - Added Cookie: jwt=$token');
          } else {
            print('Interceptor - Token is empty, proceeding without token');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Interceptor - Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Interceptor - Error: ${e.response?.statusCode} - ${e.response?.data}');
          return handler.next(e);
        },
      ));
  }
}