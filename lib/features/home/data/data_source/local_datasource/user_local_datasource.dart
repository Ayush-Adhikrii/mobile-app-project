import 'package:hive_flutter/hive_flutter.dart';
import 'package:softwarica_student_management_bloc/app/constants/hive_table_constant.dart';
import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/model/auth_hive_model.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/model/user_details_hive_model.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

import '../../../../auth/domain/entity/auth_entity.dart';

class UserLocalDataSource {
  final HiveService _hiveService;

  UserLocalDataSource(this._hiveService);

  Future<void> addUser(AuthHiveModel authHiveModel) async {
    await _hiveService.register(authHiveModel);
  }

  Future<List<UserEntity>> getUsers(
      List<AuthEntity> users, List<UserDetailsEntity> userDetailsList) async {
    try {
      // Open the userBox for AuthHiveModel
      var userBox =
          await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      // Open the userDetailsBox for UserDetailsHiveModel
      var userDetailsBox = await Hive.openBox<UserDetailsHiveModel>(
          HiveTableConstant.userDetailsBox);

      // Step 1: Add users to userBox
      for (var user in users) {
        final authHiveModel = AuthHiveModel(
          userId: user.userId,
          name: user.name,
          userName: user.userName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          password: user.password,
          gender: user.gender,
          birthDate: user.birthDate,
          starSign: user.starSign,
          bio: user.bio,
          profilePhoto: user.profilePhoto,
        );
        print('Adding user to Hive: ${authHiveModel.userId}');
        await userBox.put(authHiveModel.userId, authHiveModel);
        print('User registered in Hive: ${authHiveModel.userId}');
      }

      // Step 2: Add user details to userDetailsBox
      for (var userDetails in userDetailsList) {
        final userDetailsHiveModel =
            UserDetailsHiveModel.fromEntity(userDetails);
        print('Adding user details to Hive: ${userDetailsHiveModel.toJson()}');
        await userDetailsBox.put(
            userDetailsHiveModel.userId, userDetailsHiveModel);
        print('User details added to Hive: ${userDetailsHiveModel.userId}');
      }

      // Step 3: Fetch all users from userBox
      final authUsers = userBox.values.toList();
      print('Fetched ${authUsers.length} users from Hive');
      final userEntities = authUsers.map((authHiveModel) {
        return UserEntity(
          id: authHiveModel.userId!,
          name: authHiveModel.name,
          userName: authHiveModel.userName,
          email: authHiveModel.email,
          phoneNumber: authHiveModel.phoneNumber,
          gender: authHiveModel.gender,
          birthDate: authHiveModel.birthDate,
          starSign: authHiveModel.starSign,
          bio: authHiveModel.bio,
          profilePhoto: authHiveModel.profilePhoto,
        );
      }).toList();



      return userEntities;
    } catch (e) {
      print('Error in UserLocalDataSource: $e');
      rethrow;
    }
  }

  Future<void> addUserDetails(UserDetailsHiveModel userDetails) async {
    await _hiveService.addUserDetails(userDetails);
  }
}
