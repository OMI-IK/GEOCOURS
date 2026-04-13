import 'package:flutter/material.dart';
import '../services/storage_service.dart';

// Nouvelle palette de couleurs géologique
class AppColors {
  static const vertMineral = Color(0xFF2E7D32);
  static const beigeSable = Color(0xFFF5E6C8);
  static const bleuProfond = Color(0xFF1E3A5F);
  static const orangeTerre = Color(0xFFD97706);
  static const grisRoche = Color(0xFF6B7280);
  static const blancCristal = Color(0xFFFAFAFA);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _themeColor = AppColors.bleuProfond;

  static const List<Color> availableColors = [
    AppColors.bleuProfond,
    AppColors.vertMineral,
    AppColors.orangeTerre,
    Colors.purple,
    Colors.teal,
    Colors.red,
    Colors.pink,
    Colors.indigo,
  ];

  ThemeMode get themeMode => _themeMode;
  Color get themeColor => _themeColor;

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _themeColor,
      secondary: _themeColor.withValues(alpha: 0.7),
      tertiary: AppColors.orangeTerre,
      surface: AppColors.blancCristal,
      surfaceContainerHighest: AppColors.beigeSable,
      onSurface: AppColors.bleuProfond,
    ),
    scaffoldBackgroundColor: AppColors.blancCristal,
    appBarTheme: AppBarTheme(
      backgroundColor: _themeColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _themeColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _themeColor,
      secondary: _themeColor.withValues(alpha: 0.7),
      tertiary: AppColors.orangeTerre,
      surface: Color(0xFF1A1A2E),
      surfaceContainerHighest: Color(0xFF2D2D44),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Color(0xFF0F0F1A),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _themeColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  Future<void> init() async {
    final mode = await StorageService.getThemeMode();
    _themeMode = mode == 'dark' ? ThemeMode.dark : ThemeMode.light;

    final colorValue = await StorageService.getThemeColor();
    if (colorValue != null) {
      _themeColor = Color(colorValue);
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await StorageService.saveThemeMode(
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    await StorageService.saveThemeColor(color.toARGB32());
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await setThemeMode(
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
