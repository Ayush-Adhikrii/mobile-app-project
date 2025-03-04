// lib/features/splash/presentation/view/splash_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Find your partner with us",
      "subtitle":
          "Discover meaningful connections\nand start your journey today.",
    },
    {
      "title": "Build your connections",
      "subtitle": "Connect with people who share\nyour interests and values.",
    },
    {
      "title": "Start your journey today",
      "subtitle": "Take the first step to find the\nrelationship you deserve.",
    },
  ];

  @override
  void initState() {
    super.initState();
    print('SplashView initState');
  }

  @override
  Widget build(BuildContext context) {
    print('SplashView build called');
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7),
      body: Stack(
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: Image.asset(
                "assets/icons/pink_logo.jpg",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Image load error: $error');
                  return const Text('Logo failed to load');
                },
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      onboardingData[currentIndex]["title"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'ProximaNova',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      onboardingData[currentIndex]["subtitle"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'ProximaNova',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? Colors.pinkAccent
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        debugPrint("Navigation tapped");
                        if (currentIndex < onboardingData.length - 1) {
                          setState(() {
                            currentIndex++;
                          });
                        } else {
                          debugPrint("Navigating to next screen");
                          context.read<SplashCubit>().navigate(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF84A7),
                              Color(0xFFE03368),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          currentIndex < onboardingData.length - 1
                              ? "Next"
                              : "Get Started",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'ProximaNova',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
