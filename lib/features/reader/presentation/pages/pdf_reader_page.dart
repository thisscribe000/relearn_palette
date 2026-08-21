import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../widgets/reader_top_bar.dart';

/// Reader for imported PDF books.
///
/// Mirrors the text reader's chrome language — tap to toggle, serif title,
/// gold progress scrub — but renders the real document pages natively
/// (vertical scroll, pinch zoom). Progress reports to the same
/// [ReadingStore] so Continue Reading works identically.
class PdfReaderPage extends StatefulWidget {
  const PdfReaderPage({
    super.key,
    required this.title,
    required this.author,
    required this.filePath,
    this.initialPage = 0,
    this.store,
  });

  final String title;
  final String author;
  final String filePath;
  final int initialPage;

  final ReadingStore? store;

  @override
  State<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  PDFViewController? _controller;
  int _page = 0;
  int _pagesTotal = 0;
  bool _ready = false;
  bool _failed = false;
  bool _finished = false;
  bool _controlsVisible = true;
  bool _bookmarked = false;

  ReadingStore get _store => widget.store ?? ReadingStore.instance;

  @override
  void initState() {
    super.initState();
    final session = _store.session;
    final resume = session != null && session.bookTitle == widget.title
        ? session
        : null;
    _page = resume?.pageIndex ?? widget.initialPage;
  }

  @override
  void dispose() {
    _syncPosition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_controlsVisible)
              ReaderTopBar(
                bookTitle: widget.title,
                chapterTitle: 'Imported PDF',
                background: AppColors.background,
                ink: AppColors.primaryGreen,
                secondary: AppColors.secondaryText,
                bookmarked: _bookmarked,
                onBack: () => Navigator.of(context).maybePop(),
                onToc: () => showComingSoon(context, 'Contents'),
                onSearch: () => showComingSoon(context, 'Search'),
                onBookmark: () => setState(() => _bookmarked = !_bookmarked),
                onAa: () => showComingSoon(context, 'Reading settings'),
                onMore: () => showComingSoon(context, 'More options'),
              ),
            Expanded(child: _buildBody()),
            if (_controlsVisible) _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_failed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Couldn't open this book",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The file may be damaged or unreadable.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 13,
                  color: AppColors.secondaryText.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _controlsVisible = !_controlsVisible),
      child: Stack(
        children: [
          Positioned.fill(
            child: PDFView(
              filePath: widget.filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              nightMode: false,
              defaultPage: _page,
              onViewCreated: (controller) => _controller = controller,
              onRender: (pages) {
                if (!mounted) return;
                setState(() {
                  _pagesTotal = pages ?? 0;
                  _ready = true;
                });
                _syncPosition();
              },
              onPageChanged: (page, total) {
                if (!mounted || page == null) return;
                setState(() {
                  _page = page;
                  if (total != null && total > 0) _pagesTotal = total;
                });
                _syncPosition();
              },
              onError: (_) {
                if (!mounted) return;
                setState(() => _failed = true);
              },
              onPageError: (_, _) {
                if (!mounted) return;
                setState(() => _failed = true);
              },
            ),
          ),
          if (!_ready && !_failed)
            const Positioned.fill(
              child: ColoredBox(
                color: AppColors.background,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.mutedGold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Opening your book...',
                        style: TextStyle(
                          fontFamily: AppFonts.serif,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final percent = _progress >= 1 ? 100 : (_progress * 100).round();
    return Material(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _pagesTotal > 0
                        ? 'Page ${_page + 1} of $_pagesTotal · $percent%'
                        : 'PDF',
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 12,
                  ),
                  activeTrackColor: AppColors.mutedGold,
                  inactiveTrackColor: AppColors.indicatorInactive.withValues(
                    alpha: 0.6,
                  ),
                  thumbColor: AppColors.mutedGold,
                ),
                child: Slider(
                  value: _progress.clamp(0.0, 1.0),
                  onChanged: _pagesTotal > 0 ? _scrub : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _progress {
    if (_pagesTotal <= 0) return 0;
    return ((_page + 1) / _pagesTotal).clamp(0.0, 1.0);
  }

  Future<void> _scrub(double value) async {
    final controller = _controller;
    if (controller == null || _pagesTotal <= 0) return;
    final target = (value * (_pagesTotal - 1)).round().clamp(0, _pagesTotal - 1);
    await controller.setPage(target);
    if (!mounted) return;
    setState(() => _page = target);
    _syncPosition();
  }

  /// Reports the position to the [ReadingStore] — same contract as the text
  /// reader: cleared as finished once the last page is reached.
  void _syncPosition() {
    if (_pagesTotal <= 0 || _finished) return;
    final progress = _progress;
    if (progress >= 1.0) {
      _finished = true;
      _store.markFinished();
    } else {
      _store.setPosition(
        bookTitle: widget.title,
        bookAuthor: widget.author,
        chapterIndex: 0,
        pageIndex: _page,
        progress: progress,
      );
    }
  }
}
