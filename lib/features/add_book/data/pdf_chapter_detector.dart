import '../domain/extracted_book_content.dart';

/// Conservative text cleaning and deterministic chapter detection.
///
/// Everything here is rule-based: no AI, no paraphrasing, no summarizing.
/// The goal is tidy input for the future learning pipeline while staying as
/// close to the source words as possible.

final _pageNumberLine = RegExp(r'^(page\s+)?\d{1,4}(\s+of\s+\d{1,4})?$',
    caseSensitive: false);
final _whitespaceRun = RegExp(r'[ \t]{2,}');
final _trailingHyphen = RegExp(r'[A-Za-z]-$');

/// Cleans one page's raw text conservatively:
/// - drops obvious page-number-only lines,
/// - collapses repeated whitespace,
/// - rejoins lines the PDF layout wrapped mid-paragraph (de-hyphenating),
/// - keeps paragraph breaks where blank lines existed.
String cleanPageText(String raw) {
  final rawLines = raw.split('\n').map((l) => l.trim()).toList();

  // Drop page-number-only lines, keep blanks as paragraph separators.
  final lines = <String>[];
  var blankRun = false;
  for (final line in rawLines) {
    if (line.isEmpty) {
      if (!blankRun && lines.isNotEmpty) lines.add('');
      blankRun = true;
      continue;
    }
    blankRun = false;
    if (_pageNumberLine.hasMatch(line)) continue;
    lines.add(line.replaceAll(_whitespaceRun, ' '));
  }

  // Rebuild paragraphs: consecutive text lines are joined; blank lines break.
  final paragraphs = <String>[];
  final buffer = StringBuffer();
  void flush() {
    final text = buffer.toString().trim();
    if (text.isNotEmpty) paragraphs.add(text);
    buffer.clear();
  }

  for (final line in lines) {
    if (line.isEmpty) {
      flush();
      continue;
    }
    if (buffer.isNotEmpty) {
      final current = buffer.toString();
      if (current.endsWith('-') &&
          _trailingHyphen.hasMatch(current) &&
          RegExp(r'^[a-z]').hasMatch(line)) {
        // "...exam-" + "ple..." -> "...example..."
        buffer
          ..clear()
          ..write(current.substring(0, current.length - 1));
      } else {
        buffer.write(' ');
      }
    }
    buffer.write(line);
  }
  flush();

  return paragraphs.join('\n\n');
}

String _edgeKey(String line) => line
    .toLowerCase()
    .replaceAll(RegExp(r'[\d\s\p{P}]', unicode: true), '');

String _firstMeaningful(String page) =>
    page.split('\n').firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');

String _lastMeaningful(String page) {
  final lines =
      page.split('\n').where((l) => l.trim().isNotEmpty).toList(growable: false);
  return lines.isEmpty ? '' : lines.last;
}

/// Removes running headers/footers that repeat across most pages
/// (e.g. the book title at every page top). Only fires when a normalized
/// edge line appears on >=60% of pages, so unique lines are never touched.
List<String> stripRepeatedHeadersFooters(List<String> pages) {
  if (pages.length < 4) return pages;

  final threshold = (pages.length * 0.6).floor();
  final topCounts = <String, int>{};
  final bottomCounts = <String, int>{};
  for (final page in pages) {
    final top = _edgeKey(_firstMeaningful(page));
    final bottom = _edgeKey(_lastMeaningful(page));
    if (top.isNotEmpty && top.length <= 60) {
      topCounts[top] = (topCounts[top] ?? 0) + 1;
    }
    if (bottom.isNotEmpty && bottom.length <= 60) {
      bottomCounts[bottom] = (bottomCounts[bottom] ?? 0) + 1;
    }
  }

  final repeated = <String>{
    ...topCounts.entries.where((e) => e.value >= threshold).map((e) => e.key),
    ...bottomCounts.entries
        .where((e) => e.value >= threshold)
        .map((e) => e.key),
  };
  if (repeated.isEmpty) return pages;

  bool isNoise(String l) =>
      l.trim().isEmpty || repeated.contains(_edgeKey(l));

  return [
    for (final page in pages)
      page
          .split('\n')
          .skipWhile(isNoise)
          .toList()
          .reversed
          .skipWhile(isNoise)
          .toList()
          .reversed
          .join('\n'),
  ];
}

