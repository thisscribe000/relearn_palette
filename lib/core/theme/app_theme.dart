import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppFonts {
  static const String serif = 'Source Serif 4';
  static const String sans = 'Inter';
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          surface: AppColors.background,
        ).copyWith(
          primary: AppColors.primaryGreen,
          secondary: AppColors.secondaryText,
          surface: AppColors.background,
          onSurface: AppColors.primaryGreen,
        ),
        scaffoldBackgroundColor: AppColors.background,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.paper,
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: AppFonts.sans,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              height: 1.2,
              letterSpacing: 0.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondaryText,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(
              fontFamily: AppFonts.sans,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.2,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secondaryText,
            ),
          ),
        ),
        textTheme: Typography.blackMountainView.apply(
          fontFamily: AppFonts.serif,
          bodyColor: AppColors.primaryGreen,
          displayColor: AppColors.primaryGreen,
        ).copyWith(
          displayLarge: TextStyle(
            fontFamily: AppFonts.serif,
            fontWeight: FontWeight.w700,
            fontSize: 48,
            height: 1.1,
            letterSpacing: -0.96,
            color: AppColors.primaryGreen,
          ),
          labelLarge: const TextStyle(
            fontFamily: AppFonts.sans,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.2,
            color: AppColors.secondaryText,
          ),
          headlineSmall: const TextStyle(
            fontFamily: AppFonts.serif,
            fontWeight: FontWeight.w600,
            fontSize: 24,
            height: 1.2,
            letterSpacing: -0.48,
            color: AppColors.primaryGreen,
          ),
          bodyMedium: const TextStyle(
            fontFamily: AppFonts.serif,
            fontWeight: FontWeight.w400,
            fontSize: 17,
            height: 1.6,
            color: AppColors.secondaryText,
          ),
        ),
      );
}