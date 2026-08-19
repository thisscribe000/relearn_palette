import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_feed_page.dart';
import '../widgets/onboarding_indicators.dart';
import 'concept_page.dart';
import 'get_started_page.dart';
import 'splash_page.dart';

/// The single onboarding flow: three horizontally swipeable pages
/// (Splash → Concept → GetStarted) inside one [PageView].
///
/// The bottom indicator strip reflects the current page via
/// [PageController.onPageChanged] and animates as the user swipes.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.onGetStarted, this.onSignIn});

  /// Called when the primary CTA on the final page is tapped.
  /// Defaults to navigating to [HomeFeedPage].
  final VoidCallback? onGetStarted;

  /// Called when the "I already have an account" action is tapped.
  final VoidCallback? onSignIn;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _pageCount = 3;

  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openHomeFeed() {
    if (widget.onGetStarted != null) {
      widget.onGetStarted!();
      return;
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const HomeFeedPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pageCount,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) => switch (index) {
                  0 => const SplashPage(),
                  1 => const ConceptPage(),
                  _ => GetStartedPage(
                    onGetStarted: _openHomeFeed,
                    onSignIn: widget.onSignIn,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32, top: 24),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: OnboardingIndicators(activeIndex: _page),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
