import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String userName;
  final String password;

  const LoginParams({
    required this.userName,
    required this.password,
  });

  const LoginParams.initial()
      : userName = '',
        password = '';

  @override
  List<Object> get props => [userName, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await repository.loginUser(params.userName, params.password);
    return result.fold(
      (failure) => Left(failure),
      (token) async {
        final saveResult = await tokenSharedPrefs.saveToken(token);
        return saveResult.fold(
          (failure) => Left(failure),
          (_) async {
           return Right(token);
          },
        );
      },
    );
  }
}
