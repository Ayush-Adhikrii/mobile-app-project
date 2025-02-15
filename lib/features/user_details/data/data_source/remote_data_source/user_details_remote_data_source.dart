import 'package:dio/dio.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../domain/entity/user_details_entity.dart';
import '../user_details_data_source.dart';

class UserDetailsRemoteDataSource implements IUserDetailsDataSource {
  final Dio _dio;

  UserDetailsRemoteDataSource(this._dio);

  @override
  Future<void> addDetails(UserDetailsEntity details) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.addUserDetails, // Replace with your actual endpoint
        data: {
          "userId": details.userId,
          "profession": details.profession,
          "education": details.education,
          "height": details.height,
          "exercise": details.exercise,
          "drinks": details.drinks,
          "smoke": details.smoke,
          "kids": details.kids,
          "religion": details.religion,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success (200 OK or 201 Created)
        return;
      } else {
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
  Future<UserDetailsEntity> getUserDetails() async {
    try {
      Response response = await _dio.get(
        ApiEndpoints.getUserDetails, // Replace with your actual endpoint
        // You might need to pass a userId as a query parameter or in the path
        // e.g., ApiEndpoints.getUserDetails + '?userId=${someUserId}'
      );

      if (response.statusCode == 200) {
        // Success
        final data = response.data;
        return UserDetailsEntity(
          userId:
              data['userId'] ?? '', // Provide a default value if userId is null
          profession: data['profession'],
          education: data['education'],
          height:
              (data['height'] as num?)?.toDouble(), // Handle num? to double?
          exercise: data['exercise'],
          drinks: data['drinks'],
          smoke: data['smoke'],
          kids: data['kids'],
          religion: data['religion'],
        );
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
}
