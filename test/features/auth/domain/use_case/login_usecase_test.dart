import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockUserRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUseCase usecase;

  setUp(() {
    repository = MockUserRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUseCase(repository, tokenSharedPrefs);

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));
  });

  test('should call login[valid username and pw]', () async {
    when(() => repository.loginUser(any(), any())).thenAnswer(
      (invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (email == 'ayush@gmail.com' && password == '1234') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
              const Left(ApiFailure(message: 'Invalid email or password')));
        }
      },
    );

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    final result = await usecase(const LoginParams(
      username: 'ayush@gmail.com',
      password: '1234',
    ));

    expect(result, const Right('token'));

    verify(() => repository.loginUser(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });

  test('should call login[invalid usernaem and password]', () async {
    when(() => repository.loginUser(any(), any())).thenAnswer(
      (invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (email == 'ayush@gmail.com' && password == '1234') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
              const Left(ApiFailure(message: 'Invalid email or password')));
        }
      },
    );

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    final result = await usecase(const LoginParams(
      username: 'ayush@gmail.com',
      password: '12345',
    ));

    expect(result, const Right('token'));

    verify(() => repository.loginUser(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);
    verify(() => tokenSharedPrefs.getToken()).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });

  test('should call login [invalid credentials and pass left api failure]',
      () async {
    when(() => repository.loginUser(any(), any())).thenAnswer(
      (invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;

        if (email == 'ayush@gmail.com' && password == '1234') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
              const Left(ApiFailure(message: 'Invalid email or password')));
        }
      },
    );

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    final result = await usecase(const LoginParams(
      username: 'ayush@gmail.com',
      password: '12345', // Wrong password to trigger failure
    ));

    expect(
        result, const Left(ApiFailure(message: 'Invalid email or password')));

    verify(() => repository.loginUser(any(), any())).called(1);
    verifyNever(() => tokenSharedPrefs.saveToken(any()));
    verifyNever(() => tokenSharedPrefs.getToken());

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });

  test('should call login [invalid credentials and pass left api failure]',
      () async {
    when(() => repository.loginUser(any(), any())).thenAnswer(
      (invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;

        if (email == 'ayush@gmail.com' && password == '1234') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
              const Left(ApiFailure(message: 'Invalid email or password')));
        }
      },
    );

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    final result = await usecase(const LoginParams(
      username: 'ayush@gmail.com',
      password: '1234', // right password so will triggure right
    ));

    expect(
        result, const Left(ApiFailure(message: 'Invalid email or password')));

    verify(() => repository.loginUser(any(), any())).called(1);
    verifyNever(() => tokenSharedPrefs.saveToken(any()));
    verifyNever(() => tokenSharedPrefs.getToken());

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
