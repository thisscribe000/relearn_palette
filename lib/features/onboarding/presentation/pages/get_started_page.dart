import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/reading_journey_illustration.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key, this.onGetStarted, this.onSignIn});

  /// Called when the primary CTA is tapped. Defaults to a no-op until
  /// a home route exists; override to navigate.
  final VoidCallback? onGetStarted;

  /// Called when the "I already have an account" action is tapped.
  /// Defaults to a no-op until an auth route exists; override to navigate.
  final VoidCallback? onSignIn;

  static const String _headline = 'Your library, reimagined.';
  static const String _body =
      'Read the full book. Learn its ideas in bite-sized ways. '
      'Come back to what matters until it sticks.';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = math
                        .min(
                          constraints.maxWidth * 0.78,
                          constraints.maxHeight * 0.92,
                        )
                        .clamp(140.0, 340.0);
                    return Center(
                      child: ReadingJourneyIllustration(size: size),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _headline,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  _body,
                  style: textTheme.bodyMedium?.copyWith(
                    fontFamily: AppFonts.sans,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: FilledButton(
                  onPressed: onGetStarted ?? () {},
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: onSignIn ?? () {},
                child: const Text('I already have an account'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
