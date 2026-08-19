import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../../domain/reader_book.dart';
import '../reader_settings.dart';
import '../widgets/reader_bottom_bar.dart';
import '../widgets/reader_learn_view.dart';
import '../widgets/reader_paginator.dart';
import '../widgets/reader_settings_panel.dart';
import '../widgets/reader_toc_panel.dart';
import '../widgets/reader_top_bar.dart';

/// Full Book Reader.
///
/// A conventional paged ebook reader: tap to toggle the chrome, swipe to turn
/// pages, horizontal pages of whole paragraphs. The Aa settings, table of
/// contents, bookmark, search and more live in the chrome. Re-Learn's touch
/// is subtle — "Learn this" appears on text selection, and a quiet Read /
/// Learn switch swaps between the full text and the book's bites.
class ReaderPage extends StatefulWidget {
  const ReaderPage({
    super.key,
    required this.book,
    this.store,
    this.initialChapter = 0,
    this.initialPage = 0,
  });

  final ReaderBook book;

  /// Reading-progress store; defaults to the app-wide [ReadingStore.instance].
  final ReadingStore? store;

  /// Resume position passed when reopening at a saved spot.
  final int initialChapter;
  final int initialPage;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

enum _ReaderMode { read, learn }

class _ReaderPageState extends State<ReaderPage> {
  ReaderSettings _settings = const ReaderSettings();
  _ReaderMode _mode = _ReaderMode.read;
  late int _chapter;
  late int _page;
  int _chapterPageCount = 1;
  bool _controlsVisible = true;
  bool _bookmarked = false;
  String? _selectedText;

  List<int> _chapterOffsets = const [];
  int _totalPages = 1;

  ReadingStore get _store => widget.store ?? ReadingStore.instance;

  @override
  void initState() {
    super.initState();
    final session = _store.session;
    final resume = session != null && session.bookTitle == widget.book.title
        ? session
        : null;
    _chapter = (resume?.chapterIndex ?? widget.initialChapter).clamp(
      0,
      widget.book.chapters.length - 1,
    );
    _page = math.max(0, resume?.pageIndex ?? widget.initialPage);
  }

