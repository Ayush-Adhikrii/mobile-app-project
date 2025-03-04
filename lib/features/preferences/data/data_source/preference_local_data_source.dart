// // lib/features/preference/data/datasources/preference_local_datasource.dart
// import 'package:hive/hive.dart';
// import 'package:softwarica_student_management_bloc/app/constants/hive_table_constant.dart';
// import 'package:softwarica_student_management_bloc/core/network/hive_service.dart';

// import '../model/preferences_hive_model.dart';

// abstract class PreferenceLocalDataSource {
//   Future<void> savePreference(PreferencesHiveModel preference);
//   Future<PreferencesHiveModel?> getPreference(String userId);
// }

// class PreferenceLocalDataSourceImpl implements PreferenceLocalDataSource {
//   final HiveService hiveService;

//   PreferenceLocalDataSourceImpl(this.hiveService);

//   @override
//   Future<void> savePreference(PreferencesHiveModel preference) async {
//     try {
//       final box = await hiveService
//           .openBox<PreferencesHiveModel>(HiveTableConstant.preferenceBox);
//       await box.put(preference.userId, preference);
//       print('Saved preference locally for user: ${preference.userId}');
//     } catch (e) {
//       print('Error saving preference locally: $e');
//       throw Exception('Failed to save preference locally: $e');
//     }
//   }

//   @override
//   Future<PreferencesHiveModel?> getPreference(String userId) async {
//     try {
//       final box = await hiveService
//           .openBox<PreferencesHiveModel>(HiveTableConstant.preferenceBox);
//       final preference = box.get(userId);
//       print(
//           'Fetched preference locally for user: $userId - ${preference != null ? 'Found' : 'Not found'}');
//       return preference;
//     } catch (e) {
//       print('Error fetching preference locally: $e');
//       throw Exception('Failed to fetch preference locally: $e');
//     }
//   }
// }
