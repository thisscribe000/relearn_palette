/// Visual motif used by a Learning Bite's editorial illustration.
enum BiteVisual { observe, control, wonder }

/// A single Learning Bite: the core content unit of the Home feed.
///
/// Bites are prototype content for now; no backend is connected.
class LearningBiteData {
  const LearningBiteData({
    required this.category,
    required this.bookTitle,
    required this.author,
    required this.topic,
    required this.body,
    required this.keyIdea,
    required this.listenDuration,
    required this.visual,
    this.passageLines = const [],
    this.activeLineIndex = 1,
  });

  final String category;
  final String bookTitle;
  final String author;
  final String topic;
  final String body;
  final String keyIdea;
  final String listenDuration;
  final BiteVisual visual;
  final List<String> passageLines;
  final int activeLineIndex;
}
