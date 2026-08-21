import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Shows a transient confirmation in the app's editorial snackbar style.
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: AppFonts.sans),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(milliseconds: 1400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
}

/// Shows a transient "coming soon" confirmation for unimplemented features.
void showComingSoon(BuildContext context, String feature) =>
    showAppSnackBar(context, '$feature is coming soon');
