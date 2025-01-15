import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/user_conformation_view.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';

class RegisterWithNumber extends StatefulWidget {
  const RegisterWithNumber({super.key});

  @override
  State<RegisterWithNumber> createState() => _RegisterWithNumberState();
}

class _RegisterWithNumberState extends State<RegisterWithNumber> {
  final TextEditingController _phoneController = TextEditingController();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: getIt<SplashCubit>(),
                  child: LoginView(),
                ),
              ),
            );
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
              'Enter your phone number',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for title
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please enter your phone number',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey, // Text color for subtitle
              ),
            ),
            const SizedBox(height: 16),
            // Container to wrap the dropdown and text field
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFFE03368)), // Primary color border
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Dropdown Button without internal border and light pink background
                  DropdownButton<String>(
                    value: '+977',
                    onChanged: (value) {
                      // Handle dropdown selection
                    },
                    dropdownColor: const Color(
                        0xFFFDF5F7), // Light pink background for dropdown options
                    style: const TextStyle(
                        color: Colors.black), // Text color inside dropdown
                    underline:
                        Container(), // Remove the underline (internal border)
                    items: ['+977', '+123', '+987', '+748']
                        .map((code) => DropdownMenuItem(
                              value: code,
                              child: Text(code),
                            ))
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextField(
                    controller: _phoneController,
                    focusNode:
                        _focusNode, // Focus node attached to the text field
                    keyboardType: TextInputType.phone, // Phone keyboard
                    autofocus: true, // Ensure the keyboard shows up
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Remove inner border
                      enabledBorder:
                          InputBorder.none, // Ensure no border when not focused
                      focusedBorder:
                          InputBorder.none, // Ensure no border when focused
                      hintText: 'Phone Number',
                      hintStyle:
                          TextStyle(color: Colors.grey), // Hint text color
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0), // Padding inside the field
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String number = _phoneController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserConformationView(
                        emailOrPhone: number,
                        isEmail: false,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color(0xFFE03368)), // Button background color
                  foregroundColor: WidgetStateProperty.all(
                      Colors.white), // Button text color
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
