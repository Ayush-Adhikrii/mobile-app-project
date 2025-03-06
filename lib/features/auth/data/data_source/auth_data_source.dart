import 'dart:io';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

abstract class IAuthDataSource {
  Future<(String, AuthEntity)> loginUser(String userName, String password);
  Future<AuthEntity> registerUser(AuthEntity user);
  Future<String> uploadProfilePicture(File file);
  Future<AuthEntity> getCurrentUser();
}