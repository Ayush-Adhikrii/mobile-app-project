// lib/features/auth/presentation/view_model/login/login_bloc.dart
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../../../app/di/di.dart';
import '../../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../../core/common/snackbar/my_snackbar.dart';
import '../../../../home/presentation/view/home_view.dart';
import '../../../../home/presentation/view_model/home_cubit.dart';
import '../../../domain/entity/auth_entity.dart';
import '../../../domain/use_case/get_current_user_use_case.dart';
import '../../../domain/use_case/login_usecase.dart';
import '../signup/register_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc _registerBloc;
  final HomeCubit _homeCubit;
  final LoginUseCase _loginUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  LoginBloc({
    required RegisterBloc registerBloc,
    required HomeCubit homeCubit,
    required LoginUseCase loginUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _registerBloc = registerBloc,
        _homeCubit = homeCubit,
        _loginUseCase = loginUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(LoginState.initial()) {
    on<NavigateRegisterScreenEvent>((event, emit) {
      if (!isClosed) {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [BlocProvider.value(value: _registerBloc)],
              child: event.destination,
            ),
          ),
        );
      } else {
        print('LoginBloc is closed, cannot navigate to register');
      }
    });

    on<NavigateHomeScreenEvent>((event, emit) {
      _homeCubit.onTabTapped(2);
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _homeCubit,
            child: event.destination,
          ),
        ),
      );
    });

    on<LoginUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await _loginUseCase(
        LoginParams(userName: event.userName, password: event.password),
      );
      await result.fold(
        (failure) async {
          print('Login failed: ${failure.message}');
          emit(state.copyWith(isLoading: false, isSuccess: false));
          showMySnackBar(
            context: event.context,
            message: "Invalid Credentials",
            color: Colors.red,
          );
        },
        (token) async {
          print('Login succeeded, token: $token');
          emit(state.copyWith(isLoading: false, isSuccess: true));
          final userResult = await _getCurrentUserUseCase();
          await userResult.fold(
            (failure) async {
              print('FetchCurrentUser failed: ${failure.message}');
              emit(state.copyWith(isLoading: false, isSuccess: false));
              showMySnackBar(
                context: event.context,
                message: "Failed to fetch user: ${failure.message}",
                color: Colors.red,
              );
            },
            (user) async {
              print('FetchCurrentUser succeeded: ${user.name}, ${user.userId}');
              emit(state.copyWith(isLoading: false, authUser: user));
              add(NavigateHomeScreenEvent(
                context: event.context,
                destination: const HomeView(),
              ));
            },
          );
        },
      );
    });

    on<FetchCurrentUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await _getCurrentUserUseCase();
      result.fold(
        (failure) {
          print('FetchCurrentUser failed: ${failure.message}');
          emit(state.copyWith(isLoading: false, isSuccess: false));
          showMySnackBar(
            context: event.context,
            message: "Failed to fetch user: ${failure.message}",
            color: Colors.red,
          );
        },
        (user) {
          print('FetchCurrentUser succeeded: ${user.name}, ${user.userId}');
          emit(state.copyWith(isLoading: false, authUser: user));
        },
      );
    });

    on<LogoutUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await getIt<TokenSharedPrefs>().clearToken();
        print('Logout succeeded, token cleared');
        emit(LoginState.initial());
        Navigator.pushReplacementNamed(event.context, '/login');
      } catch (e) {
        print('Logout failed: $e');
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: "Logout failed: $e",
          color: Colors.red,
        );
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final response = await getIt<Dio>().put(
          '${ApiEndpoints.baseUrl}/user/password',
          data: {
            'oldPassword': event.oldPassword,
            'newPassword': event.newPassword
          },
        );
        if (response.statusCode == 200) {
          print('Password change succeeded');
          emit(state.copyWith(isLoading: false, isSuccess: true));
          showMySnackBar(
            context: event.context,
            message: "Password changed successfully",
            color: Colors.green,
          );
        } else {
          throw Exception("Failed to change password");
        }
      } catch (e) {
        print('Password change failed: $e');
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: "Password change failed: $e",
          color: Colors.red,
        );
      }
    });
  }
}
