import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/reader_book.dart';
import '../reader_settings.dart';

/// A single learning bite shown as a quiet reading-list row: category kicker,
/// serif topic, key idea, excerpt, and duration. Used by the Reader's Learn
/// mode and the Book Detail bites page.
class BiteListItem extends StatelessWidget {
  const BiteListItem({
    super.key,
    required this.bite,
    required this.palette,
    required this.onTap,
  });

  final ReaderBite bite;
  final ReaderPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bite.category,
              style: const TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
                color: AppColors.mutedGold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              bite.topic,
              style: TextStyle(
                fontFamily: AppFonts.serif,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: palette.ink,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              bite.keyIdea,
              style: const TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AppColors.mutedGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bite.excerpt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.serif,
                fontSize: 13,
                height: 1.5,
                color: palette.secondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  bite.duration,
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 11,
                    color: palette.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 2, height: 2, color: AppColors.mutedGold),
                const SizedBox(width: 10),
                const Text(
                  'LISTEN',
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.mutedGold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
