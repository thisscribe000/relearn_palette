import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/learning_bite.dart';

import 'coming_soon.dart';
import 'learning_bite_actions.dart';
import 'learning_bite_illustration.dart';

/// Full-screen content for a single Learning Bite in the vertical feed.
class LearningBite extends StatelessWidget {
  const LearningBite({super.key, required this.bite});

  final LearningBiteData bite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final serif = AppFonts.serif;
    final sans = AppFonts.sans;
    final green = AppColors.primaryGreen;
    final secondary = AppColors.secondaryText;
    final gold = AppColors.mutedGold;

    return LayoutBuilder(
      builder: (context, constraints) {
        final illSize = math
            .min(constraints.maxWidth * 0.5, constraints.maxHeight * 0.25)
            .clamp(120.0, 180.0)
            .toDouble();
        return Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(left: 28, right: 64, top: 16, bottom: 16),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    LearningBiteIllustration(visual: bite.visual, size: illSize),
                    const SizedBox(height: 16),
                    Container(width: 28, height: 3, color: gold),
                    const SizedBox(height: 14),
                    Flexible(
                      fit: FlexFit.tight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              bite.topic,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontFamily: serif,
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                height: 1.15,
                                color: green,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Text(
                                bite.body,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: sans,
                                  fontSize: 14.5,
                                  height: 1.5,
                                  color: secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'KEY IDEA',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontFamily: sans,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.6,
                                    color: gold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bite.keyIdea,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontFamily: serif,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                height: 1.35,
                                color: green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _ListenChip(duration: bite.listenDuration),
                    const Spacer(flex: 3),
                    Text(
                      bite.bookTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: serif,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: green,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bite.author,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: sans,
                        fontSize: 13,
                        color: secondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => showComingSoon(context, 'The full reader'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read the full book',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontFamily: serif,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: green,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                              color: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 0,
              bottom: 0,
              child: Center(child: LearningBiteActions()),
            ),
          ],
        );
      },
    );
  }
}

class _ListenChip extends StatelessWidget {
  const _ListenChip({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => showComingSoon(context, 'Audio'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.indicatorInactive),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.play_arrow_rounded,
              size: 18,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 6),
            Text(
              'Listen',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: AppFonts.sans,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.mutedGold,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              duration,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: AppFonts.sans,
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}