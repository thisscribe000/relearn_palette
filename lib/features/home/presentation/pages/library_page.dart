import 'package:flutter/material.dart';

import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/mock_books.dart';
import '../../domain/library_book.dart';
import '../../../book/data/mock_book_details.dart';
import '../../../book/presentation/pages/book_bites_page.dart';
import '../../../book/presentation/pages/book_detail_page.dart';
import '../../../reader/presentation/pages/reader_page.dart';
import '../widgets/book_cover.dart';
import '../widgets/coming_soon.dart';

/// Screen 05 — Library.
///
/// A personal digital bookshelf: a featured Continue Reading book, filter
/// controls (All / Reading / Finished), and a grid of covers with a subtle
/// import affordance. The featured card is the entry point to the Reader,
/// and its secondary action points back at the Learning Feed.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  static const _filters = <String>['All', 'Reading', 'Finished'];
  static const _statuses = <BookStatus?>[
    null,
    BookStatus.reading,
    BookStatus.finished,
  ];

  int _filter = 0;

  List<LibraryBook> get _books {
    final status = _statuses[_filter];
    if (status == null) return mockLibraryBooks;
    return mockLibraryBooks.where((b) => b.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width >= 560 ? 4 : 3;
          const horizontalPadding = 20.0;
          const gridSpacing = 16.0;
          final cellWidth =
              (width - horizontalPadding * 2 - gridSpacing * (columns - 1)) /
              columns;
          final coverHeight = cellWidth / 0.66;
          final cellHeight = coverHeight + 48;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildFilters()),
              SliverToBoxAdapter(
                child: _ContinueReadingCard(book: featuredBook),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'Your Books',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: AppFonts.serif,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: gridSpacing,
                    mainAxisSpacing: 20,
                    mainAxisExtent: cellHeight,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == _books.length) {
                      return _AddBookTile(
                        cellWidth: cellWidth,
                        coverHeight: coverHeight,
                      );
                    }
                    return _ShelfBook(
                      book: _books[index],
                      cellWidth: cellWidth,
                    );
                  }, childCount: _books.length + 1),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 8, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Library',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: AppFonts.serif,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 2),
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(
                  'Your bookshelf',
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 13,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => showComingSoon(context, 'Search'),
            icon: const Icon(Icons.search_rounded),
            color: AppColors.primaryGreen,
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
      child: Row(
        children: [
          for (var i = 0; i < _filters.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _FilterPill(
              label: _filters[i],
              selected: _filter == i,
              onTap: () => setState(() => _filter = i),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.paper : Colors.transparent,
          border: Border.all(
            color: selected
                ? AppColors.indicatorInactive.withValues(alpha: 0.8)
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.primaryGreen : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({required this.book});

  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ReadingStore.instance,
      builder: (context, _) {
        final session = ReadingStore.instance.session;
        final effective = session != null
            ? libraryBookForTitle(session.bookTitle)
            : book;
        final progress = session?.progress ?? effective.progress;
        return _buildCard(context, effective, progress, session);
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    LibraryBook effective,
    double progress,
    ReadingSession? session,
  ) {
    final percent = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(
            color: AppColors.indicatorInactive.withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 96, child: BookCover(book: effective)),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTINUE READING',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      color: AppColors.mutedGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    effective.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: AppFonts.serif,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: 0,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    effective.author,
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 12.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '$percent% read',
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      value: progress,
                      backgroundColor: AppColors.indicatorInactive.withValues(
                        alpha: 0.55,
                      ),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.mutedGold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                      ),
                      onPressed: () => _onContinue(context, effective, session),
                      child: const Text('Continue Reading'),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BookBitesPage(book: effective),
                        ),
                      ),
                      child: Text(
                        effective.biteCount > 0
                            ? 'Revisit in bites · ${effective.biteCount} bite '
                                  '· ${effective.biteDuration}'
                            : 'Revisit in bites',
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

  void _onContinue(
    BuildContext context,
    LibraryBook effective,
    ReadingSession? session,
  ) {
    if (session != null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ReaderPage(
            book: readerBookFor(effective),
            initialChapter: session.chapterIndex,
            initialPage: session.pageIndex,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BookDetailPage(book: effective),
        ),
      );
    }
  }
}

class _ShelfBook extends StatelessWidget {
  const _ShelfBook({required this.book, required this.cellWidth});

  final LibraryBook book;
  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => BookDetailPage(book: book)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: cellWidth,
            child: BookCover(book: book),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 11,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddBookTile extends StatelessWidget {
  const _AddBookTile({required this.cellWidth, required this.coverHeight});

  final double cellWidth;
  final double coverHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => showComingSoon(context, 'Import a book'),
          child: Container(
            width: cellWidth,
            height: coverHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.indicatorInactive.withValues(alpha: 0.8),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Icon(
                Icons.add_rounded,
                size: 26,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Import a book',
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 12,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
