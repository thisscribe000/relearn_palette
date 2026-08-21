import 'package:flutter/foundation.dart';

import '../../features/home/data/mock_books.dart';
import '../../features/home/domain/library_book.dart';

/// App-wide library shelf store.
///
/// A [ChangeNotifier] singleton, mirroring [ReadingStore]'s pattern: any
/// screen (Library, Add Book, Book Detail) can listen for shelf changes
/// without a state-management dependency. Seeded from the static mock
/// books; additions live only in memory. Swapping this class for a
/// database-backed implementation later requires no changes in consumers.
class LibraryStore extends ChangeNotifier {
  LibraryStore._();

  static final LibraryStore instance = LibraryStore._();

  final List<LibraryBook> _books = List.of(mockLibraryBooks);

  /// The current shelf, newest addition last.
  List<LibraryBook> get books => List.unmodifiable(_books);

  bool containsId(String id) => _books.any((b) => b.id == id);

  bool containsTitle(String title) => _books.any((b) => b.title == title);

  /// Adds a book to the shelf unless it is already present (matched by its
  /// stable [LibraryBook.id]). Returns true when the book was added.
  bool add(LibraryBook book) {
    if (containsId(book.id)) return false;
    _books.add(book);
    notifyListeners();
    return true;
  }
}
