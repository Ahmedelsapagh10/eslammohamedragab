import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightAccent,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightAccent,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
        outline: AppColors.lightBorder,
      ),
      fontFamily: 'Nunito',
      useMaterial3: true,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.lightAccent,
        selectionColor: AppColors.lightAccent.withValues(alpha: 0.24),
        selectionHandleColor: AppColors.lightAccent,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accent,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.primary,
        outline: AppColors.border,
      ),
      fontFamily: 'Nunito',
      useMaterial3: true,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionColor: AppColors.accent.withValues(alpha: 0.26),
        selectionHandleColor: AppColors.accent,
      ),
    );
  }
}
