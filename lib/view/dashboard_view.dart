import 'package:flutter/material.dart';
import 'package:hooked/view/explore_view.dart';
import 'package:hooked/view/likes_you_view.dart';
import 'package:hooked/view/people_view.dart';
import 'package:hooked/view/profile_view.dart';
import 'package:hooked/view/text_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 2;

  List<Widget> lstBottomScreen = [
    const ProfileView(),
    const ExploreView(),
    const PeopleView(),
    const LikesYouView(),
    const TextView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color(0xFFFDF5F7),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icons/plain_logo.png',
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
      body: lstBottomScreen[_selectedIndex],
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
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black, // Set the icons to solid black
            ),
            label: 'People',
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
        backgroundColor: const Color(0xFFFDF5F7),
        selectedItemColor: const Color(0xFFE03368),
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
