// lib/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

import '../../../domain/use_case/update_profile_photo_use_case.dart';
import '../../../domain/use_case/update_profile_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<void> registerUser(AuthEntity user);
  Future<String> loginUser(String userName, String password);
  Future<String> uploadProfilePicture(File file);
  Future<AuthEntity> getCurrentUser();
  Future<AuthEntity> updateProfile(UpdateProfileParams params);
  Future<AuthEntity> uploadProfilePhoto(UploadProfilePhotoParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<void> registerUser(AuthEntity user) async {
    await _dio.post(
      '${ApiEndpoints.baseUrl}auth/signup',
      data: user.toJson(),
    );
  }

  @override
  Future<String> loginUser(String userName, String password) async {
    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}auth/login',
      data: {'userName': userName, 'password': password},
    );
    return response.data['token']
        as String; // Adjust based on your backend response
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    final formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });
    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}auth/uploadImage',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return response.data['data']
        as String; // Adjust based on your backend response
  }

  @override
  Future<AuthEntity> getCurrentUser() async {
    final response = await _dio.get('${ApiEndpoints.baseUrl}auth/me');
    return AuthEntity.fromJson(response.data['user']);
  }

  @override
  Future<AuthEntity> updateProfile(UpdateProfileParams params) async {
    final response = await _dio.put(
      '${ApiEndpoints.baseUrl}auth/update/${params.userId}',
      data: params.toJson(),
    );
    return AuthEntity.fromJson(response.data['user']);
  }

  @override
  Future<AuthEntity> uploadProfilePhoto(UploadProfilePhotoParams params) async {
    final formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(
        params.image.path,
        filename: params.image.path.split('/').last,
      ),
    });
    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}auth/uploadImage',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return AuthEntity.fromJson(response.data['user']);
  }
}
