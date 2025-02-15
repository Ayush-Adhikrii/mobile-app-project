import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:softwarica_student_management_bloc/core/error/failure.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/use_case/login_usecase.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late LoginBloc loginBloc;
  late MockRegisterBloc mockRegisterBloc;
  late MockHomeCubit mockHomeCubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockBuildContext mockBuildContext;

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
    mockHomeCubit = MockHomeCubit();
    mockLoginUseCase = MockLoginUseCase();
    mockBuildContext = MockBuildContext();

    loginBloc = LoginBloc(
      registerBloc: mockRegisterBloc,
      homeCubit: mockHomeCubit,
      loginUseCase: mockLoginUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  tearDown(() {
    loginBloc.close();
  });

  test('initial state is LoginState.initial()', () {
    expect(loginBloc.state, equals(LoginState.initial()));
  });

  blocTest<LoginBloc, LoginState>(
    'emits [loading, failure] when login fails',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Left(ApiFailure(message: "api failure")));
      return loginBloc;
    },
    act: (bloc) => bloc.add(LoginUserEvent(
        userName: 'test', password: 'wrong', context: MockBuildContext())),
    expect: () => [
      LoginState.initial().copyWith(isLoading: true),
      LoginState.initial().copyWith(isLoading: false, isSuccess: false),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits [loading, success] and navigates to home on successful login',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Right('token123'));
      return loginBloc;
    },
    act: (bloc) => bloc.add(LoginUserEvent(
        userName: 'test', password: 'correct', context: MockBuildContext())),
    expect: () => [
      LoginState.initial().copyWith(isLoading: true),
      LoginState.initial().copyWith(isLoading: false, isSuccess: true),
    ],
  );
}
