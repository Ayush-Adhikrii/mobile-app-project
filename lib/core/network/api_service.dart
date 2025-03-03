import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
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
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('Interceptor - onRequest triggered for ${options.uri}'); // Debug
          final tokenSharedPrefs = getIt<TokenSharedPrefs>();
          final tokenResult = await tokenSharedPrefs.getToken();
          tokenResult.fold(
            (failure) => print('Interceptor - Token retrieval failed: ${failure.message}'),
            (token) {
              if (token.isNotEmpty) {
                // Try Authorization header
                options.headers['Authorization'] = 'Bearer $token';
                print('Interceptor - Added Authorization: Bearer $token');
                // Also try Cookie (for testing)
                options.headers['Cookie'] = 'jwt=$token';
                print('Interceptor - Added Cookie: jwt=$token');
              } else {
                print('Interceptor - Token is empty');
              }
            },
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Interceptor - Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('Interceptor - Error: ${e.response?.statusCode} - ${e.response?.data}');
          return handler.next(e);
        },
      ));
  }
}