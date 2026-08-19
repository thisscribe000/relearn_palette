import 'package:flutter/material.dart';

import '../../../../core/reading/reading_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../book/data/mock_book_details.dart';
import '../../../reader/presentation/pages/reader_page.dart';
import '../../data/mock_bites.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/continue_reading_bar.dart';
import '../widgets/feed_header.dart';
import '../widgets/learning_bite.dart';
import 'discover_page.dart';
import 'library_page.dart';
import 'me_page.dart';

/// Screen 04 — Home / Learning Feed.
///
/// A persistent bottom navigation hosts the vertical Learning Bite feed on
/// the Home tab, plus placeholders for Discover, Library, and Me.
class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          _LearningFeedView(),
          DiscoverPage(),
          LibraryPage(),
          MePage(),
        ],
      ),
      floatingActionButton: _tab == 0 ? _buildContinueFab() : null,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_tab == 2) const ContinueReadingBar(),
          BottomNavigation(
            currentIndex: _tab,
            onSelect: (i) => setState(() => _tab = i),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueFab() {
    return ListenableBuilder(
      listenable: ReadingStore.instance,
      builder: (context, _) {
        final session = ReadingStore.instance.session;
        if (session == null) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () => _openContinueReading(context, session),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.paper,
          elevation: 0,
          highlightElevation: 2,
          icon: const Icon(Icons.menu_book_outlined, size: 18),
          label: const Text(
            'Continue Reading',
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }

  void _openContinueReading(BuildContext context, ReadingSession session) {
    final book = libraryBookForTitle(session.bookTitle);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReaderPage(
          book: readerBookFor(book),
          initialChapter: session.chapterIndex,
          initialPage: session.pageIndex,
        ),
      ),
    );
  }
}

class _LearningFeedView extends StatefulWidget {
  const _LearningFeedView();

  @override
  State<_LearningFeedView> createState() => _LearningFeedViewState();
}

class _LearningFeedViewState extends State<_LearningFeedView> {
  final PageController _controller = PageController();
  final Set<int> _discussionOpen = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDiscussionChanged(int index, bool open) {
    setState(() {
      if (open) {
        _discussionOpen.add(index);
      } else {
        _discussionOpen.remove(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const FeedHeader(),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              physics: _discussionOpen.isEmpty
                  ? null
                  : const NeverScrollableScrollPhysics(),
              itemCount: mockLearningBites.length,
              itemBuilder: (context, index) => LearningBite(
                bite: mockLearningBites[index],
                onDiscussionChanged: (open) =>
                    _onDiscussionChanged(index, open),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
