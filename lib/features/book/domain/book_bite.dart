/// A single learning bite for the book-level Learning Bites experience.
///
/// Unlike the feed's [LearningBiteData] (a discovery surface) and the
/// Reader's [ReaderBite] (a passage tied to Learn mode), this model anchors a
/// bite to a specific chapter of a book so it can be explored in sequence.
class BookBite {
  const BookBite({
    required this.id,
    required this.bookTitle,
    required this.chapterIndex,
    required this.chapterTitle,
    required this.category,
    required this.title,
    required this.explanation,
    required this.keyIdea,
  });

  /// Stable identifier for local save state within a session.
  final String id;

  /// The book this bite was drawn from.
  final String bookTitle;

  /// Zero-based index of the chapter this bite belongs to.
  final int chapterIndex;

  final String chapterTitle;

  /// Editorial kicker, e.g. `OBSERVATION`.
  final String category;

  /// The idea itself — the bite's headline.
  final String title;

  /// Short supporting explanation of the idea.
  final String explanation;

  /// One-line takeaway shown as the "KEY IDEA" flourish.
  final String keyIdea;
}
