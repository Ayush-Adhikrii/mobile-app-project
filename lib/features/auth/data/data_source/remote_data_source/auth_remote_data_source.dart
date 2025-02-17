import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../domain/entity/auth_entity.dart';
import '../auth_data_source.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<AuthEntity> getCurrentUser() {
    return Future.value(AuthEntity(
      userId: "",
      name: "",
      email: null,
      phoneNumber: "",
      userName: "",
      password: "",
      gender: null,
      // birthDate: null,
      starSign: null,
      bio: null,
      profilePhoto: "",
    ));
  }

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      print("User: ${user.profilePhoto}");
      Response response = await _dio.post(
        ApiEndpoints.register,
        data: {
          "name": user.name,
          "gender": user.gender,
          "email": user.email,
          // "birthDate": user.birthDate,
          "starSign": user.starSign,
          "bio": user.bio,
          "phoneNumber": user.phoneNumber,
          "userName": user.userName,
          "password": user.password,
          "profilePhoto": user.profilePhoto,
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'profilePicture': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        },
      );

      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Extract the image name from the response
        final str = response.data['filename'];
        print("Image name: $str");
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
