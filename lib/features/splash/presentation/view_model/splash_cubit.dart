import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._loginBloc) : super(null);

  final LoginBloc _loginBloc;

  void init(BuildContext context) {
    // Delay navigation to the next screen (e.g., LoginView) for 2 seconds
    Future.delayed(const Duration(days: 1), () {
      debugPrint('SplashCubit: Initializing navigation');
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<LoginBloc>.value(
              value: _loginBloc, // Pass LoginBloc to the next screen
              child: LoginView(), // Navigate to LoginView after splash
            ),
          ),
        );
      }
    });
  }
}