  @override
  void dispose() {
    _syncPosition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = paletteFor(_settings.appearance);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_controlsVisible)
              ReaderTopBar(
                bookTitle: widget.book.title,
                chapterTitle: _mode == _ReaderMode.learn
                    ? 'Learning bites'
                    : widget.book.chapters[_chapter].title,
                background: palette.surface,
                ink: palette.ink,
                secondary: palette.secondary,
                bookmarked: _bookmarked,
                onBack: () => Navigator.of(context).maybePop(),
                onToc: _openToc,
                onSearch: () => showComingSoon(context, 'Search'),
                onBookmark: _toggleBookmark,
                onAa: _openSettings,
                onMore: _openMoreMenu,
              ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _mode == _ReaderMode.learn
                        ? ReaderLearnView(
                            book: widget.book,
                            palette: palette,
                            onToggleChrome: _toggleControls,
                            onListen: () => showComingSoon(context, 'Listen'),
                          )
                        : _buildReadBody(palette),
                  ),
                  if (_settings.brightness > 0)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ColoredBox(
                          color: Colors.black.withValues(
                            alpha: _settings.brightness,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_controlsVisible)
              ReaderBottomBar(
                chapterLabel: _mode == _ReaderMode.learn
                    ? 'Learning bites'
                    : 'Ch. ${_chapter + 1} · '
                          '${widget.book.chapters[_chapter].title}',
                pageLabel: _mode == _ReaderMode.learn
                    ? ''
                    : '${_page + 1}/$_chapterPageCount · '
                          '${(_currentProgress * 100).round()}%',
                progress: _currentProgress,
                learnMode: _mode == _ReaderMode.learn,
                biteCount: widget.book.bites.length,
                background: palette.surface,
                ink: palette.ink,
                secondary: palette.secondary,
                onProgressChanged: _scrub,
                onModeChanged: (learn) {
                  setState(() {
                    _mode = learn ? _ReaderMode.learn : _ReaderMode.read;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  double get _currentProgress {
    if (_totalPages <= 1) return 0;
    final before = _chapter == 0 ? 0 : _chapterOffsets[_chapter - 1];
    return ((before + _page + 1) / _totalPages).clamp(0.0, 1.0);
  }

  /// Reports the current position to the [ReadingStore]. Called on every
  /// page/chapter change and when the reader is disposed. Once the reader
  /// reaches the last page of the last chapter, the session is cleared as
  /// "finished".
  void _syncPosition() {
    if (_chapterOffsets.isEmpty) return;
    final page = _page.clamp(0, math.max(0, _chapterPageCount - 1)).toInt();
    final progress = _currentProgress;
    if (progress >= 1.0) {
      _store.markFinished();
    } else {
      _store.setPosition(
        bookTitle: widget.book.title,
        bookAuthor: widget.book.author,
        chapterIndex: _chapter,
        pageIndex: page,
        progress: progress,
      );
    }
  }

  TextStyle _paragraphStyle(ReaderPalette palette) => TextStyle(
    fontFamily: _settings.serif ? AppFonts.serif : AppFonts.sans,
    fontSize: _settings.fontSize,
    height: _settings.lineSpacing,
    letterSpacing: _settings.serif ? 0 : 0.05,
    color: palette.ink,
  );

  Widget _buildReadBody(ReaderPalette palette) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 24.0;
        const topPadding = 4.0;
        const bottomPadding = 8.0;
        const maxTextWidth = 640.0;

        final width =
            math.min(constraints.maxWidth, maxTextWidth) -
            horizontalPadding * 2;
        final height = constraints.maxHeight - topPadding - bottomPadding - 6;
        final style = _paragraphStyle(palette);
        final gap = _settings.fontSize * 0.7;

        final chapters = widget.book.chapters;
        final pages = paginateParagraphs(
          paragraphs: chapters[_chapter].paragraphs,
          width: width,
          height: height,
          style: style,
          paragraphGap: gap,
        );

        var acc = 0;
        final offsets = <int>[];
        for (var c = 0; c < chapters.length; c++) {
          acc += c == _chapter
              ? pages.length
              : paginateParagraphs(
                  paragraphs: chapters[c].paragraphs,
                  width: width,
                  height: height,
                  style: style,
                  paragraphGap: gap,
                ).length;
          offsets.add(acc);
        }
        final totalPages = math.max(1, acc);
        final chapterPageCount = pages.length;
        // Pagination happens during layout, after the chrome is built, so the
        // bottom bar shows stale 0% / "x/1" on the very first frame. Refresh
        // once the real totals are known.
        if (_totalPages != totalPages ||
            _chapterPageCount != chapterPageCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() {});
          });
        }
        _chapterOffsets = offsets;
        _totalPages = totalPages;
        _chapterPageCount = chapterPageCount;

        final page = _page.clamp(0, math.max(0, pages.length - 1)).toInt();
        if (_page != page) _page = page;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          child: SelectionArea(
            onSelectionChanged: (content) => _selectedText = content?.plainText,
            contextMenuBuilder: _buildContextMenu,
            child: _PagedReader(
              key: ValueKey<String>(
                '$_chapter|${_settings.fontSize}|${_settings.serif}|'
                '${_settings.lineSpacing}',
              ),
              pages: pages,
              style: style,
              gap: gap,
              horizontalPadding: horizontalPadding,
              topPadding: topPadding,
              initialPage: page,
              onPageChanged: (i) {
                setState(() => _page = i);
                _syncPosition();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildContextMenu(
    BuildContext context,
    SelectableRegionState selectableRegionState,
  ) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: selectableRegionState.contextMenuAnchors,
      buttonItems: [
        ContextMenuButtonItem(
          onPressed: () {
            selectableRegionState.hideToolbar();
            _onLearnThis();
          },
          label: 'Learn this',
        ),
        ...selectableRegionState.contextMenuButtonItems,
      ],
    );
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
  }

  void _toggleBookmark() {
    setState(() => _bookmarked = !_bookmarked);
  }

  void _scrub(double value) {
    if (_totalPages <= 0) return;
    final target = (value * (_totalPages - 1)).round();
    for (var c = 0; c < _chapterOffsets.length; c++) {
      if (target < _chapterOffsets[c]) {
        final page = target - (c == 0 ? 0 : _chapterOffsets[c - 1]);
        setState(() {
          _chapter = c;
          _page = page;
        });
        _syncPosition();
        return;
      }
    }
  }

  void _onLearnThis() {
    final text = (_selectedText ?? '').trim();
    if (text.isEmpty) return;
    final palette = paletteFor(_settings.appearance);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Learn this',
                style: TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Re-Learn can turn this passage into a short, narrated '
                'learning bite.',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 12.5,
                  height: 1.4,
                  color: palette.secondary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.mutedGold.withValues(alpha: 0.8),
                      width: 2,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: AppFonts.serif,
                      fontSize: 15,
                      height: 1.5,
                      color: palette.ink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  showComingSoon(context, 'Learning bites');
                },
                child: const Text('Create a learning bite'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSettings() {
    final palette = paletteFor(_settings.appearance);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => ReaderSettingsPanel(
        initial: _settings,
        onChanged: (next) => setState(() => _settings = next),
      ),
    );
  }

  void _openToc() {
    final palette = paletteFor(_settings.appearance);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => ReaderTocPanel(
        book: widget.book,
        currentChapter: _chapter,
        overallLabel:
            '${_chapter + 1}/${widget.book.chapters.length} · '
            '${(_currentProgress * 100).round()}%',
        palette: palette,
        onSelectChapter: (index) {
          setState(() {
            _chapter = index;
            _page = 0;
          });
          _syncPosition();
        },
        onSelectBites: () {
          setState(() => _mode = _ReaderMode.learn);
        },
      ),
    );
  }

  void _openMoreMenu() {
    final palette = paletteFor(_settings.appearance);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.surface,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              sheetContext,
              icon: Icons.bookmark_border_rounded,
              label: _bookmarked ? 'Remove bookmark' : 'Add bookmark',
              onTap: () {
                Navigator.of(sheetContext).pop();
                _toggleBookmark();
              },
            ),
            _menuItem(
              sheetContext,
              icon: Icons.format_size_rounded,
              label: 'Reading settings',
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openSettings();
              },
            ),
            _menuItem(
              sheetContext,
              icon: Icons.auto_stories_outlined,
              label: 'Learning bites',
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() => _mode = _ReaderMode.learn);
              },
            ),
            _menuItem(
              sheetContext,
              icon: Icons.info_outline_rounded,
              label: 'About this book',
              onTap: () {
                Navigator.of(sheetContext).pop();
                showComingSoon(context, 'About');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext sheetContext, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final palette = paletteFor(_settings.appearance);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.mutedGold),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.sans,
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: palette.ink,
        ),
      ),
    );
  }
}

