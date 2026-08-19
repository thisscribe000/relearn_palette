import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Reader appearance theme: how the page, chrome and ink are tinted.
enum ReaderAppearance { paper, ivory, deep }

/// Mutable reader preferences (Aa settings). Local mock state only.
class ReaderSettings {
  const ReaderSettings({
    this.fontSize = 20,
    this.serif = true,
    this.lineSpacing = 1.55,
    this.appearance = ReaderAppearance.paper,
    this.brightness = 0,
  });

  final double fontSize;
  final bool serif;
  final double lineSpacing;
  final ReaderAppearance appearance;

  /// 0.0 (no dim) .. 1.0 (fully dimmed); mock brightness overlay.
  final double brightness;

  ReaderSettings copyWith({
    double? fontSize,
    bool? serif,
    double? lineSpacing,
    ReaderAppearance? appearance,
    double? brightness,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      serif: serif ?? this.serif,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      appearance: appearance ?? this.appearance,
      brightness: brightness ?? this.brightness,
    );
  }
}

/// Resolved colors for a given [ReaderAppearance].
class ReaderPalette {
  const ReaderPalette({
    required this.background,
    required this.surface,
    required this.ink,
    required this.secondary,
  });

  final Color background;
  final Color surface;
  final Color ink;
  final Color secondary;
}

ReaderPalette paletteFor(ReaderAppearance appearance) {
  switch (appearance) {
    case ReaderAppearance.paper:
      return const ReaderPalette(
        background: AppColors.background,
        surface: AppColors.paper,
        ink: AppColors.primaryGreen,
        secondary: AppColors.secondaryText,
      );
    case ReaderAppearance.ivory:
      return const ReaderPalette(
        background: Color(0xFFFFFDF8),
        surface: Color(0xFFFFFDF8),
        ink: AppColors.primaryGreen,
        secondary: AppColors.secondaryText,
      );
    case ReaderAppearance.deep:
      return const ReaderPalette(
        background: Color(0xFF08150C),
        surface: Color(0xFF0F2215),
        ink: Color(0xFFF3EADA),
        secondary: Color(0xFFA9B2A5),
      );
  }
}
