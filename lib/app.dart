import 'package:flutter/material.dart';
import 'package:hooked/core/app_theme/app_theme.dart';
import 'package:hooked/view/dashboard_view.dart';
import 'package:hooked/view/get_started_view.dart';
import 'package:hooked/view/onboarding_view.dart';
import 'package:hooked/view/signup_with_email_view.dart';
import 'package:hooked/view/signup_with_number_view.dart';
import 'package:hooked/view/user_conformation_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: ColumnView(),
    // );
    return MaterialApp(
      theme: getApplicationTheme(),
      initialRoute: '/onboard',
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard': (context) => const OnboardingScreen(),
        '/getstarted': (context) => const GetStartedView(),
        '/signupnumber': (context) => const SignupWithNumberView(),
        '/signupemail': (context) => const SignupWithEmailView(),
        '/conformation': (context) => const UserConformationView(),
        '/dashboard': (context) => const DashboardView(),
      },
    );
  }
}
