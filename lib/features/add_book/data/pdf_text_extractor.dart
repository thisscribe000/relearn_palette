import 'package:pdfrx/pdfrx.dart';

/// Per-page text pulled from a PDF, in page order.
class RawPdfText {
  const RawPdfText({required this.pages});

  /// One entry per PDF page; may be empty for image-only pages.
  /// Line endings are normalized to `\n`.
  final List<String> pages;

  int get pageCount => pages.length;
}

bool _initialized = false;

/// Extracts selectable text from a local PDF, page by page, via PDFium.
///
/// Purely mechanical — no rewriting, no summarizing. The book's original
/// words are preserved as faithfully as the format allows. Page boundaries
/// are kept so chapter detection can use them later.
class PdfTextExtractor {
  const PdfTextExtractor();

  Future<RawPdfText> extract(String filePath) async {
    if (!_initialized) {
      await pdfrxFlutterInitialize();
      _initialized = true;
    }
    final doc = await PdfDocument.openFile(filePath);
    try {
      final pages = <String>[];
      for (final page in doc.pages) {
        var text = '';
        try {
          final raw = await page.loadText();
          text = raw?.fullText ?? '';
        } catch (_) {
          // Unreadable single page: keep going with an empty page rather
          // than failing the whole extraction.
        }
        pages.add(text.replaceAll('\r\n', '\n').replaceAll('\r', '\n'));
      }
      return RawPdfText(pages: pages);
    } finally {
      await doc.dispose();
    }
  }
}
