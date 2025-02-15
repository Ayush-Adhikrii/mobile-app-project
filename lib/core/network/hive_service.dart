import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../app/constants/hive_table_constant.dart';
import '../../features/auth/data/model/auth_hive_model.dart';
import '../../features/user_details/data/model/user_details_hive_model.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}hooked.db';

    Hive.init(path);

    // Register Adapters

    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<AuthHiveModel?> getData() async {
    var box = await Hive.openBox<AuthHiveModel>('authBox');
    return box.get(
        'userKey'); // Replace 'userKey' with the actual key used to save the user.
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Login using username and password
  Future<AuthHiveModel?> login(String username, String password) async {
    // var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    // var auth = box.values.firstWhere(
    //     (element) =>
    //         element.username == username && element.password == password,
    //     orElse: () => AuthHiveModel.initial());
    // return auth;

    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere((element) =>
        element.userName == username && element.password == password);
    box.close();
    return user;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Clear user Box
  Future<void> clearUserBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  //for user details

  Future<void> addUserDetails(UserDetailsHiveModel userDetails) async {
    try {
      final box = await Hive.openBox<UserDetailsHiveModel>('userDetailsBox');
      await box.put(userDetails.userId, userDetails); // Use userId as the key
    } catch (e) {
      print('Error adding user details: $e');
      rethrow;
    }
  }

  Future<UserDetailsHiveModel?> getUserDetails() async {
    try {
      final box = await Hive.openBox<UserDetailsHiveModel>('userDetailsBox');
      // Assuming you are only storing one user details, you can fetch it like this:
      if (box.isNotEmpty) {
        return box.values.first;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user details: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    await Hive.close();
  }
}
