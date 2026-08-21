import '../../home/data/mock_books.dart';
import '../../home/domain/library_book.dart';

/// Additional classic titles offered through Add Book that are not on the
/// default shelf yet.
const _additionalCatalogBooks = <LibraryBook>[
  LibraryBook(
    id: 'pride-prejudice',
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    status: BookStatus.toRead,
    progress: 0,
    tone: BookCoverTone.forest,
    year: '1813',
    category: 'Romance',
  ),
  LibraryBook(
    id: 'great-gatsby',
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
    status: BookStatus.toRead,
    progress: 0,
    tone: BookCoverTone.ivory,
    year: '1925',
    category: 'Fiction',
  ),
  LibraryBook(
    id: 'dorian-gray',
    title: 'The Picture of Dorian Gray',
    author: 'Oscar Wilde',
    status: BookStatus.toRead,
    progress: 0,
    tone: BookCoverTone.clay,
    year: '1890',
    category: 'Gothic',
  ),
];

/// Everything findable through Add Book search: the current shelf plus the
/// additional catalog titles, de-duplicated by stable id so a book added
/// from this list never appears twice.
final List<LibraryBook> mockCatalogBooks = () {
  final seen = <String>{};
  return [
    for (final book in [...mockLibraryBooks, ..._additionalCatalogBooks])
      if (seen.add(book.id)) book,
  ];
}();
