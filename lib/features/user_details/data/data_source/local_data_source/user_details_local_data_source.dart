import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';
import 'package:softwarica_student_management_bloc/features/user_details/data/model/user_details_hive_model.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

import '../user_details_data_source.dart';

class UserDetailsLocalDataSource implements IUserDetailsLocalDataSource {
  final HiveService _hiveService;

  UserDetailsLocalDataSource(this._hiveService);

  @override
  Future<void> addUserDetails(UserDetailsEntity details) async {
    try {
      print('UserDetailsLocalDataSource: Adding user details for userId: ${details.userId}');
      final hiveModel = UserDetailsHiveModel.fromEntity(details);
      await _hiveService.addUserDetails(hiveModel);
      print('UserDetailsLocalDataSource: Added user details for userId: ${details.userId}');
    } catch (e) {
      print('UserDetailsLocalDataSource: Failed to add user details: $e');
      throw Exception('Failed to add user details locally: $e');
    }
  }

  @override
  Future<UserDetailsEntity> getUserDetails(String userId) async {
    try {
      print('UserDetailsLocalDataSource: Fetching user details for userId: $userId');
      final hiveModel = await _hiveService.getUserDetails(userId);
      if (hiveModel == null) {
        throw Exception('User details not found in local storage for userId: $userId');
      }
      print('UserDetailsLocalDataSource: Fetched user details: ${hiveModel.toEntity().toJson()}');
      return hiveModel.toEntity();
    } catch (e) {
      print('UserDetailsLocalDataSource: Failed to fetch user details: $e');
      throw Exception('Failed to fetch user details from local storage: $e');
    }
  }

  @override
  Future<void> updateUserDetails(String userId, String key, String value) async {
    try {
      print('UserDetailsLocalDataSource: Updating user details for userId: $userId, key: $key, value: $value');
      final currentDetails = await getUserDetails(userId);
      final updatedDetails = _updateField(currentDetails, key, value);
      await _hiveService.addUserDetails(UserDetailsHiveModel.fromEntity(updatedDetails));
      print('UserDetailsLocalDataSource: Updated user details for userId: $userId');
    } catch (e) {
      print('UserDetailsLocalDataSource: Failed to update user details: $e');
      throw Exception('Failed to update user details locally: $e');
    }
  }

  UserDetailsEntity _updateField(UserDetailsEntity details, String key, String value) {
    switch (key) {
      case 'profession':
        return details.copyWith(profession: value);
      case 'education':
        return details.copyWith(education: value);
      case 'height':
        return details.copyWith(height: double.tryParse(value));
      case 'exercise':
        return details.copyWith(exercise: value);
      case 'drinks':
        return details.copyWith(drinks: value);
      case 'smoke':
        return details.copyWith(smoke: value);
      case 'kids':
        return details.copyWith(kids: value);
      case 'religion':
        return details.copyWith(religion: value);
      default:
        throw Exception('Invalid key for update: $key');
    }
  }
}