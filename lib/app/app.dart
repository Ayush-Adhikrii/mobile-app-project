import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view/splash_view.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (_) => getIt<LoginBloc>()), // Ensure LoginBloc is provided
        BlocProvider<SplashCubit>(
            create: (_) =>
                getIt<SplashCubit>()), // Ensure SplashCubit is provided
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hooked',
        theme: AppTheme.getApplicationTheme(isDarkMode: false),
        home: SplashView(), // Display SplashView initially
      ),
    );
  }
}
