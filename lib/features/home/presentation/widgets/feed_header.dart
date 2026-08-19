import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'coming_soon.dart';

/// Top navigation for the Home feed: wordmark, search, and For You/Following.
class FeedHeader extends StatefulWidget {
  const FeedHeader({super.key});

  @override
  State<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 8, 4),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Re-Learn',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: AppFonts.serif,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: AppColors.primaryGreen,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => showComingSoon(context, 'Search'),
                icon: const Icon(Icons.search_rounded),
                color: AppColors.primaryGreen,
                tooltip: 'Search',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabItem('For You', 0),
              const SizedBox(width: 24),
              _tabItem('Following', 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final active = _tab == index;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => setState(() => _tab = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active
                    ? AppColors.primaryGreen
                    : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18,
              height: 2.5,
              decoration: BoxDecoration(
                color: active ? AppColors.mutedGold : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
