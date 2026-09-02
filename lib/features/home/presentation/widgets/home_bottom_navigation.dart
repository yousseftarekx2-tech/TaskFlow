import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallWidth = constraints.maxWidth < 360;
        final bool isLargeWidth = constraints.maxWidth >= 430;

        final double navigationHeight = isSmallWidth ? 84 : 92;
        final double horizontalPadding = isSmallWidth
            ? 10
            : isLargeWidth
            ? 24
            : 18;

        final double centerSpace = isSmallWidth
            ? 58
            : isLargeWidth
            ? 74
            : 70;

        final double addButtonOuterSize = isSmallWidth ? 64 : 70;
        final double addButtonSize = isSmallWidth ? 50 : 54;
        final double addButtonTop = isSmallWidth ? -28 : -32;
        final double addIconSize = isSmallWidth ? 28 : 30;

        return SizedBox(
          height: navigationHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: navigationHeight,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.35),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _NavigationItem(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home_rounded,
                        label: 'Home',
                        index: 0,
                        currentIndex: currentIndex,
                        onTap: onTap,
                        isSmallWidth: isSmallWidth,
                      ),
                    ),
                    Expanded(
                      child: _NavigationItem(
                        icon: Icons.calendar_today_outlined,
                        activeIcon: Icons.calendar_month_rounded,
                        label: 'Calendar',
                        index: 1,
                        currentIndex: currentIndex,
                        onTap: onTap,
                        isSmallWidth: isSmallWidth,
                      ),
                    ),
                    SizedBox(width: centerSpace),
                    Expanded(
                      child: _NavigationItem(
                        icon: Icons.bar_chart_outlined,
                        activeIcon: Icons.bar_chart_rounded,
                        label: 'Stats',
                        index: 2,
                        currentIndex: currentIndex,
                        onTap: onTap,
                        isSmallWidth: isSmallWidth,
                      ),
                    ),
                    Expanded(
                      child: _NavigationItem(
                        icon: Icons.center_focus_strong_outlined,
                        activeIcon: Icons.dashboard_outlined,
                        label: 'Focus',
                        index: 3,
                        currentIndex: currentIndex,
                        onTap: onTap,
                        isSmallWidth: isSmallWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: addButtonTop,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onAddTap,
                    child: SizedBox(
                      width: addButtonOuterSize,
                      height: addButtonOuterSize,
                      child: Center(
                        child: Container(
                          width: addButtonSize,
                          height: addButtonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.needthis,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.needthis.withValues(
                                  alpha: 0.30,
                                ),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: addIconSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.isSmallWidth,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isSmallWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final bool isSelected = currentIndex == index;

    final Color inactiveColor = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(top: isSmallWidth ? 11 : 13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: isSmallWidth ? 23 : 25,
              color: isSelected ? AppColors.needthis : inactiveColor,
            ),
            SizedBox(height: isSmallWidth ? 3 : 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 10 : 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.needthis : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
