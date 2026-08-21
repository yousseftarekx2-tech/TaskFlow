import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final l10n = AppLocalizations.of(context)!;

    // ============================================================
    // THEME COLORS
    // ============================================================

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

    final Color secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF94A3B8);

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

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => context.go(Routes.home),
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

      // ============================================================
      // BODY
      // ============================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

        child: Column(
          children: [
            const SizedBox(height: 12),

            // ======================================================
            // APP LOGO
            // ======================================================
            Container(
              width: 82,
              height: 82,

              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
              ),

              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 42,
                color: AppColors.needthis,
              ),
            ),

            const SizedBox(height: 16),

            // ======================================================
            // APP NAME
            // ======================================================
            Text(
              l10n.taskFlow,

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              l10n.stayOrganizedStayFocused,

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),

            const SizedBox(height: 28),

            // ======================================================
            // ABOUT TASKFLOW
            // ======================================================
            _buildInfoCard(
              icon: Icons.info_outline_rounded,
              title: l10n.aboutTaskFlow,
              description: l10n.aboutTaskFlowDescription,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              titleColor: titleTextColor,
              descriptionColor: secondaryTextColor,
            ),

            const SizedBox(height: 12),

            // ======================================================
            // OUR GOAL
            // ======================================================
            _buildInfoCard(
              icon: Icons.track_changes_outlined,
              title: l10n.ourGoal,
              description: l10n.ourGoalDescription,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              titleColor: titleTextColor,
              descriptionColor: secondaryTextColor,
            ),

            const SizedBox(height: 24),

            // ======================================================
            // APPLICATION LABEL
            // ======================================================
            Text(
              l10n.application,

              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: secondaryTextColor,
              ),
            ),

            const SizedBox(height: 10),

            // ======================================================
            // VERSION
            // ======================================================
            _buildSimpleTile(
              icon: Icons.apps_outlined,
              title: l10n.versionLabel,
              value: '1.0.0',
              cardColor: cardColor,
              borderColor: borderColor,
              iconColor: simpleTileIconColor,
              titleColor: simpleTileTextColor,
              valueColor: secondaryTextColor,
            ),

            // ======================================================
            // BUILT WITH
            // ======================================================
            _buildSimpleTile(
              icon: Icons.code_rounded,
              title: l10n.builtWith,
              value: 'Flutter',
              cardColor: cardColor,
              borderColor: borderColor,
              iconColor: simpleTileIconColor,
              titleColor: simpleTileTextColor,
              valueColor: secondaryTextColor,
            ),

            const SizedBox(height: 30),

            // ======================================================
            // FOOTER
            // ======================================================
            Text(
              l10n.taskFlow,

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: secondaryTextColor,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              l10n.madeForBetterProductivity,

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
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color cardColor,
    required Color borderColor,
    required Color iconBackgroundColor,
    required Color titleColor,
    required Color descriptionColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.7),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // ICON
          // ======================================================
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(icon, size: 21, color: AppColors.needthis),
          ),

          const SizedBox(width: 13),

          // ======================================================
          // TEXT
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,

                  style: TextStyle(
                    fontSize: 11,
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

  // ============================================================
  // SIMPLE TILE
  // ============================================================

  Widget _buildSimpleTile({
    required IconData icon,
    required String title,
    required String value,
    required Color cardColor,
    required Color borderColor,
    required Color iconColor,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.7),
      ),

      child: Row(
        children: [
          // ======================================================
          // ICON
          // ======================================================
          Icon(icon, size: 20, color: iconColor),

          const SizedBox(width: 13),

          // ======================================================
          // TITLE
          // ======================================================
          Expanded(
            child: Text(
              title,

              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
          ),

          // ======================================================
          // VALUE
          // ======================================================
          Text(
            value,

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
