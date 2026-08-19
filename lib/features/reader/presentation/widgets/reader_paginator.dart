import 'package:flutter/painting.dart';

/// Splits a chapter into page-sized groups of whole paragraphs.
///
/// Each paragraph is measured with the same [style] at the given [width];
/// paragraphs are packed greedily into pages no taller than [height], with
/// [paragraphGap] between them. Paragraphs are never split mid-paragraph.
List<List<String>> paginateParagraphs({
  required List<String> paragraphs,
  required double width,
  required double height,
  required TextStyle style,
  required double paragraphGap,
}) {
  if (width <= 0 || height <= 0) {
    return [paragraphs];
  }

  final pages = <List<String>>[];
  var current = <String>[];
  var used = 0.0;

  for (final paragraph in paragraphs) {
    if (paragraph.trim().isEmpty) continue;

    final painter = TextPainter(
      text: TextSpan(text: paragraph, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: width);

    final blockHeight = painter.height + (current.isEmpty ? 0.0 : paragraphGap);

    if (current.isNotEmpty && used + blockHeight > height) {
      pages.add(current);
      current = <String>[];
      used = 0.0;
    }

    used += painter.height + (current.isEmpty ? 0.0 : paragraphGap);
    current.add(paragraph);
  }

  if (current.isNotEmpty) pages.add(current);
  return pages.isEmpty ? [paragraphs] : pages;
}
