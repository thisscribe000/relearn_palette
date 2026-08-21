# Re-Learn — Project Context

Flutter mobile app: social learning around books and learning material.
The app converts a full book's ideas into short, narrated "learning bites".

## Product
- Read complete books
- Discover bite-sized explanations
- Listen to narrated learning content
- Review concepts and answer recall questions
- Track learning progress
- Future: learn socially with other users

The product does NOT replace reading — it helps users understand, revisit,
and remember what they read.

## Current Status
Implemented so far (onboarding + Home Learning Feed + Library + a full Book
Reader + Book Detail flow with live, session-only reading-position resume +
an Add Book / mock catalog search flow + REAL PDF IMPORT: users can pick a
PDF from their device, it is copied into app storage, appears as a normal
Library book, and opens in a native PDF reader with Continue Reading resume;
no backend/auth/AI/audio yet):

**Onboarding** — a single horizontally swipeable flow with three pages inside ONE
`PageView`, plus an animated indicator strip at the bottom driven by the
`PageController`:

1. **Page 0 — Splash** (`splash_page.dart`): wordmark "Re-Learn",
   tagline "Learn in scroll-length bites", `ReLearnLogo` mark.
2. **Page 1 — Concept** (`concept_page.dart`): headline "Turn any book into a reel.",
   supporting paragraph, `BookLearningIllustration` (open book + emerging cards).
3. **Page 2 — Get Started** (`get_started_page.dart`): headline "Your library, reimagined.",
   supporting text, `ReadingJourneyIllustration` (book → card → recall loop),
   "Get Started" + "I already have an account".

**Screen 04 — Home / Learning Feed** — built. After "Get Started", onboarding
navigates to `HomeFeedPage`, a shell with:

- A persistent custom `BottomNavigation` (Home → Learning Feed, Discover, Library,
  Me). Discover/Me are **placeholders** (Screens 06–07 not built yet). Compact by
  design: content wrapped in `SafeArea` (bottom system inset respected) with
  `EdgeInsets.only(top: 5, bottom: 2)` and tight icon/label/dot spacing.
- **Home tab** = `FeedHeader` (Re-Learn wordmark, search icon, For You/Following
  tabs) above a **vertical** `PageView.builder` of full-screen `LearningBite`
  widgets (one bite per swipe, 8 bites in `mock_bites.dart`).
- Each bite is an **editorial magazine composition** on the bare canvas — NOT a
  card. Hierarchy (top→bottom): small letterspaced-caps category kicker
  (e.g. `OBSERVATION`), large serif headline, `LearningBiteIllustration`
  (CustomPaint line art, observe/control/wonder motifs), 2-line explanation,
  gold hairline rule + `KEY IDEA` in serif italics, Listen chip, hairline
  divider, then the **source book** (serif title + author) with a
  "Read the full book →" link — the source book is treated as an important
  literary element, not tiny metadata. A right-edge `LearningBiteActions` rail
  (Like, Discuss, Save, Share — Like/Save toggle locally; the rest show a
  "coming soon" SnackBar via `showComingSoon`).
- `LearningBite` uses `FittedBox(scaleDown)` guards around the headline and the
  body/key-idea block so they scale instead of overflowing on short screens.
- **Reading-progress resume**: a floating `FloatingActionButton.extended`
  ("Continue Reading") appears on the Home tab while a reading session exists
  and reopens the Reader at the saved position. The Home feed tab also hosts the
  vertical bite reel. Design rule: the background is the canvas; whitespace
  creates hierarchy; no cards, no excess borders/shadows, no gradients.

**Screen 05 — Library** — built (`library_page.dart`):
- A personal bookshelf: header + search, All/Reading/Finished filter pills, a
  **Continue Reading card** (session-aware — shows the book actually in
  progress and its "Continue Reading" button resumes directly in the Reader; it
  opens Book Detail when no session exists), a 3-up grid of `BookCover`
  placeholders, and an "Import a book" tile.
