import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Placeholder for Screen 05 (Library).
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_outlined,
              size: 40,
              color: AppColors.mutedGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Library',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: AppFonts.serif,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your saved bites and favorite books.',
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