import 'package:flutter/material.dart';
import 'package:hooked/view/onboarding_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/onboard',
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard': (context) => const OnboardingScreen(),
      },
      theme: ThemeData(
        primarySwatch:
            Colors.pink, // You can adjust this as per your app's primary color
        fontFamily: 'ProximaNova', // Set the global font to Proxima Nova
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'ProximaNova'),
          bodyMedium: TextStyle(fontFamily: 'ProximaNova'),
          bodySmall: TextStyle(fontFamily: 'ProximaNova'),
          displayLarge: TextStyle(fontFamily: 'ProximaNova'),
          displayMedium: TextStyle(fontFamily: 'ProximaNova'),
          displaySmall: TextStyle(fontFamily: 'ProximaNova'),
          headlineLarge: TextStyle(fontFamily: 'ProximaNova'),
          headlineMedium: TextStyle(fontFamily: 'ProximaNova'),
          headlineSmall: TextStyle(fontFamily: 'ProximaNova'),
          titleLarge: TextStyle(fontFamily: 'ProximaNova'),
          titleMedium: TextStyle(fontFamily: 'ProximaNova'),
          titleSmall: TextStyle(fontFamily: 'ProximaNova'),
          labelLarge: TextStyle(fontFamily: 'ProximaNova'),
          labelMedium: TextStyle(fontFamily: 'ProximaNova'),
          labelSmall: TextStyle(fontFamily: 'ProximaNova'),
        ),
      ),
    );
  }
}
