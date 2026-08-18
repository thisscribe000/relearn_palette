import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/book_learning_illustration.dart';

class ConceptPage extends StatelessWidget {
  const ConceptPage({super.key});

  static const String _headline = 'Turn any book into a reel.';
  static const String _body =
      'Read the full book, then turn its ideas into short, narrated '
      'learning bites that are easier to understand, revisit, and remember.';

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
                        .min(constraints.maxWidth * 0.78, constraints.maxHeight * 0.92)
                        .clamp(140.0, 340.0);
                    return Center(
                      child: BookLearningIllustration(size: size),
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
            ],
          ),
        ),
      ),
    );
  }
}