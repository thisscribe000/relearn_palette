import 'package:flutter/material.dart';

import '../../../../core/library/library_store.dart';
import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/library_book.dart';
import '../../../home/presentation/widgets/book_cover.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../../../reader/domain/reader_book.dart';
import '../../../reader/presentation/reader_launcher.dart';
import '../../data/mock_book_bites.dart';
import '../../data/mock_book_details.dart';
import '../../../add_book/data/pdf_content_store.dart';
import '../../../add_book/domain/extracted_book_content.dart';
import '../../../add_book/presentation/pages/extracted_content_preview_page.dart';
import '../widgets/book_discussion_sheet.dart';
import 'learning_bites_page.dart';

/// Book Detail / Book Home — the bridge between reading a book and learning
/// from it. Reached from the Library shelf.
class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.book, this.store});

  final LibraryBook book;
  final ReadingStore? store;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  ReadingStore get _store => widget.store ?? ReadingStore.instance;

  LibraryBook get book => widget.book;

  /// Extracted-text availability for imported PDF books; null while unknown.
  ExtractedBookContent? _pdfContent;

  @override
  void initState() {
    super.initState();
    if (book.isPdf) _ensurePdfContent();
  }

  Future<void> _ensurePdfContent() async {
    final content = await PdfContentStore.instance.ensureProcessed(book);
    if (!mounted) return;
    setState(() => _pdfContent = content);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_store, LibraryStore.instance]),
      builder: (context, _) {
        final inLibrary = LibraryStore.instance.containsId(book.id);
        final session = _store.session;
        final resume = session != null && session.bookTitle == book.title
            ? session
            : null;
        final progress = resume?.progress ?? book.progress;
        final percent = (progress * 100).round();
        final detail = bookDetailFor(book.title);
        final chapters = readerBookFor(book).chapters;
        final biteCount = bookBitesFor(book).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _topBar(context)),
                SliverToBoxAdapter(
                  child: _hero(
                    context,
                    progress: progress,
                    percent: percent,
                    inLibrary: inLibrary,
                    chapterCount: chapters.length,
                  ),
                ),
                SliverToBoxAdapter(child: _about(context, detail.description)),
                if (!book.isPdf)
                  SliverToBoxAdapter(
                    child: _chapters(
                      context,
                      chapters: chapters,
                      progress: progress,
                      finished: book.status == BookStatus.finished,
                    ),
                  ),
                SliverToBoxAdapter(
                  child: book.isPdf
                      ? _pdfBitesPanel(context)
                      : _bites(context, biteCount),
                ),
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
    required bool inLibrary,
    required int chapterCount,
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
          if (inLibrary) ...[
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
          ] else
            Text(
              _catalogMeta(chapterCount),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 12.5,
                color: AppColors.secondaryText,
              ),
            ),
          const SizedBox(height: 24),
          if (!inLibrary)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _addToLibrary(context),
                child: const Text('Add to Library'),
              ),
            )
          else
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

  String _catalogMeta(int chapterCount) {
    final parts = <String>[
      'Not in your library',
      if (book.year.isNotEmpty) book.year,
      if (book.category.isNotEmpty) book.category,
      book.isPdf ? 'PDF' : '$chapterCount chapters',
    ];
    return parts.join(' · ');
  }

  void _addToLibrary(BuildContext context) {
    LibraryStore.instance.add(book);
    showAppSnackBar(context, '${book.title} added to your library');
  }

  Widget _about(BuildContext context, String description) {
    final text = book.isPdf
        ? 'Imported from a PDF on this device. Once this book has been '
            'processed, Re-Learn will turn it into bite-sized ideas.'
        : description;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('About'),
          Text(
            text,
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

  Widget _pdfBitesPanel(BuildContext context) {
    final content = _pdfContent;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: _SummaryPanel(
        children: [
          const Text(
            'Learning Bites',
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 6),
          if (content == null)
            const Text(
              'Once this book has been processed, Re-Learn will turn it into '
              'bite-sized ideas.',
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 13,
                height: 1.45,
                color: AppColors.secondaryText,
              ),
            )
          else ...[
            Text(
              switch (content.status) {
                ExtractionStatus.complete => 'BOOK CONTENT PROCESSED',
                ExtractionStatus.unsupported => 'SCANNED PAGES · OCR NEEDED',
                ExtractionStatus.failed => 'PROCESSING FAILED',
                _ => 'PROCESSING',
              },
              style: const TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.2,
                color: AppColors.mutedGold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              switch (content.status) {
                ExtractionStatus.complete =>
                  "This book's text has been extracted and organized into "
                  '${content.chapters.length} chapter(s) — ready for '
                  'learning.',
                ExtractionStatus.unsupported =>
                  "This PDF's pages look scanned rather than typed, so its "
                  "text can't be learned from yet. OCR support will come "
                  'later.',
                ExtractionStatus.failed =>
                  "We couldn't process this book's text right now. You can "
                  'still read the PDF normally.',
                _ =>
                  'Working on it — text is being extracted and organized.',
              },
              style: const TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 13,
                height: 1.45,
                color: AppColors.secondaryText,
              ),
            ),
          ],
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
    openBookReader(context, book, resume: resume);
  }

  void _openBites(BuildContext context) {
    if (book.isPdf) {
      _showBitesPlaceholder(context);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => LearningBitesPage(book: book)),
    );
  }

  void _showBitesPlaceholder(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LEARNING BITES',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.mutedGold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${book.title} hasn\u2019t been processed yet.',
                style: const TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Once this book has been processed, Re-Learn will turn it '
                'into bite-sized ideas you can revisit anywhere.',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 13.5,
                  height: 1.55,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDiscussion(BuildContext context) {
    showBookDiscussion(context, bookTitle: book.title);
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
            if (book.isPdf)
              ListTile(
                leading: const Icon(
                  Icons.plagiarism_outlined,
                  color: AppColors.mutedGold,
                ),
                title: const Text('Inspect extracted content'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ExtractedContentPreviewPage(book: book),
                    ),
                  );
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
