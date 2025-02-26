import 'package:dio/dio.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../model/user_details_api_model.dart';

abstract class IUserDetailsDataSource {
  Future<void> addUserDetails(UserDetailsApiModel details);
  Future<UserDetailsApiModel> getUserDetails(String userId);
  Future<void> updateUserDetails(String userId, String key, String value);
}

class UserDetailsRemoteDataSource implements IUserDetailsDataSource {
  final Dio _dio;

  UserDetailsRemoteDataSource(this._dio);

  @override
  Future<void> addUserDetails(UserDetailsApiModel details) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addUserDetails,
        data: details.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            "Failed to add user details: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error adding user details: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error adding user details: $e");
    }
  }

  @override
  Future<UserDetailsApiModel> getUserDetails(String userId) async {
    try {
      final response = await _dio.get(
        "${ApiEndpoints.getUserDetails}/$userId",
      );
      if (response.statusCode == 200) {
        return UserDetailsApiModel.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to get user details: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error getting user details: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error getting user details: $e");
    }
  }

  @override
  Future<void> updateUserDetails(
      String userId, String key, String value) async {
    try {
      final response = await _dio.put(
        "${ApiEndpoints.updateUserDetails}/$userId", // Updated endpoint with userId
        data: {key: value},
      );
      print(
          'updateUserDetails response: ${response.statusCode}, ${response.data}');
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update user details: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print(
          'DioException in updateUserDetails: ${e.message}, Response: ${e.response?.data}');
      throw Exception("Dio error updating user details: ${e.message}");
    } catch (e) {
      print('Unexpected error in updateUserDetails: $e');
      throw Exception("Unexpected error updating user details: $e");
    }
  }
}
