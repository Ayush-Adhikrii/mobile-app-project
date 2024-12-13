import 'package:flutter/material.dart';
import 'package:hooked/view/get_started.dart';
import 'package:hooked/view/onboarding_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: ColumnView(),
    // );
    return MaterialApp(
      initialRoute: '/onboard',
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard': (context) => const OnboardingScreen(),
        '/getstarted': (context) => const GetStarted(),
      },
    );
  }
}
