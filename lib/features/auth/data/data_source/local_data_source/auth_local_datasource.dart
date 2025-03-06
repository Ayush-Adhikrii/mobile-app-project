import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/auth_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/model/auth_hive_model.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser() async {
    try {
      final userModel = await _hiveService.getData();
      if (userModel == null) {
        throw Exception('User not found in local storage');
      }
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get current user from local storage: $e');
    }
  }

  @override
  Future<(String, AuthEntity)> loginUser(
      String userName, String password) async {
    try {
      final userModel = await _hiveService.login(userName, password);
      // Store the userId in SharedPreferences to track the current user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', userModel!.userId!);
      // Since we're offline, we don't have a token; return an empty token
      return ('', userModel.toEntity());
    } catch (e) {
      throw Exception('Failed to login from local storage: $e');
    }
  }

  @override
  Future<AuthEntity> registerUser(AuthEntity user) async {
    try {
      final authHiveModel = AuthHiveModel.fromEntity(user);
      await _hiveService.register(authHiveModel);
      // Store the userId in SharedPreferences to track the current user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', authHiveModel.userId!);
      return authHiveModel.toEntity();
    } catch (e) {
      throw Exception('Failed to register user in local storage: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw Exception('Profile picture upload not supported offline');
  }
}