- Shelf books open `BookDetailPage`. Library data is `mock_books.dart`
  (`LibraryBook` model in `library_book.dart`, 8 titles matching the feed's).

**Full Book Reader** (`features/reader`) — a conventional paged ebook reader:
- Tap to toggle chrome, horizontal swipes to turn pages, pages hold whole
  paragraphs. `ReaderTopBar` (back, TOC, search, bookmark, Aa, more) and
  `ReaderBottomBar` (chapter/page label, overall progress scrub, Read/Learn
  switch) form the chrome.
- **Aa settings** (`ReaderSettingsPanel`): serif/sans, font size, line spacing,
  paper/ivory/deep appearance, brightness — mock local state only.
- **TOC** (`ReaderTocPanel`) jumps between chapters or to Learning bites.
- **Learn mode** (`ReaderLearnView`): the book's learning bites as a quiet
  reading list; selecting text offers "Learn this".
- Pagination supports reading/resume: `ReaderPage` accepts `initialChapter` /
  `initialPage` and reports every position change to the `ReadingStore`.

**Screen 08 — Book Detail / Book Home** (`features/book`) — the bridge between
reading and learning, reached from the Library shelf and continue cards:
- Cover, title/author, live % complete + gold progress bar, **Start/Continue
  Reading** + **Learn the Book** buttons, About, a numbered **Chapters** list
  with READ/READING status, Learning-bites and Discussion panels (mock
  comments), and a More menu.
- `LearningBitesPage` is the "Learn the Book" destination: a full-screen,
  focused experience that swipes vertically through the book's learning bites,
  one per screen. Header shows book title + "1 of 12" and a thin gold
  exploration-progress line (distinct from reading progress). Each bite is an
  editorial composition — category kicker, serif headline, explanation,
  key-idea flourish, "Chapter n · <title>" attribution — with Save (local
  toggle), Discuss, and Share actions at the foot. Real bites for Sherlock
  (12, three per chapter) live in `mock_book_bites.dart` via `bookBitesFor`;
  other books get per-chapter placeholders. Discuss opens the shared mock
  Discussion sheet (`book_discussion_sheet.dart`) used by both Book Detail and
  Learning Bites. Content helpers live in `mock_book_details.dart`
  (`bookDetailFor`, `libraryBookForTitle`, `bitesForBook`, `readerBookFor`).

**Reading progress** — `ReadingStore` (`core/reading`): a ChangeNotifier
singleton holding one `ReadingSession` (bookTitle/author, chapter & page
index, progress). The Reader syncs position on page-turn/scrub/chapter-change
and on dispose (clears on 100%). No persistence yet — session-only, wiped on
app restart. Continue Reading entries: Home FAB, Library bottom bar
(`ContinueReadingBar`, shown on the Library tab) and card, and Book Detail.

**Add Book / Import** (`features/add_book`) — how books enter the Library:
- Entry point: the shelf's "Add a Book" tile (last grid cell) opens
  `AddBookPage` — serif "Add a Book / Find something to read" header, search
  field, an OR hairline divider, an **Import a PDF** tile, then Suggested
  Books.
- Search filters the local mock catalog (`mock_catalog.dart`, 11 titles =
  the 8 shelf books + Pride and Prejudice, The Great Gatsby, The Picture of
  Dorian Gray) by title OR author, case-insensitive. Empty query shows all;
  no matches shows a quiet "No books found" empty state. Result rows: small
  `BookCover`, serif title, author, year · category meta, and an Add button
  (or IN LIBRARY label when already shelved). Tapping a row opens
  `BookDetailPage` as a preview.
- **Book Detail preview state**: when the book is not on the shelf, the hero
  hides % complete/progress and shows "Not in your library · year · category
  · N chapters" with a single **Add to Library** button; adding flips it live
  into the normal Start Reading + Learn the Book state (snackbar confirms).
- **Library state** — `LibraryStore` (`core/library`): ChangeNotifier
  singleton seeded from `mockLibraryBooks`; `add()` prevents duplicates by
  stable `LibraryBook.id`. Library grid listens to it; `libraryBookForTitle`
  resolves through it so Continue Reading works for newly added books too.
  In-memory only — swap for a database later without touching consumers.
- **Real PDF import** (`pdf_import_service.dart`) — Import a PDF opens the
  system file picker (`.pdf` filtered), validates the pick, and copies the
  file into `<app documents>/imported_books/` (unique-name collision guard).
  The book record uses a stable id of `pdf:<filename>:<size>` so re-importing
  the same file shows an "Already in Library / Open Book" sheet instead of
  duplicating. Title is cleaned from the filename (`the_great_gatsby.pdf` →
  "The Great Gatsby"); author falls back to "Unknown Author"; cover tone is
  derived deterministically from the title. A processing bottom sheet covers
  pick → copy → done, with friendly failure states (no stack traces).
- **PDF books** — `LibraryBook.source` (`BookSource.mock | .pdf`) + optional
  `filePath`. Imported books flow through the normal Library/Book Detail:
  Book Detail hides the mock Chapters list, shows an imported-about line and
  a "Learning Bites — once processed" panel; Learn the Book opens a quiet
  placeholder sheet (no fake bites). `openBookReader` (reader_launcher.dart)
  routes: pdf → `PdfReaderPage` (native flutter_pdfview, vertical scroll,
  pinch zoom, page scrub), mock → existing paged `ReaderPage`. PDF progress
  reports to the same `ReadingStore` (chapterIndex 0, pageIndex = pdf page,
  progress = (page+1)/total) so Continue Reading bar/FAB/card resume at the
  last page; reaching the final page marks finished exactly like text books.
- **PDF content extraction** (`pdf_content_store.dart` + `pdfrx`) — when an
  imported book is added, its text is extracted once via PDFium
  (`pdf_text_extractor.dart`: `PdfDocument.openFile` → per-page `loadText`,
  page boundaries preserved) and persisted as JSON beside the PDF
  (`<app documents>/imported_books/content/<id>.json`). Conservative cleaning
  (`pdf_chapter_detector.dart`): page-number lines dropped, repeated running
  headers/footers stripped (>=60% of pages), soft-wrapped lines rejoined with
  de-hyphenation, whitespace collapsed — wording never rewritten. Chapter
  detection is deterministic (regex on "Chapter N / PART TWO / Prologue…"
  heading lines); no matches → a single "Full Book" fallback chapter. Scanned/
  image-only PDFs (<200 chars or <30 chars/page avg) are detected and marked
  `unsupported`; failures are marked `failed`. Both persist — extraction runs
  at most once per book, never auto-retried. Import sheet shows staged labels
  ("Extracting text…" → "Organizing chapters…") and a status-aware result
  (scanned → OCR-later note; the book is always added & readable). Book
  Detail's Learning Bites panel reflects live status (PROCESSED / SCANNED
  PAGES · OCR NEEDED / PROCESSING FAILED); More menu gains an "Inspect
  extracted content" debug screen for imported books showing status,
  chapters, and text peeks. No OCR yet — scanned books stay read-only.

