import 'package:flutter/material.dart';

class SignupWithEmailView extends StatefulWidget {
  const SignupWithEmailView({super.key});

  @override
  State<SignupWithEmailView> createState() => _SignupWithEmailViewState();
}

class _SignupWithEmailViewState extends State<SignupWithEmailView> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode to trigger keyboard

  @override
  void initState() {
    super.initState();
    // Request focus to open the keyboard when the screen loads
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFFDF5F7), // Light pink background for AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            Text(
              'Enter your email address',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for title
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Please enter your email address to sign up',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey, // Text color for subtitle
              ),
            ),
            SizedBox(height: 16),
            // Container to wrap the email text field with added padding
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFFE03368)), // Primary color border
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0), // Add horizontal padding
                child: TextField(
                  controller: _emailController,
                  focusNode:
                      _focusNode, // Focus node attached to the text field
                  keyboardType: TextInputType.emailAddress, // Email keyboard
                  autofocus: true, // Ensure the keyboard shows up
                  decoration: InputDecoration(
                    border: InputBorder.none, // Remove inner border
                    hintText: 'Email Address',
                    hintStyle: TextStyle(color: Colors.grey), // Hint text color
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0), // Padding inside the field
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue button press
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFE03368)), // Button background color
                  foregroundColor: MaterialStateProperty.all(
                      Colors.white), // Button text color
                ),
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose(); // Clean up focus node
    super.dispose();
  }
}
