// lib/features/splash/presentation/view_model/splash_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view/home_view.dart';

import '../../../home/presentation/view_model/home_cubit.dart';

class SplashCubit extends Cubit<void> {
  final LoginBloc _loginBloc;

  SplashCubit(this._loginBloc) : super(null);

  void navigate(BuildContext context) {
    debugPrint('SplashCubit: Navigating');
    final authUser = _loginBloc.state.authUser;
    if (authUser != null) {
      debugPrint('SplashCubit: User logged in, navigating to HomeView');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<HomeCubit>(),
            child: const HomeView(),
          ),
        ),
      );
    } else {
      debugPrint('SplashCubit: No user, navigating to LoginView');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _loginBloc,
            child: const LoginView(),
          ),
        ),
      );
    }
  }
}
