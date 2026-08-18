import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Shows a transient "coming soon" confirmation for unimplemented features.
void showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          '$feature is coming soon',
          style: const TextStyle(fontFamily: AppFonts.sans),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(milliseconds: 1400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
}