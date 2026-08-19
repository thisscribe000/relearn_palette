import 'package:flutter/foundation.dart';

/// A live reading position for the currently open book.
///
/// State survives navigation while the app is open. To keep this
/// persistence-ready, the session is a plain value object that can later be
/// serialized (see [ReadingSession.toJson]) without changing its consumers.
class ReadingSession {
  const ReadingSession({
    required this.bookTitle,
    required this.bookAuthor,
    required this.chapterIndex,
    required this.pageIndex,
    required this.progress,
  });

  final String bookTitle;
  final String bookAuthor;
  final int chapterIndex;
  final int pageIndex;

  /// Fraction complete (0.0–1.0).
  final double progress;

  Map<String, Object?> toJson() => {
    'bookTitle': bookTitle,
    'bookAuthor': bookAuthor,
    'chapterIndex': chapterIndex,
    'pageIndex': pageIndex,
    'progress': progress,
  };
}

/// App-wide reading progress store.
///
/// A [ChangeNotifier] so any widget (Home, Library, Book Detail) can react to
/// position updates without a state-management dependency. Mock persistence:
/// nothing is written to disk yet — later this class can be backed by a
/// database without changing consumers.
class ReadingStore extends ChangeNotifier {
  ReadingStore._();

  static final ReadingStore instance = ReadingStore._();

  ReadingSession? _session;

  ReadingSession? get session => _session;

  bool get hasSession => _session != null;

  void setPosition({
    required String bookTitle,
    required String bookAuthor,
    required int chapterIndex,
    required int pageIndex,
    required double progress,
  }) {
    _session = ReadingSession(
      bookTitle: bookTitle,
      bookAuthor: bookAuthor,
      chapterIndex: chapterIndex,
      pageIndex: pageIndex,
      progress: progress,
    );
    notifyListeners();
  }

  /// Clears the position because the reader was dismissed.
  void dismiss() {
    _session = null;
    notifyListeners();
  }

  /// Clears the position because the book was finished.
  void markFinished() {
    _session = null;
    notifyListeners();
  }
}
