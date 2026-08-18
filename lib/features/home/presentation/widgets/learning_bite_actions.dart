import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'coming_soon.dart';

/// Social actions for a Learning Bite.
class LearningBiteActions extends StatefulWidget {
  const LearningBiteActions({
    super.key,
    this.compact = false,
    this.direction = Axis.vertical,
  });

  final bool compact;
  final Axis direction;

  @override
  State<LearningBiteActions> createState() => _LearningBiteActionsState();
}

class _LearningBiteActionsState extends State<LearningBiteActions> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: _liked ? Icons.favorite : Icons.favorite_border,
        label: 'Like',
        active: _liked,
        compact: widget.compact,
        onTap: () => setState(() => _liked = !_liked),
      ),
      _ActionItem(
        icon: Icons.chat_bubble_outline,
        label: 'Discuss',
        active: false,
        compact: widget.compact,
        onTap: () => showComingSoon(context, 'Discuss'),
      ),
      _ActionItem(
        icon: _saved ? Icons.bookmark : Icons.bookmark_border,
        label: 'Save',
        active: _saved,
        compact: widget.compact,
        onTap: () => setState(() => _saved = !_saved),
      ),
      _ActionItem(
        icon: Icons.ios_share,
        label: 'Share',
        active: false,
        compact: widget.compact,
        onTap: () => showComingSoon(context, 'Share'),
      ),
    ];

    return Flex(
      direction: widget.direction,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          actions[i],
          if (i < actions.length - 1)
            SizedBox(
              width: widget.direction == Axis.horizontal
                  ? (widget.compact ? 22 : 28)
                  : 0,
              height: widget.direction == Axis.vertical
                  ? (widget.compact ? 16 : 22)
                  : 0,
            ),
        ],
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.compact,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryGreen : AppColors.secondaryText;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: compact ? 20 : 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: compact ? 10 : 10.5,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
