import '../../domain/entity/user_details_entity.dart';

abstract interface class IUserDetailsDataSource {
  Future<void> addDetails(UserDetailsEntity details);

  Future<UserDetailsEntity> getUserDetails();
}
