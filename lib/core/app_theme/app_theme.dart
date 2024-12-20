import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: const Color(0xFFFDF5F7),
    fontFamily: 'Proxima Nova Regular',
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: Color(0xFFFDF5F7),
        elevation: 2,
        shadowColor: Colors.grey,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(150, 50),
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: 'Proxima Nova Bold',
        ),
        backgroundColor: const Color(0xFFE03368),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
