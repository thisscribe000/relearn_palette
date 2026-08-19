import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/reader_book.dart';
import '../reader_settings.dart';
import 'bite_list_item.dart';

/// The Reader's Learn mode: a quiet reading list of the book's generated
/// learning bites. Plain and secondary — no cards, no feed chrome.
class ReaderLearnView extends StatelessWidget {
  const ReaderLearnView({
    super.key,
    required this.book,
    required this.palette,
    required this.onToggleChrome,
    required this.onListen,
  });

  final ReaderBook book;
  final ReaderPalette palette;
  final VoidCallback onToggleChrome;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final divider = palette.secondary.withValues(alpha: 0.18);
    final items = <Widget>[];

    for (var i = 0; i < book.bites.length; i++) {
      items.add(
        BiteListItem(bite: book.bites[i], palette: palette, onTap: onListen),
      );
      if (i < book.bites.length - 1) {
        items.add(Container(height: 1, color: divider));
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onToggleChrome,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
        children: [
          Text(
            'LEARNING BITES',
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: AppColors.mutedGold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Learn this book',
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: palette.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Short, narrated ideas drawn from the full text — a quick way '
            'to revisit what you have read.',
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 13.5,
              height: 1.5,
              color: palette.secondary,
            ),
          ),
          const SizedBox(height: 24),
          ...items,
        ],
      ),
    );
  }
}
