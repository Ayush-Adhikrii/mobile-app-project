import 'package:flutter/material.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      colorScheme: isDarkMode
          ? const ColorScheme.dark(
              primary: ThemeConstant.darkPrimaryColor,
            )
          : const ColorScheme.light(
              primary: ThemeConstant.primaryColor,
            ),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: 'Montserrat',
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: ThemeConstant.appBarColor,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Border radius
          ),
          // Define the gradient
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        ).copyWith(
          // Add gradient decoration
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          side: WidgetStateProperty.all(BorderSide.none),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: ThemeConstant.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ThemeConstant.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ThemeConstant.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red),
        ),
        prefixIconColor: ThemeConstant.primaryColor,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ThemeConstant.primaryColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ThemeConstant.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
