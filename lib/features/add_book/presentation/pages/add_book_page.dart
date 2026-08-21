import 'package:flutter/material.dart';

import '../../../../core/library/library_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../book/presentation/pages/book_detail_page.dart';
import '../../../home/domain/library_book.dart';
import '../../../home/presentation/widgets/book_cover.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../../data/mock_catalog.dart';
import '../../data/pdf_content_store.dart';
import '../../data/pdf_import_service.dart';
import '../../domain/extracted_book_content.dart';

/// Add Book — find a book in the catalog or import your own.
///
/// Reached from the Library shelf's "Add a Book" tile. Search filters the
/// local mock catalog by title or author; tapping a result previews it in
/// Book Detail, where it can be added to the shelf.
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<LibraryBook> get _results {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return mockCatalogBooks;
    return mockCatalogBooks
        .where(
          (b) =>
              b.title.toLowerCase().contains(query) ||
              b.author.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                children: [
                  _buildSearchField(),
                  const _OrDivider(),
                  const _ImportPdfTile(),
                  const SizedBox(height: 28),
                  ListenableBuilder(
                    listenable: LibraryStore.instance,
                    builder: (context, _) {
                      final results = _results;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(
                            _query.trim().isEmpty
                                ? 'Suggested Books'
                                : 'Results',
                          ),
                          if (results.isEmpty)
                            const _EmptyResults()
                          else
                            for (final book in results)
                              _CatalogBookRow(book: book),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primaryGreen,
            tooltip: 'Back',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a Book',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontFamily: AppFonts.serif,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Find something to read',
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            color: AppColors.paper,
            border: Border.all(
              color: AppColors.indicatorInactive.withValues(alpha: 0.7),
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            onChanged: (value) => setState(() => _query = value),
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 14.5,
              color: AppColors.primaryGreen,
            ),
            decoration: InputDecoration(
              hintText: 'Search for a book...',
              hintStyle: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 14.5,
                color: AppColors.secondaryText.withValues(alpha: 0.75),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.secondaryText,
              ),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                        _searchFocus.requestFocus();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.secondaryText,
                      ),
                      tooltip: 'Clear',
                    ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              border: InputBorder.none,
            ),
            cursorColor: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 18),
      child: Row(
        children: [
          const Expanded(
            child: SizedBox(
              height: 1,
              child: ColoredBox(
                color: AppColors.indicatorInactive,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'OR',
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: AppColors.secondaryText.withValues(alpha: 0.8),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(
              height: 1,
              child: ColoredBox(
                color: AppColors.indicatorInactive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportPdfTile extends StatelessWidget {
  const _ImportPdfTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => runPdfImport(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(
            color: AppColors.indicatorInactive.withValues(alpha: 0.7),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.picture_as_pdf_outlined, size: 19, color: AppColors.mutedGold),
            SizedBox(width: 12),
            Text(
              'Import a PDF',
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_rounded,
              size: 17,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

/// The full Import PDF flow: pick → validate → duplicate check → copy into
/// app storage → add to the Library, with a processing sheet throughout.
Future<void> runPdfImport(BuildContext context) async {
  final PickedPdf? picked;
  try {
    picked = await pickPdf();
  } on PdfImportException catch (error) {
    if (!context.mounted) return;
    showAppSnackBar(context, error.message);
    return;
  }
  if (picked == null || !context.mounted) return;
  final pdf = picked;

  if (pdfAlreadyInLibrary(pdf)) {
    final existing = importedBookFor(pdf);
    if (existing == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: _ImportResultView(
          kicker: 'ALREADY IN LIBRARY',
          title: '${pdf.title} is already on your shelf.',
          message: 'Open it whenever you like — no duplicate was created.',
          actionLabel: 'Open Book',
          onAction: () {
            Navigator.of(sheetContext).pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BookDetailPage(book: existing),
              ),
            );
          },
        ),
      ),
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.paper,
    showDragHandle: true,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => _PdfImportSheet(pageContext: context, pickedPdf: pdf),
  );
}

class _PdfImportSheet extends StatefulWidget {
  const _PdfImportSheet({required this.pageContext, required this.pickedPdf});

  final BuildContext pageContext;
  final PickedPdf pickedPdf;

  @override
  State<_PdfImportSheet> createState() => _PdfImportSheetState();
}

class _PdfImportSheetState extends State<_PdfImportSheet> {
  _ImportResultView? _result;
  String _stageLabel = 'Saving your book...';

  @override
  void initState() {
    super.initState();
    _import();
  }

  Future<void> _import() async {
    try {
      final book = await importPdf(widget.pickedPdf);
      LibraryStore.instance.add(book);
      if (!mounted) return;
      setState(() => _stageLabel = 'Extracting text...');

      final content = await PdfContentStore.instance.ensureProcessed(
        book,
        onStage: (stage) {
          if (!mounted) return;
          setState(() {
            _stageLabel = switch (stage) {
              ContentStage.extracting => 'Extracting text...',
              ContentStage.structuring => 'Organizing chapters...',
              ContentStage.complete => _stageLabel,
            };
          });
        },
      );
      if (!mounted) return;
      setState(() => _result = _resultFor(book, content));
    } on PdfImportException catch (error) {
      if (!mounted) return;
      setState(() => _result = _ImportResultView(
        kicker: 'IMPORT FAILED',
        title: "Couldn't import this file",
        message: error.message,
      ));
    } catch (_) {
      if (!mounted) return;
      setState(() => _result = _ImportResultView(
        kicker: 'IMPORT FAILED',
        title: "Couldn't import this file",
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  _ImportResultView _resultFor(LibraryBook book, ExtractedBookContent content) {
    void openBook() {
      Navigator.of(context).pop();
      Navigator.of(widget.pageContext).push(
        MaterialPageRoute<void>(builder: (_) => BookDetailPage(book: book)),
      );
    }

    switch (content.status) {
      case ExtractionStatus.unsupported:
        return _ImportResultView(
          kicker: 'IMPORTED',
          title: '${book.title} is ready to read.',
          message:
              'Its pages look scanned rather than typed, so learning '
              "isn't available for it yet. OCR support will come later.",
          actionLabel: 'Open Book',
          onAction: openBook,
        );
      case ExtractionStatus.failed:
        return _ImportResultView(
          kicker: 'IMPORTED',
          title: '${book.title} is ready to read.',
          message:
              "We couldn't process its text just now — you can still "
              'read the PDF normally.',
          actionLabel: 'Open Book',
          onAction: openBook,
        );
      default:
        return _ImportResultView(
          kicker: 'IMPORTED',
          title: '${book.title} is ready to read.',
          message:
              'Added to your library, with its text organized into '
              'chapters and ready for learning.',
          actionLabel: 'Open Book',
          onAction: openBook,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: SafeArea(
        top: false,
        child: result ??
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'IMPORTING YOUR BOOK',
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
                  widget.pickedPdf.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.serif,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.pickedPdf.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 20),
                const LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: Color(0x55C3C8C1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.mutedGold,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _stageLabel,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 12.5,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
      ),
    );
  }
}

class _ImportResultView extends StatelessWidget {
  const _ImportResultView({
    required this.kicker,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String kicker;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kicker,
          style: const TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.mutedGold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.serif,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(
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
            onPressed: onAction ?? () => Navigator.of(context).pop(),
            child: Text(actionLabel ?? 'Close'),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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

class _CatalogBookRow extends StatelessWidget {
  const _CatalogBookRow({required this.book});

  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    final inLibrary = LibraryStore.instance.containsId(book.id);
    final meta = [
      if (book.year.isNotEmpty) book.year,
      if (book.category.isNotEmpty) book.category,
    ].join(' · ');

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => BookDetailPage(book: book)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(width: 96, child: BookCover(book: book)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.serif,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            inLibrary
                ? const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'IN LIBRARY',
                      style: TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.mutedGold,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: BorderSide(
                          color: AppColors.primaryGreen.withValues(alpha: 0.55),
                        ),
                        minimumSize: const Size(56, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(),
                        textStyle: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        final added = LibraryStore.instance.add(book);
                        if (added && context.mounted) {
                          showAppSnackBar(
                            context,
                            '${book.title} added to your library',
                          );
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text(
            'No books found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try searching for another title or author.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 13,
              color: AppColors.secondaryText.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
