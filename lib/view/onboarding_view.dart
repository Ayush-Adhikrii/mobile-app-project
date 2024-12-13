import 'package:flutter/material.dart';
import 'package:hooked/view/get_started.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Current card index
  int currentIndex = 0;

  // List of cards data
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F7), // Light pink background
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
              ),
            ),
          ),

          // Content section
          Column(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align the content at the bottom
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
                    // Dynamic Title with Proxima Nova font
                    Text(
                      onboardingData[currentIndex]["title"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'ProximaNova', // Set font here
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Dynamic Subtitle with Proxima Nova font
                    Text(
                      onboardingData[currentIndex]["subtitle"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'ProximaNova', // Set font here
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Progress indicator
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

                    // Gradient button
                    GestureDetector(
                      onTap: () {
                        if (currentIndex < onboardingData.length - 1) {
                          // Move to the next card
                          setState(() {
                            currentIndex++;
                          });
                        } else {
                          // Show "Get Started" action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GetStarted(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF84A7), // Starting color
                              Color(0xFFE03368), // Ending color
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
                            fontFamily: 'ProximaNova', // Set font here
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