const _numberWords = <String, int>{
  'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
  'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
  'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15,
  'sixteen': 16, 'seventeen': 17, 'eighteen': 18, 'nineteen': 19, 'twenty': 20,
};

int? _parseRoman(String token) {
  final values = {'i': 1, 'v': 5, 'x': 10, 'l': 50, 'c': 100, 'd': 500, 'm': 1000};
  final t = token.toLowerCase();
  if (t.length > 7 || !RegExp(r'^[ivxlcdm]+$').hasMatch(t)) return null;
  var total = 0;
  for (var i = 0; i < t.length; i++) {
    final value = values[t[i]]!;
    final next = i + 1 < t.length ? values[t[i + 1]]! : 0;
    total += value < next ? -value : value;
  }
  return total > 0 ? total : null;
}

int? _parseOrdinal(String token) {
  final t = token.toLowerCase();
  return int.tryParse(t) ?? _numberWords[t] ?? _parseRoman(t);
}

final _ordinalAlternation = _numberWords.keys.toList().join('|');

final _headingPattern = RegExp(
  r'^(chapter|chap\.?|part|prologue|epilogue|introduction|preface|foreword|afterword|conclusion)'
  r'(?:\s+([0-9]+|[ivxlcdm]+|'
  '$_ordinalAlternation))?'
  r'[.:—–-]?\s*(.*)$',
  caseSensitive: false,
);

String _capitalize(String word) =>
    word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);

String _defaultTitle(String kind, int? ordinal) {
  switch (kind) {
    case 'prologue':
      return 'Prologue';
    case 'epilogue':
      return 'Epilogue';
    case 'introduction':
      return 'Introduction';
    case 'preface':
      return 'Preface';
    case 'foreword':
      return 'Foreword';
    case 'afterword':
      return 'Afterword';
    case 'conclusion':
      return 'Conclusion';
    default:
      return ordinal != null
          ? '${_capitalize(kind)} $ordinal'
          : _capitalize(kind);
  }
}

/// Detects chapter boundaries deterministically from cleaned page texts.
///
/// Best-effort by design — PDFs vary enormously. A heading must be a short
/// line starting with chapter-like keywords ("Chapter 7", "PART TWO",
/// "Prologue: …"). When nothing convincing is found, callers fall back to a
/// single full-book chapter rather than guessing.
List<ExtractedChapter> detectChapters(List<String> pages) {
  final boundaries = <(int, String)>[]; // (pageIndex, title)

  for (var p = 0; p < pages.length; p++) {
    for (final line in pages[p].split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.length > 80) continue;
      final match = _headingPattern.firstMatch(trimmed);
      if (match == null) continue;

      final kind = match.group(1)!.toLowerCase().replaceAll('.', '');
      final ordinalToken = match.group(2);
      final remainder = (match.group(3) ?? '').trim();
      if (remainder.length > 60) continue; // body sentences, not headings

      final numbered = kind == 'chapter' || kind == 'chap' || kind == 'part';
      if (numbered && ordinalToken == null) continue;

      final ordinal = ordinalToken == null ? null : _parseOrdinal(ordinalToken);
      if (numbered && ordinal == null) continue; // roman-garbage filter

      final base = _defaultTitle(kind, ordinal);
      boundaries.add((p, remainder.isNotEmpty ? '$base: $remainder' : base));
    }
  }

  if (boundaries.length < 2) {
    final text = pages.join('\n\n').trim();
    return [
      ExtractedChapter(
        index: 0,
        title: 'Full Book',
        text: text,
        startPage: 0,
        endPage: pages.isEmpty ? 0 : pages.length - 1,
      ),
    ];
  }

  final chapters = <ExtractedChapter>[];
  for (var b = 0; b < boundaries.length; b++) {
    final start = boundaries[b].$1;
    final end =
        b + 1 < boundaries.length ? boundaries[b + 1].$1 : pages.length - 1;
    chapters.add(
      ExtractedChapter(
        index: chapters.length,
        title: boundaries[b].$2,
        text: [for (var p = start; p <= end; p++) pages[p]].join('\n\n').trim(),
        startPage: start,
        endPage: end,
      ),
    );
  }
  return chapters;
}
