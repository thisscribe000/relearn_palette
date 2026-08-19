import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Bottom chrome of the Reader: chapter, a subtle progress slider, page info,
/// and a quiet Read / Learn switch.
class ReaderBottomBar extends StatelessWidget {
  const ReaderBottomBar({
    super.key,
    required this.chapterLabel,
    required this.pageLabel,
    required this.progress,
    required this.learnMode,
    required this.biteCount,
    required this.background,
    required this.ink,
    required this.secondary,
    required this.onProgressChanged,
    required this.onModeChanged,
  });

  final String chapterLabel;
  final String pageLabel;
  final double progress;
  final bool learnMode;
  final int biteCount;
  final Color background;
  final Color ink;
  final Color secondary;
  final ValueChanged<double> onProgressChanged;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!learnMode) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chapterLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 11,
                          color: secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pageLabel,
                      style: TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor: AppColors.mutedGold,
                    inactiveTrackColor: AppColors.indicatorInactive.withValues(
                      alpha: 0.6,
                    ),
                    thumbColor: AppColors.mutedGold,
                  ),
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: onProgressChanged,
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 2),
                  child: Text(
                    '$biteCount bites · generated from this book',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 11,
                      color: secondary,
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ModeTab(
                    label: 'Read',
                    active: !learnMode,
                    ink: ink,
                    onTap: () => onModeChanged(false),
                  ),
                  const SizedBox(width: 18),
                  _ModeTab(
                    label: 'Learn',
                    active: learnMode,
                    ink: ink,
                    onTap: () => onModeChanged(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.active,
    required this.ink,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color ink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? ink : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: active ? 18 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: active ? AppColors.mutedGold : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
