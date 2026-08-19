/// A bite derived from a book, shown in the Reader's Learn mode.
class ReaderBite {
  const ReaderBite({
    required this.category,
    required this.topic,
    required this.keyIdea,
    required this.duration,
    required this.excerpt,
  });

  final String category;
  final String topic;
  final String keyIdea;
  final String duration;
  final String excerpt;
}

/// A single chapter of a [ReaderBook].
class ReaderChapter {
  const ReaderChapter({required this.title, required this.paragraphs});

  final String title;
  final List<String> paragraphs;
}

/// A full book opened in the Reader. Prototype mock content only.
class ReaderBook {
  const ReaderBook({
    required this.title,
    required this.author,
    required this.chapters,
    required this.bites,
  });

  final String title;
  final String author;
  final List<ReaderChapter> chapters;
  final List<ReaderBite> bites;
}
