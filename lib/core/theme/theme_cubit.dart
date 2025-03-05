import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define ThemeState
class ThemeState {
  final bool isAutoTheme;
  final bool isDarkMode;

  ThemeState({required this.isAutoTheme, required this.isDarkMode});
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _autoThemeKey = 'isAutoTheme';
  static const String _darkModeKey = 'isDarkMode';

  ThemeCubit() : super(ThemeState(isAutoTheme: false, isDarkMode: false)) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isAutoTheme = prefs.getBool(_autoThemeKey) ?? false;
    final isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    emit(ThemeState(isAutoTheme: isAutoTheme, isDarkMode: isDarkMode));
  }

  Future<void> setAutoTheme(bool isAutoTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoThemeKey, isAutoTheme);
    emit(ThemeState(isAutoTheme: isAutoTheme, isDarkMode: state.isDarkMode));
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
    emit(ThemeState(isAutoTheme: state.isAutoTheme, isDarkMode: isDarkMode));
  }
}