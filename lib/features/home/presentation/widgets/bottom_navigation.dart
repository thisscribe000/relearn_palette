import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Persistent app navigation: Home → Learning Feed, Discover, Library, Me.
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const _items = <_NavItem>[
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Discover',
    ),
    _NavItem(
      icon: Icons.auto_stories_outlined,
      activeIcon: Icons.auto_stories,
      label: 'Library',
    ),
    _NavItem(
      icon: Icons.person_outlined,
      activeIcon: Icons.person_rounded,
      label: 'Me',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border(
          top: BorderSide(
            color: AppColors.indicatorInactive.withValues(alpha: 0.55),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 3),
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          i == currentIndex
                              ? _items[i].activeIcon
                              : _items[i].icon,
                          size: 22,
                          color: i == currentIndex
                              ? AppColors.primaryGreen
                              : AppColors.secondaryText,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].label,
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 10.5,
                            fontWeight: i == currentIndex
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: i == currentIndex
                                ? AppColors.primaryGreen
                                : AppColors.secondaryText,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == currentIndex
                                ? AppColors.mutedGold
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
