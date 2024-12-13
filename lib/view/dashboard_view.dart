import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with image on left and filter icon on right
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF5F7),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icons/plain_logo.png', // Add your logo or image here
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.black, // Set the filter icon color to black
            ),
            onPressed: () {
              // Add filter functionality here
              print('Filter icon tapped');
            },
          ),
        ],
      ),
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
              const Text(
                'Some Content Below the Images',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar with 5 icons
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.black, // Set the icons to solid black
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black, // Set the icons to solid black
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black, // Set the icons to solid black
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.monitor_heart_outlined,
              color: Colors.black, // Set the icons to solid black
            ),
            label: 'Liked You',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Colors.black, // Set the icons to solid black
            ),
            label: 'Messages',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation tap
          print('Bottom navigation item $index tapped');
        },
      ),
    );
  }
}
