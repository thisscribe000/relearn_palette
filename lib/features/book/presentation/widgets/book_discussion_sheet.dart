import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/coming_soon.dart';

/// Opens the shared mock Discussion bottom sheet, used by both the Book Detail
/// page and the Learning Bites experience. When a [biteTitle] is provided the
/// discussion is framed around that specific idea; [bookTitle] always anchors
/// the sheet to the book it belongs to.
void showBookDiscussion(
  BuildContext context, {
  required String bookTitle,
  String? biteTitle,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.paper,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Discussion',
              style: TextStyle(
                fontFamily: AppFonts.serif,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              biteTitle != null
                  ? 'What readers are noticing about "$biteTitle"'
                  : 'What readers are noticing in $bookTitle',
              style: const TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 12.5,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            const _Comment(
              name: 'Amina',
              text:
                  'The slow chapters are the ones that stay. I keep returning '
                  'to the observation in Chapter 1.',
            ),
            const SizedBox(height: 14),
            const _Comment(
              name: 'David',
              text:
                  'I read it page by page and it changed how I read — not '
                  'faster, more carefully.',
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: BorderSide(
                    color: AppColors.primaryGreen.withValues(alpha: 0.4),
                  ),
                  minimumSize: const Size(0, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  showComingSoon(context, 'Discussion');
                },
                child: const Text('Add your thought'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Comment extends StatelessWidget {
  const _Comment({required this.name, required this.text});

  final String name;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.mutedGold.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 14,
              height: 1.45,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
