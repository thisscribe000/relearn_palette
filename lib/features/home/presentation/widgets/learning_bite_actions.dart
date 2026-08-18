import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'coming_soon.dart';

/// Vertical social-action rail shown down the right edge of a Learning Bite.
class LearningBiteActions extends StatefulWidget {
  const LearningBiteActions({super.key});

  @override
  State<LearningBiteActions> createState() => _LearningBiteActionsState();
}

class _LearningBiteActionsState extends State<LearningBiteActions> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionItem(
          icon: _liked ? Icons.favorite : Icons.favorite_border,
          label: 'Like',
          active: _liked,
          onTap: () => setState(() => _liked = !_liked),
        ),
        const SizedBox(height: 22),
        _ActionItem(
          icon: Icons.chat_bubble_outline,
          label: 'Discuss',
          active: false,
          onTap: () => showComingSoon(context, 'Discuss'),
        ),
        const SizedBox(height: 22),
        _ActionItem(
          icon: _saved ? Icons.bookmark : Icons.bookmark_border,
          label: 'Save',
          active: _saved,
          onTap: () => setState(() => _saved = !_saved),
        ),
        const SizedBox(height: 22),
        _ActionItem(
          icon: Icons.ios_share,
          label: 'Share',
          active: false,
          onTap: () => showComingSoon(context, 'Share'),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
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
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 10.5,
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