Content is static mock data — no audio, backend, or auth yet.

## Architecture
```
lib/
  main.dart                      # ReLearnApp, home = OnboardingPage
  core/
    reading/
      reading_store.dart         # ReadingSession + ReadingStore (ChangeNotifier)
    library/
      library_store.dart         # LibraryStore (ChangeNotifier) — the shelf
    theme/
      app_colors.dart            # palette constants
      app_theme.dart             # ThemeData + AppFonts + button themes
  features/onboarding/presentation/
    pages/
      onboarding_page.dart       # ONE PageView flow (Page 0, 1, 2)
      splash_page.dart           # Page 0
      concept_page.dart          # Page 1
      get_started_page.dart      # Page 2 (callbacks onGetStarted/onSignIn)
    widgets/
      re_learn_logo.dart         # editorial ring + serif R logomark
      book_learning_illustration.dart  # open book + bite cards illustration
      reading_journey_illustration.dart # READ->LEARN->REMEMBER illustration
      onboarding_indicators.dart # animated pill indicator strip (activeIndex)
  features/home/
    domain/
      learning_bite.dart         # LearningBiteData model + BiteVisual enum
                                 #   (category, bookTitle, author, topic/headline,
                                 #   body, keyIdea, listenDuration, visual)
      library_book.dart          # LibraryBook (stable id, year, category,
                                 #   BookSource mock|pdf, filePath)
                                 #   + BookStatus + BookCoverTone
    data/
      mock_bites.dart            # 8 static prototype bites
      mock_books.dart            # 8 static shelf books (featuredBook first)
    presentation/
      pages/
        home_feed_page.dart      # Screen 04 shell + FAB resume + bottom nav
        discover_page.dart       # placeholder (Screen 06, not built)
        library_page.dart        # Screen 05 library (shelf, filters, continue)
        me_page.dart             # placeholder (Screen 07, not built)
      widgets/
        learning_bite.dart       # full-screen editorial bite composition
        learning_bite_actions.dart # Like/Discuss/Save/Share rail
        learning_bite_illustration.dart # CustomPaint line art, 3 variants
        feed_header.dart         # wordmark + search + For You/Following
        bottom_navigation.dart   # Home/Discover/Library/Me tabs
        coming_soon.dart         # showComingSoon() SnackBar helper
        book_cover.dart          # editorial placeholder cover (tone-based)
        continue_reading_bar.dart # session-aware "you were reading" bar
  features/reader/
    domain/
      reader_book.dart           # ReaderBook / ReaderChapter / ReaderBite
    data/
      mock_reader_book.dart      # Sherlock prototype (4 chapters, 3 bites)
    presentation/
      reader_settings.dart       # ReaderSettings + ReaderAppearance palette
      reader_launcher.dart       # openBookReader(): routes pdf vs mock
      pages/
        reader_page.dart         # paged reader + resume (initialChapter/Page)
        pdf_reader_page.dart     # native PDF reader for imported books
      widgets/
        reader_top_bar.dart      # back/TOC/search/bookmark/Aa/more
        reader_bottom_bar.dart   # chapter/page, progress scrub, Read/Learn
        reader_paginator.dart    # paginateParagraphs() text layout
        reader_settings_panel.dart # Aa sheet (Aa font/size/spacing/theme)
        reader_toc_panel.dart    # chapter list + bites shortcut
        reader_learn_view.dart   # Learn mode bite list
        bite_list_item.dart      # shared quiet bite row (Learn mode)
  features/book/
    domain/
      book_bite.dart             # BookBite: chapter-anchored learning bite
    data/
      mock_book_details.dart     # per-book descriptions/chapters/reader/bites
      mock_book_bites.dart       # 12 real Sherlock bites + bookBitesFor()
    presentation/
      pages/
        book_detail_page.dart    # Book Home: hero, chapters, bites, discussion
        learning_bites_page.dart # full-screen vertical Learning Bites flow
      widgets/
        book_discussion_sheet.dart # shared mock Discussion bottom sheet
  features/add_book/
    data/
      mock_catalog.dart          # searchable catalog (shelf + 3 classics)
      pdf_import_service.dart    # pickPdf()/importPdf(): picker, validation,
                                 #   copy to app docs, title/id derivation
      pdf_text_extractor.dart    # pdfrx/PDFium per-page text extraction
      pdf_chapter_detector.dart  # conservative cleaning + regex chapter split
      pdf_content_store.dart     # extract-once orchestrator; JSON persistence,
                                 #   scanned/failed detection, memory cache
    domain/
      extracted_book_content.dart # ExtractedBookContent/Chapter + status enum
    presentation/
      pages/
        add_book_page.dart       # search, Import PDF sheet, results list
        extracted_content_preview_page.dart # debug: status/chapters/text peeks
```

