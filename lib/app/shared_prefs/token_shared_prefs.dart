import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      print('Saving token: $token'); // Debug
      await _sharedPreferences.setString('token', token);
      print('Token saved successfully'); // Debug
      return Right(null);
    } catch (e) {
      print('Save token error: $e'); // Debug
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> clearToken() async {
    try {
      await _sharedPreferences.setString('token', "");
      print('Token saved successfully'); // Debug
      return Right(null);
    } catch (e) {
      print('Save token error: $e'); // Debug
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      print('Retrieved token: $token'); // Debug
      return Right(token ?? '');
    } catch (e) {
      print('Get token error: $e'); // Debug
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
