import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/library_book.dart';
import '../../data/pdf_content_store.dart';
import '../../domain/extracted_book_content.dart';

/// Developer-facing verification screen for PDF text extraction.
///
/// Reached quietly from Book Detail's overflow menu on imported books.
/// Shows processing status, detected chapters, and a peek at each chapter's
/// text so extraction quality can be checked without touching the normal UX.
class ExtractedContentPreviewPage extends StatefulWidget {
  const ExtractedContentPreviewPage({super.key, required this.book});

  final LibraryBook book;

  @override
  State<ExtractedContentPreviewPage> createState() =>
      _ExtractedContentPreviewPageState();
}

class _ExtractedContentPreviewPageState
    extends State<ExtractedContentPreviewPage> {
  late Future<ExtractedBookContent?> _future;

  @override
  void initState() {
    super.initState();
    _future = PdfContentStore.instance.ensureProcessed(widget.book);
  }

  String _statusLabel(ExtractionStatus status) => switch (status) {
    ExtractionStatus.complete => 'PROCESSED · READY TO LEARN',
    ExtractionStatus.unsupported => 'SCANNED PAGES · OCR NEEDED',
    ExtractionStatus.failed => 'PROCESSING FAILED',
    ExtractionStatus.idle => 'NOT PROCESSED',
    ExtractionStatus.extracting => 'EXTRACTING TEXT',
    ExtractionStatus.structuring => 'ORGANIZING CHAPTERS',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        title: Text(
          'Extracted Content',
          style: TextStyle(
            fontFamily: AppFonts.serif,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      body: FutureBuilder<ExtractedBookContent?>(
        future: _future,
        builder: (context, snapshot) {
          final content = snapshot.data;
          if (content == null) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.mutedGold,
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Text(
                _statusLabel(content.status),
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
                widget.book.title,
                style: const TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${content.pageCount} pages · '
                '${content.chapters.length} chapter(s) · '
                '${content.characterCount} characters',
                style: const TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              if (content.rawText.isEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'No selectable text was extracted from this PDF.',
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 13,
                    color: AppColors.secondaryText,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 24),
                for (final chapter in content.chapters)
                  _ChapterPeekTile(chapter: chapter),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ChapterPeekTile extends StatelessWidget {
  const _ChapterPeekTile({required this.chapter});

  final ExtractedChapter chapter;

  @override
  Widget build(BuildContext context) {
    const peekLength = 1200;
    final text = chapter.text;
    final peek = text.length <= peekLength
        ? text
        : '${text.substring(0, peekLength)}…';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: AppColors.indicatorInactive),
          const SizedBox(height: 12),
          Text(
            chapter.title.toUpperCase(),
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.2,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'pages ${chapter.startPage + 1}–${chapter.endPage + 1} · '
            '${text.length} characters',
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 11,
              color: AppColors.mutedGold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            peek,
            maxLines: 24,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 13.5,
              height: 1.55,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
