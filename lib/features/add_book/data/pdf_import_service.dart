import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/library/library_store.dart';
import '../../home/domain/library_book.dart';

/// A user-selected PDF that has been validated but not yet copied into the
/// app's storage.
class PickedPdf {
  const PickedPdf({
    required this.fileName,
    required this.sizeBytes,
    required this.tempPath,
  });

  final String fileName;
  final int sizeBytes;
  final String tempPath;

  /// Stable identity (name + size) used to prevent duplicate imports.
  String get id => 'pdf:${fileName.toLowerCase()}:$sizeBytes';

  /// Human-friendly title cleaned from the file name.
  String get title => titleFromPdfFilename(fileName);
}

/// A user-facing import failure. The message is safe to show as-is; no stack
/// traces or platform errors reach the UI.
class PdfImportException implements Exception {
  PdfImportException(this.message);

  final String message;
}

/// Asks the user for a PDF and validates it. Returns null when the picker was
/// dismissed. Throws [PdfImportException] for invalid selections.
Future<PickedPdf?> pickPdf() async {
  final PlatformFile? picked;
  try {
    picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  } catch (_) {
    throw PdfImportException(
      'The file could not be opened. Please try again.',
    );
  }
  if (picked == null) return null;

  final name = picked.name.trim();
  if (name.isEmpty || !name.toLowerCase().endsWith('.pdf')) {
    throw PdfImportException('Please select a valid PDF.');
  }
  final path = picked.path;
  if (path == null || !File(path).existsSync()) {
    throw PdfImportException(
      'That file could not be read. Please select a valid PDF.',
    );
  }

  int sizeBytes;
  try {
    sizeBytes = await picked.length();
  } catch (_) {
    throw PdfImportException(
      'That file could not be read. Please select a valid PDF.',
    );
  }

  return PickedPdf(
    fileName: name,
    sizeBytes: sizeBytes,
    tempPath: path,
  );
}

/// Copies a picked PDF into app-controlled storage and builds its
/// [LibraryBook] record. Throws [PdfImportException] when the copy fails.
Future<LibraryBook> importPdf(PickedPdf pdf) async {
  final Directory docsDir;
  try {
    docsDir = await getApplicationDocumentsDirectory();
  } catch (_) {
    throw PdfImportException('Storage is unavailable right now.');
  }

  final booksDir = Directory('${docsDir.path}/imported_books');
  if (!booksDir.existsSync()) booksDir.createSync(recursive: true);

  final destination = _uniqueDestination(booksDir.path, pdf.fileName);
  try {
    await File(pdf.tempPath).copy(destination);
  } catch (_) {
    throw PdfImportException(
      'The book could not be saved. Please try again.',
    );
  }

  return LibraryBook(
    id: pdf.id,
    title: pdf.title,
    author: 'Unknown Author',
    status: BookStatus.toRead,
    progress: 0,
    tone: _toneForTitle(pdf.title),
    year: '',
    category: 'PDF',
    source: BookSource.pdf,
    filePath: destination,
  );
}

/// Picks a unique path inside [dirPath] so two different files that share a
/// name never overwrite each other.
String _uniqueDestination(String dirPath, String fileName) {
  final stem = fileName.substring(0, fileName.length - 4); // minus ".pdf"
  var candidate = '$dirPath/$stem.pdf';
  var counter = 2;
  while (File(candidate).existsSync()) {
    candidate = '$dirPath/$stem ($counter).pdf';
    counter++;
  }
  return candidate;
}

/// Deterministic cover tone so each imported title gets a stable look without
/// any generated artwork.
BookCoverTone _toneForTitle(String title) {
  const tones = BookCoverTone.values;
  return tones[title.hashCode.abs() % tones.length];
}

/// Turns a PDF file name into a readable title:
/// `the_great_gatsby.pdf` -> `The Great Gatsby`.
///
/// Underscores and hyphens become spaces; words that were typed all in
/// lowercase are capitalized while mixed-case words (acronyms like "MLK",
/// "PDF") are left untouched.
String titleFromPdfFilename(String fileName) {
  var stem = fileName;
  final dot = stem.toLowerCase().lastIndexOf('.pdf');
  if (dot >= 0) stem = stem.substring(0, dot);

  final words = stem
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((word) {
        if (word != word.toLowerCase()) return word;
        if (word.length <= 1) return word.toUpperCase();
        return word[0].toUpperCase() + word.substring(1);
      })
      .toList();

  return words.isEmpty ? 'Imported Book' : words.join(' ');
}

/// True when an identical file (same name + size) is already on the shelf.
bool pdfAlreadyInLibrary(PickedPdf pdf) =>
    LibraryStore.instance.containsId(pdf.id);

/// Finds the shelf record of an already-imported file.
LibraryBook? importedBookFor(PickedPdf pdf) {
  for (final book in LibraryStore.instance.books) {
    if (book.id == pdf.id) return book;
  }
  return null;
}
