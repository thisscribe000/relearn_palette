import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Placeholder for Screen 07 (Me / Profile).
class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_outlined,
              size: 40,
              color: AppColors.mutedGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Me',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: AppFonts.serif,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your profile, progress, and habits.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: AppFonts.sans,
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}