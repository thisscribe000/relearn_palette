/// Reading status of a book in the user's library.
enum BookStatus { reading, finished, toRead }

/// Where a book came from: the built-in mock catalog or a user-imported PDF.
enum BookSource { mock, pdf }

/// Muted editorial palette tone used to render a placeholder book cover.
enum BookCoverTone {
  deepGreen,
  forest,
  olive,
  clay,
  rust,
  ink,
  warmCream,
  sand,
  sage,
  ivory,
}

/// A single book on the user's personal bookshelf (Screen 05 — Library).
///
/// Prototype mock data for now; no backend is connected.
class LibraryBook {
  const LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.progress,
    required this.tone,
    this.biteCount = 0,
    this.biteDuration = '',
    this.year = '',
    this.category = '',
    this.source = BookSource.mock,
    this.filePath,
  });

  /// Stable identity used to prevent duplicate shelf entries.
  final String id;

  final String title;
  final String author;
  final BookStatus status;

  /// Fraction complete (0.0–1.0); 0 for unstarted books.
  final double progress;

  /// Cover palette used by [BookCover].
  final BookCoverTone tone;

  /// Number of Learning Bites available for this book in the feed.
  final int biteCount;

  /// Listen duration of a bite for this book (e.g. `0:38`).
  final String biteDuration;

  /// Publication year (e.g. `1892`); empty when unknown.
  final String year;

  /// Editorial category (e.g. `Mystery`); empty when unknown.
  final String category;

  /// Where this book came from; drives which reader opens it.
  final BookSource source;

  /// App-local path of the imported PDF file; null for mock books.
  final String? filePath;

  bool get isPdf => source == BookSource.pdf;
}
