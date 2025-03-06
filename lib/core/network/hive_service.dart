import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/app/constants/hive_table_constant.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/model/auth_hive_model.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/model/user_details_hive_model.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/hooked.db';
    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(UserDetailsHiveModelAdapter());
  }

  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      await box.put(auth.userId, auth);
      print('User registered in Hive: ${auth.userId}');
      await box.close();
    } catch (e) {
      print('Error registering user in Hive: $e');
      rethrow;
    }
  }

  Future<AuthHiveModel?> getData() async {
    try {
      // Get the current userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('current_user_id');
      if (userId == null) {
        print('No userId found in SharedPreferences');
        return null;
      }

      // Fetch the user from Hive using the userId
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      final user = box.get(userId);
      print('User fetched from Hive: ${user?.userId}');
      await box.close();
      return user;
    } catch (e) {
      print('Error fetching user data from Hive: $e');
      rethrow;
    }
  }

  Future<AuthHiveModel?> getUserById(String userId) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      final user = box.get(userId);
      print('User fetched from Hive by ID ($userId): ${user?.userId}');
      await box.close();
      return user;
    } catch (e) {
      print('Error fetching user by ID ($userId) from Hive: $e');
      rethrow;
    }
  }

  Future<void> updateUser(AuthHiveModel auth) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      await box.put(auth.userId, auth);
      print('User updated in Hive: ${auth.userId}');
      await box.close();
    } catch (e) {
      print('Error updating user in Hive: $e');
      rethrow;
    }
  }

  Future<void> deleteAuth(String id) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      await box.delete(id);
      print('User deleted from Hive: $id');
      await box.close();
    } catch (e) {
      print('Error deleting user from Hive: $e');
      rethrow;
    }
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      final users = box.values.toList();
      print('Fetched ${users.length} users from Hive');
      await box.close();
      return users;
    } catch (e) {
      print('Error fetching all users from Hive: $e');
      rethrow;
    }
  }

  Future<AuthHiveModel?> login(String userName, String password) async {
    try {
      var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
      final user = box.values.firstWhere(
        (element) =>
            element.userName == userName && element.password == password,
        orElse: () => throw Exception('Invalid credentials'),
      );
      print('User logged in from Hive: ${user.userId}');
      await box.close();
      return user;
    } catch (e) {
      print('Error logging in from Hive: $e');
      rethrow;
    }
  }

  // User Details Queries
  Future<void> addUserDetails(UserDetailsHiveModel userDetails) async {
    try {
      var box = await Hive.openBox<UserDetailsHiveModel>(
          HiveTableConstant.userDetailsBox);
      print('Adding user details to Hive: ${userDetails.toJson()}');
      await box.put(userDetails.userId, userDetails);
      print('User details added to Hive: ${userDetails.userId}');
      await box.close();
    } catch (e) {
      print('Error adding user details to Hive: $e');
      rethrow;
    }
  }

  Future<UserDetailsHiveModel?> getUserDetails(String userId) async {
    try {
      var box = await Hive.openBox<UserDetailsHiveModel>(
          HiveTableConstant.userDetailsBox);
      final userDetails = box.get(userId);
      if (userDetails != null) {
        print('User details fetched from Hive: ${userDetails.toJson()}');
      } else {
        print('No user details found in Hive for userId: $userId');
      }
      await box.close();
      return userDetails;
    } catch (e) {
      print('Error fetching user details from Hive: $e');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
      await Hive.deleteBoxFromDisk(HiveTableConstant.userDetailsBox);
      print('Cleared all data from Hive');
    } catch (e) {
      print('Error clearing all data from Hive: $e');
      rethrow;
    }
  }

  Future<void> clearUserBox() async {
    try {
      await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
      print('Cleared user box from Hive');
    } catch (e) {
      print('Error clearing user box from Hive: $e');
      rethrow;
    }
  }
}
