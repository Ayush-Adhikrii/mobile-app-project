import 'dart:io';

import '../../domain/entity/auth_entity.dart';

abstract interface class IAuthDataSource {
  Future<String> loginUser(String userName, String password);

  Future<void> registerUser(AuthEntity student);

  Future<AuthEntity> getCurrentUser();

  Future<String> uploadProfilePicture(File file);
}
