import 'package:flutter/material.dart';

import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/library_book.dart';
import '../../../home/presentation/widgets/book_cover.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../../../reader/domain/reader_book.dart';
import '../../../reader/presentation/pages/reader_page.dart';
import '../../data/mock_book_details.dart';
import 'book_bites_page.dart';

/// Book Detail / Book Home — the bridge between reading a book and learning
/// from it. Reached from the Library shelf.
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.book, this.store});

  final LibraryBook book;
  final ReadingStore? store;

  ReadingStore get _store => store ?? ReadingStore.instance;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final session = _store.session;
        final resume = session != null && session.bookTitle == book.title
            ? session
            : null;
        final progress = resume?.progress ?? book.progress;
        final percent = (progress * 100).round();
        final detail = bookDetailFor(book.title);
        final chapters = readerBookFor(book).chapters;
        final biteCount = bitesForBook(book).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _topBar(context)),
                SliverToBoxAdapter(
                  child: _hero(context, progress: progress, percent: percent),
                ),
                SliverToBoxAdapter(child: _about(context, detail.description)),
                SliverToBoxAdapter(
                  child: _chapters(
                    context,
                    chapters: chapters,
                    progress: progress,
                    finished: book.status == BookStatus.finished,
                  ),
                ),
                SliverToBoxAdapter(child: _bites(context, biteCount)),
                SliverToBoxAdapter(child: _discussion(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primaryGreen,
            tooltip: 'Back',
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _openMoreMenu(context),
            icon: const Icon(Icons.more_horiz_rounded),
            color: AppColors.primaryGreen,
            tooltip: 'More',
          ),
        ],
      ),
    );
  }

  Widget _hero(
    BuildContext context, {
    required double progress,
    required int percent,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 148, child: BookCover(book: book)),
          const SizedBox(height: 22),
          Text(
            book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.author,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '$percent% complete',
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                minHeight: 3,
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.indicatorInactive.withValues(
                  alpha: 0.55,
                ),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.mutedGold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => _openReader(context),
                  child: Text(
                    percent > 0 ? 'Continue Reading' : 'Start Reading',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: BorderSide(
                      color: AppColors.primaryGreen.withValues(alpha: 0.55),
                    ),
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textStyle: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  onPressed: () => _openBites(context),
                  child: const Text('Learn the Book'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _about(BuildContext context, String description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('About'),
          Text(
            description,
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 16,
              height: 1.65,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chapters(
    BuildContext context, {
    required List<ReaderChapter> chapters,
    required double progress,
    required bool finished,
  }) {
    final count = chapters.length;
    final current = (progress * count).floor().clamp(0, count - 1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Chapters'),
          for (var i = 0; i < count; i++) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: i < count - 1
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.indicatorInactive.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      (i + 1).toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontFamily: AppFonts.serif,
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      chapters[i].title,
                      style: TextStyle(
                        fontFamily: AppFonts.serif,
                        fontSize: 15.5,
                        fontWeight: i == current && !finished
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: i == current && !finished
                            ? AppColors.primaryGreen
                            : AppColors.secondaryText,
                      ),
                    ),
                  ),
                  _chapterStatus(i, current: current, finished: finished),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chapterStatus(
    int index, {
    required int current,
    required bool finished,
  }) {
    if (finished || index < current) {
      return const _ChapterLabel('READ', active: false);
    }
    if (index == current) {
      return const _ChapterLabel('READING', active: true);
    }
    return const SizedBox.shrink();
  }

  Widget _bites(BuildContext context, int biteCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: _SummaryPanel(
        children: [
          Text(
            '$biteCount Learning Bites',
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Short ideas and insights from this book.',
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 10),
          _SubtleAction(label: 'Explore', onTap: () => _openBites(context)),
        ],
      ),
    );
  }

  Widget _discussion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: _SummaryPanel(
        children: [
          const Text(
            '24 thoughts',
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'See what other readers are noticing.',
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 10),
          _SubtleAction(label: 'Open', onTap: () => _openDiscussion(context)),
        ],
      ),
    );
  }

  void _openReader(BuildContext context) {
    final session = _store.session;
    final resume = session != null && session.bookTitle == book.title
        ? session
        : null;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReaderPage(
          book: readerBookFor(book),
          initialChapter: resume?.chapterIndex ?? 0,
          initialPage: resume?.pageIndex ?? 0,
        ),
      ),
    );
  }

  void _openBites(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => BookBitesPage(book: book)));
  }

  void _openDiscussion(BuildContext context) {
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
              const Text(
                'What readers are noticing in this book',
                style: TextStyle(
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

  void _openMoreMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.auto_stories_outlined,
                color: AppColors.mutedGold,
              ),
              title: const Text('Learn the Book'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openBites(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.bookmark_border_rounded,
                color: AppColors.mutedGold,
              ),
              title: const Text('Save to shelf'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                showComingSoon(context, 'Save to shelf');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.mutedGold,
              ),
              title: const Text('About this edition'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                showComingSoon(context, 'About this edition');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontFamily: AppFonts.sans,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: AppColors.mutedGold,
        ),
      ),
    );
  }
}

class _ChapterLabel extends StatelessWidget {
  const _ChapterLabel(this.label, {required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: AppFonts.sans,
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: active ? AppColors.mutedGold : AppColors.secondaryText,
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(
          color: AppColors.indicatorInactive.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _SubtleAction extends StatelessWidget {
  const _SubtleAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '$label →',
          style: const TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.mutedGold,
          ),
        ),
      ),
    );
  }
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
