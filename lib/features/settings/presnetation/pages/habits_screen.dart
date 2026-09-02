import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = const Color(0xFF94A3B8);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color iconBackgroundColor = isDark
        ? const Color(0xFF312E81)
        : const Color(0xFFEEF2FF);

    final Color iconColor = isDark
        ? const Color(0xFF818CF8)
        : const Color(0xFF6366F1);

    final double horizontalPadding = isSmallWidth ? 16 : 20;
    final double bodyBottomPadding = isShortScreen ? 20 : 30;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(isSmallWidth ? 7 : 6),
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: IconButton(
            onPressed: () => context.go(Routes.settings),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: isSmallWidth ? 16 : 17,
              color: primaryTextColor,
            ),
          ),
        ),
        title: Text(
          l10n.habits,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 20 : 22,
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          isShortScreen ? 8 : 12,
          horizontalPadding,
          bodyBottomPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              icon: Icons.track_changes_outlined,
              title: l10n.habits,
              description: l10n.habitsIntro,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              iconColor: iconColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              isSmallWidth: isSmallWidth,
            ),
            SizedBox(height: isShortScreen ? 16 : 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isSmallWidth ? 16 : 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 0.7),
              ),
              child: Column(
                children: [
                  Container(
                    width: isSmallWidth ? 58 : 64,
                    height: isSmallWidth ? 58 : 64,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_graph_rounded,
                      size: isSmallWidth ? 27 : 30,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(height: isShortScreen ? 12 : 16),
                  Text(
                    l10n.habitsComingSoon,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 16 : 17,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.habitsComingSoonDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 11 : 12,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color cardColor,
    required Color borderColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required bool isSmallWidth,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallWidth ? 14 : 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isSmallWidth ? 40 : 44,
            height: isSmallWidth ? 40 : 44,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: isSmallWidth ? 20 : 22),
          ),
          SizedBox(width: isSmallWidth ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 13 : 14,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 10 : 11,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
