import 'package:softwarica_student_management_bloc/features/user_details/data/model/user_details_api_model.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';

// Interface for remote data source
abstract interface class IUserDetailsRemoteDataSource {
  Future<void> addUserDetails(UserDetailsApiModel details);
  Future<UserDetailsApiModel> getUserDetails(String userId);
  Future<void> updateUserDetails(String userId, String key, String value);
}

// Interface for local data source
abstract interface class IUserDetailsLocalDataSource {
  Future<void> addUserDetails(UserDetailsEntity details);
  Future<UserDetailsEntity> getUserDetails(String userId);
  Future<void> updateUserDetails(String userId, String key, String value);
}