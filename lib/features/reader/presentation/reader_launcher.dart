import 'package:flutter/material.dart';

import '../../book/data/mock_book_details.dart';
import '../../home/domain/library_book.dart';
import '../../../core/reading/reading_store.dart' show ReadingSession;
import 'pages/pdf_reader_page.dart';
import 'pages/reader_page.dart';

/// Opens a book in the right reader: imported PDFs in the native PDF
/// reader, everything else in the paged text reader.
///
/// Every Continue Reading entry point (Home FAB, Library bar and card,
/// Book Detail) goes through here so the source type is decided once.
void openBookReader(
  BuildContext context,
  LibraryBook book, {
  ReadingSession? resume,
}) {
  if (book.isPdf && book.filePath != null) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PdfReaderPage(
          title: book.title,
          author: book.author,
          filePath: book.filePath!,
          initialPage: resume?.pageIndex ?? 0,
        ),
      ),
    );
    return;
  }

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
