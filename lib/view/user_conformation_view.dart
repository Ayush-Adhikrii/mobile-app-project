import 'package:flutter/material.dart';
import 'package:hooked/view/dashboard_view.dart';

class UserConformationView extends StatefulWidget {
  const UserConformationView({super.key});

  @override
  State<UserConformationView> createState() => _UserConformationViewState();
}

class _UserConformationViewState extends State<UserConformationView> {
  // A list to keep track of the digits entered for verification
  List<String> verificationCode = ["", "", "", "", ""];

  // Function to handle the digit input
  void onChanged(String value, int index) {
    setState(() {
      verificationCode[index] = value;
    });

    if (value.isNotEmpty && index < 4) {
      // Automatically move to the next field after entering a digit
      FocusScope.of(context).nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFFDF5F7), // Light pink background for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      backgroundColor:
          const Color(0xFFFDF5F7), // Light pink background for the body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter verificaton code',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Please enter the verification code we sent you.',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Create a row of 5 circles for code entry
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.0), // Reduced gap between circles
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: verificationCode[index].isEmpty
                          ? Colors.white
                          : const Color(0xFFE03368), // Fill color for circle
                      border: Border.all(
                        color: const Color(0xFFE03368),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        verificationCode[index], // Display the digit
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: verificationCode[index].isEmpty
                              ? Colors.black
                              : Colors.white, // Text color for filled circles
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Create TextField for each circle (disabled)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      onChanged(value, index);
                    },
                    decoration: const InputDecoration(
                      counterText: "", // Hide the counter text
                      border: InputBorder.none, // Remove the border
                      hintText: "", // Remove hint text (_)
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: const TextStyle(fontSize: 1, height: 0.1),
                    enabled: true, // Keep the field enabled for typing
                    cursorColor:
                        Colors.transparent, // Remove the cursor visibility
                  ),
                );
              }),
            ),

            // Confirm button placed just below the circles
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle confirmation button press
                  print('Verification code: ${verificationCode.join()}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardView(),
                    ),
                  );
                  // Add your confirmation logic here
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFE03368)), // Button color
                  foregroundColor:
                      MaterialStateProperty.all(Colors.white), // Text color
                ),
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
