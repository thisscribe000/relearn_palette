import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../home/domain/library_book.dart';
import '../domain/extracted_book_content.dart';
import 'pdf_chapter_detector.dart';
import 'pdf_text_extractor.dart';

/// Stage reported while a book's content is being prepared.
enum ContentStage { extracting, structuring, complete }

/// Prepares and stores extracted text for imported PDF books.
///
/// Contract:
/// - **Extract once**: results persist as JSON beside the imported PDF and
///   are reused forever after (memory cache first, then disk). Failed or
///   unsupported outcomes are also persisted so they aren't retried on
///   every open.
/// - The original PDF is never modified — extraction produces a parallel
///   representation for the future learning layer, not a replacement.
/// - Never throws into the UI: problems come back as [ExtractionStatus]
///   values; the book remains readable regardless.
class PdfContentStore {
  PdfContentStore._();

  static final PdfContentStore instance = PdfContentStore._();

  final Map<String, ExtractedBookContent> _cache = {};

  /// Directory holding `<safe-book-id>.json` records.
  Future<Directory> _recordsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/imported_books/content');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  File _recordFile(Directory dir, String bookId) {
    final safe = bookId.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return File('${dir.path}/$safe.json');
  }

  /// Loads previously stored content, if any.
  Future<ExtractedBookContent?> load(String bookId) async {
    final cached = _cache[bookId];
    if (cached != null) return cached;
    try {
      final dir = await _recordsDir();
      final file = _recordFile(dir, bookId);
      if (!file.existsSync()) return null;
      final json = jsonDecode(await file.readAsString()) as Map<String, Object?>;
      final content = ExtractedBookContent.fromJson(json);
      _cache[bookId] = content;
      return content;
    } catch (_) {
      return null; // corrupt record treated as unprocessed
    }
  }

  /// Returns stored content, extracting first when missing. Reports progress
  /// through [onStage]. A failure yields a persisted `failed`/`unsupported`
  /// record instead of an exception.
  Future<ExtractedBookContent> ensureProcessed(
    LibraryBook book, {
    void Function(ContentStage stage)? onStage,
  }) async {
    final existing = await load(book.id);
    if (existing != null) return existing; // extract once, ever

    final filePath = book.filePath;
    if (!book.isPdf || filePath == null || !File(filePath).existsSync()) {
      return _store(_failed(book.id));
    }

    onStage?.call(ContentStage.extracting);
    final RawPdfText raw;
    try {
      raw = await const PdfTextExtractor().extract(filePath);
    } catch (_) {
      return _store(_failed(book.id));
    }

    // Scanned/image-only detection: almost no selectable text anywhere.
    final meaningfulChars = raw.pages.fold<int>(
      0,
      (sum, page) => sum + page.replaceAll(RegExp(r'\s'), '').length,
    );
    final avgPerPage = raw.pageCount == 0 ? 0 : meaningfulChars / raw.pageCount;
    if (meaningfulChars < 200 || avgPerPage < 30) {
      return _store(
        ExtractedBookContent(
          bookId: book.id,
          status: ExtractionStatus.unsupported,
          pageCount: raw.pageCount,
          rawText: '',
          chapters: const [],
          characterCount: meaningfulChars,
        ),
      );
    }

    onStage?.call(ContentStage.structuring);
    final cleanedPages = stripRepeatedHeadersFooters(
      [for (final page in raw.pages) cleanPageText(page)],
    );
    final chapters = detectChapters(cleanedPages);

    final content = ExtractedBookContent(
      bookId: book.id,
      status: ExtractionStatus.complete,
      pageCount: raw.pageCount,
      rawText: cleanedPages.join('\n\n').trim(),
      chapters: chapters,
      characterCount: meaningfulChars,
    );
    await _store(content);
    onStage?.call(ContentStage.complete);
    return content;
  }

  ExtractedBookContent _failed(String bookId) => ExtractedBookContent(
        bookId: bookId,
        status: ExtractionStatus.failed,
        pageCount: 0,
        rawText: '',
        chapters: const [],
        characterCount: 0,
      );

  Future<ExtractedBookContent> _store(ExtractedBookContent content) async {
    _cache[content.bookId] = content;
    try {
      final dir = await _recordsDir();
      final file = _recordFile(dir, content.bookId);
      await file.writeAsString(jsonEncode(content.toJson()));
    } catch (_) {
      // Persistence is best-effort; the memory cache still serves this run.
    }
    return content;
  }
}
