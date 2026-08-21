import 'package:flutter/material.dart';

import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../book/data/mock_book_details.dart';
import '../../../reader/presentation/reader_launcher.dart';

/// Compact "you were reading this" bar shown above the bottom navigation.
///
/// Appears when a reading session exists, disappears when the book is
/// finished or dismissed. Tapping it reopens the Reader at the saved position.
class ContinueReadingBar extends StatelessWidget {
  const ContinueReadingBar({super.key, this.store});

  final ReadingStore? store;

  @override
  Widget build(BuildContext context) {
    final readingStore = store ?? ReadingStore.instance;
    return ListenableBuilder(
      listenable: readingStore,
      builder: (context, _) {
        final session = readingStore.session;
        if (session == null) return const SizedBox.shrink();
        final percent = (session.progress * 100).round();
        final book = libraryBookForTitle(session.bookTitle);
        final positionLabel = book.isPdf
            ? 'Page ${session.pageIndex + 1} · $percent%'
            : 'Chapter ${session.chapterIndex + 1} · $percent%';

        return Material(
          color: AppColors.paper,
          child: InkWell(
            onTap: () => _openReader(context, session),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.indicatorInactive.withValues(alpha: 0.4),
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 6, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 18,
                    color: AppColors.mutedGold,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.bookTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppFonts.serif,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          positionLabel,
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 11.5,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 2),
                  IconButton(
                    onPressed: readingStore.dismiss,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: AppColors.secondaryText,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 34,
                    ),
                    tooltip: 'Dismiss',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openReader(BuildContext context, ReadingSession session) {
    final book = libraryBookForTitle(session.bookTitle);
    openBookReader(context, book, resume: session);
  }
}
