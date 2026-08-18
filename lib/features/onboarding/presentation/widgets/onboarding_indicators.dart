import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Onboarding progress indicators driven by the current page index.
///
/// The active page is shown as a small horizontal pill that glides
/// to the correct slot when [activeIndex] changes; the remaining
/// pages appear as small circular dots.
class OnboardingIndicators extends StatelessWidget {
  const OnboardingIndicators({
    super.key,
    required this.activeIndex,
    this.count = 3,
  });

  final int activeIndex;
  final int count;

  static const double _slotWidth = 30;
  static const double _pillWidth = 24;
  static const double _dotSize = 6;
  static const Duration _duration = Duration(milliseconds: 320);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: count * _slotWidth,
      height: _dotSize,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < count; i++)
                SizedBox(
                  width: _slotWidth,
                  height: _dotSize,
                  child: Center(
                    child: Container(
                      width: _dotSize,
                      height: _dotSize,
                      decoration: const BoxDecoration(
                        color: AppColors.indicatorInactive,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          AnimatedPositioned(
            duration: _duration,
            curve: _curve,
            top: 0,
            left: activeIndex * _slotWidth + (_slotWidth - _pillWidth) / 2,
            child: Container(
              width: _pillWidth,
              height: _dotSize,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(_pillWidth / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}