import '../../home/data/mock_books.dart';
import '../../home/domain/library_book.dart';
import '../../reader/data/mock_reader_book.dart';
import '../../reader/domain/reader_book.dart';

/// Editorial metadata used by the Book Detail screen.
class BookDetailInfo {
  const BookDetailInfo({required this.description, required this.chapters});

  final String description;
  final List<String> chapters;
}

const _details = <String, BookDetailInfo>{
  'The Adventures of Sherlock Holmes': BookDetailInfo(
    description:
        'Twelve short adventures follow Dr. Watson and the great detective as '
        'he solves mysteries by sharp observation and calm reasoning — the '
        'perfect first lesson in paying attention.',
    chapters: [
      'A Scandal in Bohemia',
      'The Red-Headed League',
      'A Case of Identity',
      'The Boscombe Valley Mystery',
    ],
  ),
  'Meditations': BookDetailInfo(
    description:
        'Notes a Roman emperor wrote to himself — private, practical reminders '
        'about control, duty, and the mind. A book meant to be revisited '
        'rather than finished.',
    chapters: [
      'What Is in Your Power',
      'On Duty and Purpose',
      'The Passing of Things',
      'The Inner Citadel',
    ],
  ),
  "Alice's Adventures in Wonderland": BookDetailInfo(
    description:
        'A child tumbles into a world where logic keeps changing its rules. A '
        'playful study of curiosity, language, and the pleasure of getting '
        'lost.',
    chapters: [
      'Down the Rabbit-Hole',
      'The Pool of Tears',
      'A Caucus-Race',
      'The Rabbit Sends in a Little Bill',
    ],
  ),
  'The Art of War': BookDetailInfo(
    description:
        'Thirteen chapters of terse strategy about positioning, information, '
        'and timing — as useful in quiet negotiations as on a battlefield.',
    chapters: [
      'Laying Plans',
      'Waging War',
      'Attack by Stratagem',
      'Tactical Dispositions',
      'Energy',
    ],
  ),
  'The Alchemist': BookDetailInfo(
    description:
        'A shepherd boy follows a recurring dream across a desert, learning '
        'that the treasure he seeks was tied to the journey itself.',
    chapters: ['The Sheep', 'The Oasis', 'The Alchemist', 'The Treasure'],
  ),
  'The Little Prince': BookDetailInfo(
    description:
        'A pilot stranded in the desert meets a small prince who asks the '
        'questions adults forgot. A short book about care, time, and what is '
        'essential.',
    chapters: ['The Pilot', 'The Rose', 'The Fox', 'The Return'],
  ),
  'Sapiens': BookDetailInfo(
    description:
        'A sweeping history of how a modest species came to dominate the '
        'planet through shared stories — from myths to money to nations.',
    chapters: [
      'An Animal of No Significance',
      'The Tree of Knowledge',
      'The Agricultural Revolution',
      'The Unification of Humankind',
    ],
  ),
  'The Psychology of Money': BookDetailInfo(
    description:
        'How we think about money is less a math problem and more a behaviour '
        'problem — best learned in quiet habits rather than loud ones.',
    chapters: [
      'No One Is Crazy',
      'Luck and Risk',
      'Getting Wealthy vs. Staying Wealthy',
      'The Seduction of Pessimism',
    ],
  ),
};

const _fallbackInfo = BookDetailInfo(
  description:
      'A title on the Re-Learn shelf. Full description will be added when '
      'real book content is loaded.',
  chapters: ['Chapter One', 'Chapter Two', 'Chapter Three'],
);

BookDetailInfo bookDetailFor(String title) => _details[title] ?? _fallbackInfo;

/// Finds the library book for a title; falls back to the featured book.
LibraryBook libraryBookForTitle(String title) {
  for (final book in mockLibraryBooks) {
    if (book.title == title) return book;
  }
  return mockLibraryBooks.first;
}

/// Learning bites for a book. Real bites for the featured title; a single
/// prototype placeholder for the rest.
List<ReaderBite> bitesForBook(LibraryBook book) {
  if (book.title == mockReaderBook.title) return mockReaderBook.bites;
  return [
    ReaderBite(
      category: 'READING',
      topic: 'Short ideas from ${book.title}',
      keyIdea: 'FULL BITES ARE BEING PREPARED',
      duration: '0:40',
      excerpt:
          'Prototype content. In the full build, learning bites are generated '
          'from the passages of this book.',
    ),
  ];
}

/// Builds a ReaderBook for any library book so the Reader works end-to-end.
/// The featured title reuses the real prototype text; the others use
/// lightweight placeholder chapters.
ReaderBook readerBookFor(LibraryBook book) {
  if (book.title == mockReaderBook.title) return mockReaderBook;

  final info = bookDetailFor(book.title);
  final filler = <String>[
    'This is prototype content from ${book.title} by ${book.author}. In the '
        'full build, the actual text of this chapter will appear here.',
    'Re-Learn reads the way a book reads — one page at a time, with '
        'comfortable margins and honest typography. This placeholder lets the '
        'reader flow and page exactly the way the finished product will.',
    'For now the idea matters more than the words. Every book on your shelf '
        'should open into a calm, focused reading space like this one.',
  ];

  return ReaderBook(
    title: book.title,
    author: book.author,
    chapters: [
      for (final title in info.chapters)
        ReaderChapter(title: title, paragraphs: filler),
    ],
    bites: bitesForBook(book),
  );
}
