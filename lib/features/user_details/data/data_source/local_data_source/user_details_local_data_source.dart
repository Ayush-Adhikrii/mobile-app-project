import '../../../../../core/network/hive_service.dart';
import '../../../domain/entity/user_details_entity.dart';
import '../../model/user_details_hive_model.dart';
import '../user_details_data_source.dart';

class UserDetailsLocalDataSource implements IUserDetailsDataSource {
  final HiveService _hiveService;

  UserDetailsLocalDataSource(this._hiveService);

  @override
  Future<void> addUserDetails(UserDetailsEntity details) async {
    try {
      final userDetailsHiveModel = UserDetailsHiveModel.fromEntity(details);
      await _hiveService.addUserDetails(userDetailsHiveModel);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<UserDetailsEntity> getUserDetails() async {
    try {
      final userDetailsHiveModel = await _hiveService.getUserDetails();
      if (userDetailsHiveModel != null) {
        return Future.value(userDetailsHiveModel.toEntity());
      } else {
        // Handle the case where user details are not found.
        return Future.value(const UserDetailsEntity
            .empty()); // Or throw an error, depending on your requirements
      }
    } catch (e) {
      return Future.error(e);
    }
  }
  
  @override
  Future<void> updateUserDetails(String userId, String key, String value) {
    // TODO: implement updateUserDetails
    throw UnimplementedError();
  }
}
