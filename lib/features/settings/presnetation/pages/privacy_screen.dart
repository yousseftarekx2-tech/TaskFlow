import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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

    const Color secondaryTextColor = Color(0xFF94A3B8);

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
          l10n.privacy,
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
          isShortScreen ? 20 : 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              icon: Icons.security_outlined,
              title: l10n.privacyYourData,
              description: l10n.privacyYourDataDescription,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              iconColor: iconColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              isSmallWidth: isSmallWidth,
            ),
            const SizedBox(height: 12),
            _buildSection(
              icon: Icons.storage_outlined,
              title: l10n.privacyDataStorage,
              description: l10n.privacyDataStorageDescription,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              iconColor: iconColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              isSmallWidth: isSmallWidth,
            ),
            const SizedBox(height: 12),
            _buildSection(
              icon: Icons.notifications_none_rounded,
              title: l10n.privacyNotifications,
              description: l10n.privacyNotificationsDescription,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              iconColor: iconColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              isSmallWidth: isSmallWidth,
            ),
            const SizedBox(height: 12),
            _buildSection(
              icon: Icons.manage_accounts_outlined,
              title: l10n.privacyYourControl,
              description: l10n.privacyYourControlDescription,
              cardColor: cardColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              iconColor: iconColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              isSmallWidth: isSmallWidth,
            ),
            SizedBox(height: isShortScreen ? 20 : 24),
            Text(
              l10n.lastUpdated,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 9 : 10,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallWidth ? 40 : 42,
                height: isSmallWidth ? 40 : 42,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: isSmallWidth ? 20 : 21,
                  color: iconColor,
                ),
              ),
              SizedBox(width: isSmallWidth ? 10 : 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 13 : 14,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: isSmallWidth ? 10 : 11,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
