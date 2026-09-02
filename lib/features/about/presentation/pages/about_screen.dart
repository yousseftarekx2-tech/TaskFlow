import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color titleTextColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF1E293B);

    final Color secondaryTextColor = const Color(0xFF94A3B8);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color iconBackgroundColor = isDark
        ? const Color(0xFF312E81)
        : const Color(0xFFEEF2FF);

    final Color simpleTileTextColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF334155);

    final Color simpleTileIconColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.go(Routes.settings),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: primaryTextColor,
          ),
        ),
        title: Text(
          l10n.about,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallWidth = constraints.maxWidth < 360;

          final double horizontalPadding = isSmallWidth ? 16 : 20;
          final double topSpacing = isSmallWidth ? 8 : 12;
          final double logoSize = isSmallWidth ? 72 : 82;
          final double logoIconSize = isSmallWidth ? 36 : 42;
          final double appNameSize = isSmallWidth ? 22 : 24;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              topSpacing,
              horizontalPadding,
              30,
            ),
            child: Column(
              children: [
                SizedBox(height: topSpacing),
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(isSmallWidth ? 19 : 22),
                    border: Border.all(color: borderColor),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: logoIconSize,
                    color: AppColors.needthis,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.taskFlow,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: appNameSize,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.stayOrganizedStayFocused,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 11 : 12,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                SizedBox(height: isSmallWidth ? 22 : 28),
                _buildInfoCard(
                  icon: Icons.info_outline_rounded,
                  title: l10n.aboutTaskFlow,
                  description: l10n.aboutTaskFlowDescription,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  iconBackgroundColor: iconBackgroundColor,
                  titleColor: titleTextColor,
                  descriptionColor: secondaryTextColor,
                  compact: isSmallWidth,
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.track_changes_outlined,
                  title: l10n.ourGoal,
                  description: l10n.ourGoalDescription,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  iconBackgroundColor: iconBackgroundColor,
                  titleColor: titleTextColor,
                  descriptionColor: secondaryTextColor,
                  compact: isSmallWidth,
                ),
                SizedBox(height: isSmallWidth ? 20 : 24),
                Text(
                  l10n.application,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                _buildSimpleTile(
                  icon: Icons.apps_outlined,
                  title: l10n.versionLabel,
                  value: '1.0.0',
                  cardColor: cardColor,
                  borderColor: borderColor,
                  iconColor: simpleTileIconColor,
                  titleColor: simpleTileTextColor,
                  valueColor: secondaryTextColor,
                  compact: isSmallWidth,
                ),
                _buildSimpleTile(
                  icon: Icons.code_rounded,
                  title: l10n.builtWith,
                  value: 'Flutter',
                  cardColor: cardColor,
                  borderColor: borderColor,
                  iconColor: simpleTileIconColor,
                  titleColor: simpleTileTextColor,
                  valueColor: secondaryTextColor,
                  compact: isSmallWidth,
                ),
                SizedBox(height: isSmallWidth ? 24 : 30),
                Text(
                  l10n.taskFlow,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.madeForBetterProductivity,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          );
        },
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
    required Color titleColor,
    required Color descriptionColor,
    required bool compact,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: compact ? 38 : 42,
            height: compact ? 38 : 42,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(compact ? 10 : 11),
            ),
            child: Icon(
              icon,
              size: compact ? 19 : 21,
              color: AppColors.needthis,
            ),
          ),
          SizedBox(width: compact ? 11 : 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: compact ? 10.5 : 11,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: descriptionColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTile({
    required IconData icon,
    required String title,
    required String value,
    required Color cardColor,
    required Color borderColor,
    required Color iconColor,
    required Color titleColor,
    required Color valueColor,
    required bool compact,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 11 : 12,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Row(
        children: [
          Icon(icon, size: compact ? 19 : 20, color: iconColor),
          SizedBox(width: compact ? 10 : 13),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
