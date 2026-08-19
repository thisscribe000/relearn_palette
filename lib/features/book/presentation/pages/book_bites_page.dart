import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/library_book.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../../../reader/presentation/reader_settings.dart';
import '../../../reader/presentation/widgets/bite_list_item.dart';
import '../../data/mock_book_details.dart';

/// Book Detail's "Learn the Book" destination: the book's learning bites as
/// a quiet editorial reading list. Mock content for now.
class BookBitesPage extends StatelessWidget {
  const BookBitesPage({super.key, required this.book});

  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    final bites = bitesForBook(book);
    final palette = paletteFor(ReaderAppearance.paper);
    final divider = palette.secondary.withValues(alpha: 0.18);
    final items = <Widget>[];

    for (var i = 0; i < bites.length; i++) {
      items.add(
        BiteListItem(
          bite: bites[i],
          palette: palette,
          onTap: () => showComingSoon(context, 'Listen'),
        ),
      );
      if (i < bites.length - 1) {
        items.add(Container(height: 1, color: divider));
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(bookTitle: book.title),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  const Text(
                    'LEARNING BITES',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                      color: AppColors.mutedGold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Learn ${book.title}',
                    style: const TextStyle(
                      fontFamily: AppFonts.serif,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Short, narrated ideas drawn from this book — a quick way '
                    'to revisit what you read.',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...items,
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: AppColors.mutedGold.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Bites are generated from passages of the book. In the '
                      'full build you can listen to them or save them to your '
                      'feed.',
                      style: TextStyle(
                        fontFamily: AppFonts.serif,
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.secondaryText,
                      ),
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
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.bookTitle});

  final String bookTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primaryGreen,
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learning Bites',
                  style: TextStyle(
                    fontFamily: AppFonts.serif,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  bookTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
