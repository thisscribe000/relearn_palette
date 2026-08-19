import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  runApp(const ReLearnApp());
}

class ReLearnApp extends StatelessWidget {
  const ReLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re-Learn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const OnboardingPage(),
    );
  }
}