## Design System
| Token | Value |
|---|---|
| Background | `#F9F7F2` |
| Primary deep green | `#061B0E` |
| Secondary muted text | `#5E5E5B` |
| Indicator inactive | `#C3C8C1` |
| Paper (illustration fill) | `#FFFDF8` |
| Muted gold (accent) | `#B08D57` |

- Editorial, literary, premium, minimal. NOT school/kids/AI/dashboard/crypto style.
- No shadows, no gradients, no continuous animation.
- Headings: Source Serif 4 (700/600). Supporting/utility text: Inter (500/400).
- Sharp corners, generous whitespace, 8px spacing rhythm.

## Indicators
`OnboardingIndicators(activeIndex: i)` — active = 24x6 pill, inactive = 6x6 circle.

## Fonts
Local font files NOT yet bundled (POC falls back to system fonts).
`AppFonts.serif = 'Source Serif 4'`, `AppFonts.sans = 'Inter'`.
Add TTFs and uncomment the `fonts:` block in `pubspec.yaml` when available.

## Commands
- `flutter run` — run on simulator/device
- `flutter build apk --debug` — Android debug build (verified working)
- `flutter analyze` — static analysis (should be clean)

## Notes / Environment
- Xcode 26.6 requires the iOS 26.5 simulator runtime.
  If simulators appear ineligible, run `xcodebuild -downloadPlatform iOS`.
- Platform targets: Android + iOS only.
- External packages: `file_picker` (system PDF picker), `flutter_pdfview`
  (native PDF rendering), `pdfrx` (PDFium text extraction for imported
  books; viewer widgets unused — flutter_pdfview stays the reading surface),
  `path_provider` (app documents dir).
- Reading position is in-memory only (`ReadingStore` singleton); a full app
  restart clears it. Wire persistence (e.g. `shared_preferences`) later.