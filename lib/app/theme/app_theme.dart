import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,

      // AppBar 테마
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.lightColorScheme.surface,
        foregroundColor: AppColors.lightColorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.titleMedium,
      ),

      // Bottom Navigation 테마
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6366F1),
        unselectedItemColor: Color(0xFFE0E0E0),
        elevation: 8,
      ),

      // ElevatedButton 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightColorScheme.primary,
          foregroundColor: AppColors.lightColorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // OutlinedButton 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightColorScheme.primary,
          side: BorderSide(
            color: AppColors.lightColorScheme.outline,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // TextButton 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightColorScheme.primary,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // InputDecoration 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightColorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightColorScheme.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightColorScheme.outline,
        ),
      ),

      // Card 테마
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: Colors.white,
      ),

      // Divider 테마
      dividerTheme: DividerThemeData(
        color: AppColors.lightColorScheme.outline,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,

      // 다크 테마 설정 (라이트 테마와 유사하게 구성)
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.darkColorScheme.surface,
        foregroundColor: AppColors.darkColorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.titleMedium.copyWith(
          color: AppColors.darkColorScheme.onSurface,
        ),
      ),

      // 기타 테마 설정...
    );
  }
}