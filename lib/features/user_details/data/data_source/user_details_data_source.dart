import '../../domain/entity/user_details_entity.dart';

abstract interface class IUserDetailsDataSource {
  Future<void> addUserDetails(UserDetailsEntity details);
  Future<void> updateUserDetails(String userId, String key, String value);

  Future<UserDetailsEntity> getUserDetails();
}
