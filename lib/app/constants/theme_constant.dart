// app/constants/theme_constant.dart
import 'package:flutter/material.dart';

class ThemeConstant {
  ThemeConstant._();

  // Light mode colors
  static const Color primaryColor = Color(0xFFE91E63); // Pink
  static const Color secondaryColor = Color(0xFF7B1FA2); // Purple
  static const Color backgroundColor = Color(0xFFFCE4EC); // Light pink background
  static const Color surfaceColor = Colors.white;
  static const Color onSurfaceColor = Colors.black87;
  static const Color onBackgroundColor = Colors.black87;
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Colors.green;

  // Dark mode colors
  static const Color darkPrimaryColor = Color(0xFFF06292); // Lighter pink for dark mode
  static const Color darkSecondaryColor = Color(0xFFAB47BC); // Lighter purple for dark mode
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark background
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkOnSurfaceColor = Colors.white70;
  static const Color darkOnBackgroundColor = Colors.white70;
  static const Color darkErrorColor = Colors.redAccent;
  static const Color darkSuccessColor = Colors.greenAccent;

  // AppBar colors
  static const Color appBarColor = Colors.transparent; // Transparent AppBar for gradient background
  static const Color appBarTextColor = Colors.white;

  // Gradients
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFCE4EC), // Light pink
      Color(0xFFE1BEE7), // Light purple
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1E1E), // Dark gray
      Color(0xFF2C2C2C), // Slightly lighter gray
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE91E63), // Pink
      Color(0xFF7B1FA2), // Purple
    ],
  );

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // Padding and spacing
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  // Border radius
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 16.0;
  static const double largeBorderRadius = 30.0;

  // Font sizes (will be scaled for responsiveness)
  static const double headingFontSize = 28.0;
  static const double subheadingFontSize = 20.0;
  static const double bodyFontSize = 16.0;
  static const double buttonFontSize = 16.0;
  static const double captionFontSize = 14.0;

  // Icon sizes
  static const double smallIconSize = 24.0;
  static const double mediumIconSize = 32.0;
  static const double largeIconSize = 48.0;
}