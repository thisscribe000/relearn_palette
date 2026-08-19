import '../domain/library_book.dart';

/// The featured book currently being read (Continue Reading section).
final LibraryBook featuredBook = mockLibraryBooks.first;

/// Static prototype books shown on the Library shelf.
///
/// Titles mirror the canonical books already used in [mockLearningBites]
/// so the Library and the Learning Feed stay consistent.
const mockLibraryBooks = <LibraryBook>[
  LibraryBook(
    title: 'The Adventures of Sherlock Holmes',
    author: 'Arthur Conan Doyle',
    status: BookStatus.reading,
    progress: 0.64,
    tone: BookCoverTone.deepGreen,
    biteCount: 1,
    biteDuration: '0:38',
  ),
  LibraryBook(
    title: 'Meditations',
    author: 'Marcus Aurelius',
    status: BookStatus.reading,
    progress: 0.32,
    tone: BookCoverTone.warmCream,
    biteCount: 1,
    biteDuration: '0:37',
  ),
  LibraryBook(
    title: "Alice's Adventures in Wonderland",
    author: 'Lewis Carroll',
    status: BookStatus.reading,
    progress: 0.12,
    tone: BookCoverTone.sand,
    biteCount: 1,
    biteDuration: '0:45',
  ),
  LibraryBook(
    title: 'The Art of War',
    author: 'Sun Tzu',
    status: BookStatus.reading,
    progress: 0.55,
    tone: BookCoverTone.rust,
    biteCount: 1,
    biteDuration: '0:38',
  ),
  LibraryBook(
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    status: BookStatus.finished,
    progress: 1.0,
    tone: BookCoverTone.clay,
    biteCount: 1,
    biteDuration: '0:40',
  ),
  LibraryBook(
    title: 'The Little Prince',
    author: 'Antoine de Saint-Exupéry',
    status: BookStatus.finished,
    progress: 1.0,
    tone: BookCoverTone.sage,
    biteCount: 1,
    biteDuration: '0:36',
  ),
  LibraryBook(
    title: 'Sapiens',
    author: 'Yuval Noah Harari',
    status: BookStatus.finished,
    progress: 1.0,
    tone: BookCoverTone.ink,
    biteCount: 1,
    biteDuration: '0:41',
  ),
  LibraryBook(
    title: 'The Psychology of Money',
    author: 'Morgan Housel',
    status: BookStatus.toRead,
    progress: 0.0,
    tone: BookCoverTone.olive,
    biteCount: 1,
    biteDuration: '0:39',
  ),
];
