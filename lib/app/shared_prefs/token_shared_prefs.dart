import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  Future<Either<Failure, String>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token') ?? '';
      return Right(token);
    } catch (e) {
      return Left(TokenFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString('token', token);
      return const Right(null);
    } catch (e) {
      return Left(TokenFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveUserId(String userId) async {
    try {
      await _sharedPreferences.setString('current_user_id', userId);
      return const Right(null);
    } catch (e) {
      return Left(TokenFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> clearToken() async {
    try {
      await _sharedPreferences.remove('token');
      await _sharedPreferences.remove('current_user_id');
      return const Right(null);
    } catch (e) {
      return Left(TokenFailure(message: e.toString()));
    }
  }
}

class TokenFailure extends Failure {
  TokenFailure({required String message}) : super(message: message);
}
