import 'package:flutter/material.dart';

import '../../data/mock_bites.dart';
import '../widgets/bottom_navigation.dart';
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
      bottomNavigationBar: BottomNavigation(
        currentIndex: _tab,
        onSelect: (i) => setState(() => _tab = i),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              itemCount: mockLearningBites.length,
              itemBuilder: (context, index) =>
                  LearningBite(bite: mockLearningBites[index]),
            ),
          ),
        ],
      ),
    );
  }
}