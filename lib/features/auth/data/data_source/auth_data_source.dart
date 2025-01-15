import 'dart:io';

import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthDataSource {
  Future<String> loginUser(String username, String password);

  Future<void> registerUser(AuthEntity student);

  Future<AuthEntity> getCurrentUser();

  Future<String> uploadProfilePicture(File file);
}
