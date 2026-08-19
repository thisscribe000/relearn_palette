import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/library_book.dart';

/// Editorial placeholder book cover rendered for the Library shelf.
///
/// A flat, restrained cover: muted tone background, a subtle spine edge,
/// the status as a small-caps kicker, serif title over a thin gold rule,
/// and a tiny wordmark at the foot. No gradients or shadows.
class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book});

  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    final style = _toneStyles[book.tone]!;

    return AspectRatio(
      aspectRatio: 0.66,
      child: Container(
        color: style.background,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                color: Colors.black.withValues(alpha: 0.16),
              ),
            ),
            Positioned(
              left: 3.5,
              top: 0,
              bottom: 0,
              child: Container(
                width: 1,
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusLabel(book.status),
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      color: AppColors.mutedGold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    book.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.serif,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: style.foreground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const SizedBox(
                    width: 24,
                    height: 1.5,
                    child: ColoredBox(color: AppColors.mutedGold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.author,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 8.5,
                      height: 1.3,
                      color: style.foreground.withValues(alpha: 0.78),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'RE-LEARN',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 6.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: style.foreground.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(BookStatus status) => switch (status) {
    BookStatus.reading => 'READING',
    BookStatus.finished => 'FINISHED',
    BookStatus.toRead => 'IN LIBRARY',
  };
}

class _ToneStyle {
  const _ToneStyle(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

const _toneStyles = <BookCoverTone, _ToneStyle>{
  BookCoverTone.deepGreen: _ToneStyle(Color(0xFF0E2A1D), Color(0xFFFBF7EE)),
  BookCoverTone.forest: _ToneStyle(Color(0xFF22382A), Color(0xFFF3EADA)),
  BookCoverTone.olive: _ToneStyle(Color(0xFF6E6A45), Color(0xFFFBF7EE)),
  BookCoverTone.clay: _ToneStyle(Color(0xFF9C6B4F), Color(0xFFFBF7EE)),
  BookCoverTone.rust: _ToneStyle(Color(0xFFA55A3C), Color(0xFFFBF7EE)),
  BookCoverTone.ink: _ToneStyle(Color(0xFF2A333D), Color(0xFFF3EADA)),
  BookCoverTone.warmCream: _ToneStyle(Color(0xFFF3EADA), Color(0xFF061B0E)),
  BookCoverTone.sand: _ToneStyle(Color(0xFFE5D6B8), Color(0xFF061B0E)),
  BookCoverTone.sage: _ToneStyle(Color(0xFFD8DECC), Color(0xFF061B0E)),
  BookCoverTone.ivory: _ToneStyle(Color(0xFFFBF7EE), Color(0xFF061B0E)),
};
