import 'package:flutter/material.dart';

class PeopleView extends StatefulWidget {
  const PeopleView({super.key});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Zeus,24',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Add a couple of images to display in the body
              Image.asset(
                'assets/images/image1.jpg', // Add your first image here
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/image2.jpg', // Add your second image here
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar with 5 icons
    );
  }
}
