/// Processing state of a book's extracted text content.
enum ExtractionStatus {
  /// Not processed yet.
  idle,

  /// Raw text is being pulled from the PDF.
  extracting,

  /// Text is being cleaned and split into chapters.
  structuring,

  /// Content was extracted and structured successfully.
  complete,

  /// Extraction failed (corrupt or unreadable PDF).
  failed,

  /// The PDF holds little or no selectable text — likely scanned pages.
  unsupported,
}

/// One chapter of an imported book's extracted content.
class ExtractedChapter {
  const ExtractedChapter({
    required this.index,
    required this.title,
    required this.text,
    required this.startPage,
    required this.endPage,
  });

  /// Zero-based position in reading order.
  final int index;

  /// Human-readable chapter title, e.g. `Chapter 3`.
  final String title;

  /// The chapter's cleaned text.
  final String text;

  /// Inclusive zero-based PDF page range the chapter spans.
  final int startPage;
  final int endPage;

  Map<String, Object?> toJson() => {
    'index': index,
    'title': title,
    'text': text,
    'startPage': startPage,
    'endPage': endPage,
  };

  static ExtractedChapter fromJson(Map<String, Object?> json) =>
      ExtractedChapter(
        index: json['index'] as int,
        title: json['title'] as String,
        text: json['text'] as String,
        startPage: json['startPage'] as int,
        endPage: json['endPage'] as int,
      );
}

/// Structured text pulled out of an imported PDF.
///
/// Deliberately separate from the PDF itself — the original file stays the
/// reading surface; this parallel representation exists so the future
/// learning pipeline can consume reliable, chapter-structured text.
/// Serializable so it persists beside the imported file and extraction
/// happens at most once per book.
class ExtractedBookContent {
  const ExtractedBookContent({
    required this.bookId,
    required this.status,
    required this.pageCount,
    required this.rawText,
    required this.chapters,
    required this.characterCount,
  });

  /// Matches the owning [LibraryBook.id].
  final String bookId;

  /// Outcome of the processing attempt.
  final ExtractionStatus status;

  /// Number of PDF pages seen during extraction.
  final int pageCount;

  /// Full cleaned text with original wording preserved.
  final String rawText;

  /// Detected chapters; a single fallback chapter when detection found none.
  final List<ExtractedChapter> chapters;

  /// Meaningful characters extracted (whitespace excluded).
  final int characterCount;

  Map<String, Object?> toJson() => {
    'bookId': bookId,
    'status': status.name,
    'pageCount': pageCount,
    'rawText': rawText,
    'chapters': [for (final c in chapters) c.toJson()],
    'characterCount': characterCount,
  };

  static ExtractedBookContent fromJson(Map<String, Object?> json) {
    final raw = json['rawText'];
    return ExtractedBookContent(
      bookId: json['bookId'] as String,
      status: ExtractionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ExtractionStatus.failed,
      ),
      pageCount: json['pageCount'] as int? ?? 0,
      rawText: raw is String ? raw : '',
      chapters: [
        for (final c in (json['chapters'] as List?) ?? const [])
          ExtractedChapter.fromJson(Map<String, Object?>.from(c as Map)),
      ],
      characterCount: json['characterCount'] as int? ?? 0,
    );
  }
}
