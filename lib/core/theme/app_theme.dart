import 'package:flutter/material.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getApplicationTheme({required bool isDarkMode}) {
    final Color primaryColor = isDarkMode ? ThemeConstant.darkPrimaryColor : ThemeConstant.primaryColor;
    final Color secondaryColor = isDarkMode ? ThemeConstant.darkSecondaryColor : ThemeConstant.secondaryColor;
    final Color backgroundColor = isDarkMode ? ThemeConstant.darkBackgroundColor : ThemeConstant.backgroundColor;
    final Color surfaceColor = isDarkMode ? ThemeConstant.darkSurfaceColor : ThemeConstant.surfaceColor;
    final Color onSurfaceColor = isDarkMode ? ThemeConstant.darkOnSurfaceColor : ThemeConstant.onSurfaceColor;
    final Color onBackgroundColor = isDarkMode ? ThemeConstant.darkOnBackgroundColor : ThemeConstant.onBackgroundColor;
    final Color errorColor = isDarkMode ? ThemeConstant.darkErrorColor : ThemeConstant.errorColor;
    final Color successColor = isDarkMode ? ThemeConstant.darkSuccessColor : ThemeConstant.successColor;
    final LinearGradient scaffoldGradient = isDarkMode ? ThemeConstant.darkGradient : ThemeConstant.lightGradient;

    return ThemeData(
      colorScheme: ColorScheme(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        background: backgroundColor,
        onBackground: onBackgroundColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        error: errorColor,
        onError: Colors.white,
      ),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: 'Montserrat',
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: ThemeConstant.appBarColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ThemeConstant.appBarTextColor,
          fontSize: ThemeConstant.subheadingFontSize,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: ThemeConstant.appBarTextColor,
          size: ThemeConstant.mediumIconSize,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: ThemeConstant.headingFontSize,
          fontWeight: FontWeight.bold,
          color: onBackgroundColor,
        ),
        displayMedium: TextStyle(
          fontSize: ThemeConstant.subheadingFontSize,
          fontWeight: FontWeight.bold,
          color: onBackgroundColor,
        ),
        bodyLarge: TextStyle(
          fontSize: ThemeConstant.bodyFontSize,
          color: onBackgroundColor,
        ),
        bodyMedium: TextStyle(
          fontSize: ThemeConstant.captionFontSize,
          color: onBackgroundColor.withOpacity(0.7),
        ),
        labelLarge: TextStyle(
          fontSize: ThemeConstant.buttonFontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ThemeConstant.mediumPadding,
            horizontal: ThemeConstant.largePadding,
          ),
          elevation: 0,
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.all(primaryColor.withOpacity(0.1)),
          side: WidgetStateProperty.all(BorderSide.none),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        labelStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(
          color: onSurfaceColor.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        prefixIconColor: primaryColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: ThemeConstant.mediumPadding,
          horizontal: ThemeConstant.mediumPadding,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: onSurfaceColor.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: ThemeConstant.captionFontSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: ThemeConstant.captionFontSize,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
        ),
        shadowColor: Colors.black12,
        margin: EdgeInsets.all(ThemeConstant.mediumPadding),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: TextStyle(
          color: onSurfaceColor,
          fontSize: ThemeConstant.bodyFontSize,
        ),
        actionTextColor: primaryColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstant.smallBorderRadius),
        ),
      ),
      iconTheme: IconThemeData(
        color: onSurfaceColor,
        size: ThemeConstant.mediumIconSize,
      ),
      extensions: [
        CustomThemeExtension(
          scaffoldGradient: scaffoldGradient,
          buttonGradient: ThemeConstant.buttonGradient,
          cardShadow: isDarkMode ? ThemeConstant.darkCardShadow : ThemeConstant.cardShadow,
        ),
      ],
    );
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final LinearGradient scaffoldGradient;
  final LinearGradient buttonGradient;
  final List<BoxShadow> cardShadow;

  CustomThemeExtension({
    required this.scaffoldGradient,
    required this.buttonGradient,
    required this.cardShadow,
  });

  @override
  CustomThemeExtension copyWith({
    LinearGradient? scaffoldGradient,
    LinearGradient? buttonGradient,
    List<BoxShadow>? cardShadow,
  }) {
    return CustomThemeExtension(
      scaffoldGradient: scaffoldGradient ?? this.scaffoldGradient,
      buttonGradient: buttonGradient ?? this.buttonGradient,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      scaffoldGradient: scaffoldGradient,
      buttonGradient: buttonGradient,
      cardShadow: cardShadow,
    );
  }
}

extension CustomTheme on ThemeData {
  CustomThemeExtension get customThemeExtension => extension<CustomThemeExtension>()!;
}