class _PagedReader extends StatefulWidget {
  const _PagedReader({
    super.key,
    required this.pages,
    required this.style,
    required this.gap,
    required this.horizontalPadding,
    required this.topPadding,
    required this.initialPage,
    required this.onPageChanged,
  });

  final List<List<String>> pages;
  final TextStyle style;
  final double gap;
  final double horizontalPadding;
  final double topPadding;
  final int initialPage;
  final ValueChanged<int> onPageChanged;

  @override
  State<_PagedReader> createState() => _PagedReaderState();
}

class _PagedReaderState extends State<_PagedReader> {
  late final PageController _controller = PageController(
    initialPage: widget.initialPage,
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialPage > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.hasClients) return;
        final target = _controller.initialPage;
        final current = _controller.page?.round();
        if (current != null && current != target) {
          _controller.jumpToPage(target);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant _PagedReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPage != widget.initialPage) {
      _controller.animateToPage(
        widget.initialPage,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      onPageChanged: widget.onPageChanged,
      children: [
        for (var i = 0; i < widget.pages.length; i++)
          _ReaderPage(
            paragraphs: widget.pages[i],
            style: widget.style,
            gap: widget.gap,
            horizontalPadding: widget.horizontalPadding,
            topPadding: widget.topPadding,
          ),
      ],
    );
  }
}

class _ReaderPage extends StatelessWidget {
  const _ReaderPage({
    required this.paragraphs,
    required this.style,
    required this.gap,
    required this.horizontalPadding,
    required this.topPadding,
  });

  final List<String> paragraphs;
  final TextStyle style;
  final double gap;
  final double horizontalPadding;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        8,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < paragraphs.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                Text(paragraphs[i], style: style),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
