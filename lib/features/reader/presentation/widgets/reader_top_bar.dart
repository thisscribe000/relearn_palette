import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Top chrome of the Reader: back, book/chapter info, and the reading tools
/// (contents, search, bookmark, Aa settings, more).
class ReaderTopBar extends StatelessWidget {
  const ReaderTopBar({
    super.key,
    required this.bookTitle,
    required this.chapterTitle,
    required this.background,
    required this.ink,
    required this.secondary,
    required this.bookmarked,
    required this.onBack,
    required this.onToc,
    required this.onSearch,
    required this.onBookmark,
    required this.onAa,
    required this.onMore,
  });

  final String bookTitle;
  final String chapterTitle;
  final Color background;
  final Color ink;
  final Color secondary;
  final bool bookmarked;
  final VoidCallback onBack;
  final VoidCallback onToc;
  final VoidCallback onSearch;
  final VoidCallback onBookmark;
  final VoidCallback onAa;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              color: ink,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
              tooltip: 'Back',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bookTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.serif,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      chapterTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 11,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onToc,
              icon: const Icon(Icons.format_list_bulleted_rounded, size: 22),
              color: ink,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
              tooltip: 'Contents',
            ),
            IconButton(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded, size: 22),
              color: ink,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
              tooltip: 'Search',
            ),
            IconButton(
              onPressed: onBookmark,
              icon: Icon(
                bookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 22,
              ),
              color: bookmarked ? const Color(0xFFB08D57) : ink,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
              tooltip: 'Bookmark',
            ),
            IconButton(
              onPressed: onAa,
              icon: Text(
                'Aa',
                style: TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
              tooltip: 'Reading settings',
            ),
            IconButton(
              onPressed: onMore,
              icon: const Icon(Icons.more_vert_rounded, size: 22),
              color: ink,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
              tooltip: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
