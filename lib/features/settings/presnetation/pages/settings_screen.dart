import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/l10n/app_localizations.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context)!;
        final bool isDark = state.darkModeEnabled;

        // ============================================================
        // COLORS
        // ============================================================

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

        return Scaffold(
          backgroundColor: backgroundColor,

          // ============================================================
          // APP BAR
          // ============================================================
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,

            leading: Container(
              margin: const EdgeInsets.all(6),

              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 0.8),
              ),

              child: IconButton(
                onPressed: () => context.go(Routes.home),
                padding: EdgeInsets.zero,

                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 17,
                  color: primaryTextColor,
                ),
              ),
            ),

            title: Text(
              localizations.settings,

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),

            centerTitle: true,
          ),

          // ============================================================
          // BODY
          // ============================================================
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ======================================================
                // PREFERENCES
                // ======================================================
                _buildSectionTitle(localizations.preferences, isDark),

                _buildSettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: localizations.notifications,
                  subtitle: localizations.manageTaskReminders,

                  onTap: () {
                    context.go(Routes.notificationSettingsScreen);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                _buildSwitchTile(
                  icon: Icons.volume_up_outlined,
                  title: localizations.sound,
                  subtitle: localizations.manageSoundsAlerts,
                  value: state.soundEnabled,

                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleSound(value);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: localizations.darkMode,
                  subtitle: localizations.useDarkAppearance,
                  value: state.darkModeEnabled,

                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleDarkMode(value);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                _buildSettingsTile(
                  icon: Icons.language_outlined,
                  title: localizations.language,

                  // ====================================================
                  // LANGUAGE DISPLAY
                  // ====================================================
                  //
                  // لا نعتمد على state.selectedLanguage هنا كقيمة
                  // مترجمة بشكل مباشر.
                  //
                  // نحدد اللغة من القيمة الحالية ثم نعرض الاسم
                  // باستخدام L10n.
                  // ====================================================
                  subtitle: _getLanguageDisplayName(
                    state.selectedLanguage,
                    localizations,
                  ),

                  onTap: () {
                    _showLanguageDialog(
                      context,
                      state.selectedLanguage,
                      isDark,
                    );
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                const SizedBox(height: 24),

                // ======================================================
                // PRODUCTIVITY
                // ======================================================
                _buildSectionTitle(localizations.productivity, isDark),

                _buildSettingsTile(
                  icon: Icons.track_changes_outlined,
                  title: localizations.habits,
                  subtitle: localizations.manageProductivityHabits,
                  onTap: () {
                    context.go(Routes.habits);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                const SizedBox(height: 24),

                // ======================================================
                // INFORMATION
                // ======================================================
                _buildSectionTitle(localizations.information, isDark),

                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: localizations.aboutTaskFlow,
                  subtitle: localizations.learnMoreAboutTaskFlow,

                  onTap: () {
                    context.go(Routes.about);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: localizations.privacy,
                  subtitle: localizations.privacyAndData,
                  onTap: () {
                    context.go(Routes.privacy);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: localizations.termsOfService,
                  subtitle: localizations.reviewOurTerms,
                  onTap: () {
                    context.go(Routes.termsOfService);
                  },

                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                ),

                const SizedBox(height: 30),

                // ======================================================
                // FOOTER
                // ======================================================
                Center(
                  child: Text(
                    localizations.taskFlow,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: secondaryTextColor,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Center(
                  child: Text(
                    localizations.version,

                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // GET LANGUAGE DISPLAY NAME
  // ============================================================

  String _getLanguageDisplayName(
    String selectedLanguage,
    AppLocalizations localizations,
  ) {
    final String normalized = selectedLanguage.trim().toLowerCase();

    // Arabic
    if (normalized == 'ar' ||
        normalized == 'arabic' ||
        normalized == 'العربية' ||
        normalized == 'عربي') {
      return localizations.arabic;
    }

    // English
    if (normalized == 'en' ||
        normalized == 'english' ||
        normalized == 'الإنجليزية' ||
        normalized == 'انجليزي') {
      return localizations.english;
    }

    // Fallback
    return selectedLanguage;
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),

      child: Text(
        title.toUpperCase(),

        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  // ============================================================
  // SWITCH TILE
  // ============================================================

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,

    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color iconBackgroundColor,
    required Color iconColor,
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
          _buildIconContainer(icon, iconBackgroundColor, iconColor),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,

            activeColor: const Color(0xFF6366F1),

            activeTrackColor: isDark ? const Color(0xFF4338CA) : null,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS TILE
  // ============================================================

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,

    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color iconBackgroundColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: borderColor, width: 0.7),
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

            child: Row(
              children: [
                _buildIconContainer(icon, iconBackgroundColor, iconColor),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,

                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,

                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 19,
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ICON CONTAINER
  // ============================================================

  Widget _buildIconContainer(
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Container(
      width: 40,
      height: 40,

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),

      child: Icon(icon, size: 20, color: iconColor),
    );
  }

  // ============================================================
  // LANGUAGE DIALOG
  // ============================================================

  void _showLanguageDialog(
    BuildContext context,
    String selectedLanguage,
    bool isDark,
  ) {
    final localizations = AppLocalizations.of(context)!;

    // ============================================================
    // NORMALIZE CURRENT LANGUAGE
    // ============================================================

    final String currentLanguage = _normalizeLanguage(selectedLanguage);

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,

          title: Text(
            localizations.language,

            style: TextStyle(
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),

              fontWeight: FontWeight.w700,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ======================================================
              // ENGLISH
              // ======================================================
              _languageOption(
                context: context,
                languageCode: 'en',
                languageName: localizations.english,
                selectedLanguage: currentLanguage,
                isDark: isDark,
              ),

              // ======================================================
              // ARABIC
              // ======================================================
              _languageOption(
                context: context,
                languageCode: 'ar',
                languageName: localizations.arabic,
                selectedLanguage: currentLanguage,
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // NORMALIZE LANGUAGE
  // ============================================================

  String _normalizeLanguage(String language) {
    final String normalized = language.trim().toLowerCase();

    if (normalized == 'ar' ||
        normalized == 'arabic' ||
        normalized == 'العربية' ||
        normalized == 'عربي') {
      return 'ar';
    }

    if (normalized == 'en' ||
        normalized == 'english' ||
        normalized == 'الإنجليزية' ||
        normalized == 'انجليزي') {
      return 'en';
    }

    return normalized;
  }

  // ============================================================
  // LANGUAGE OPTION
  // ============================================================

  Widget _languageOption({
    required BuildContext context,
    required String languageCode,
    required String languageName,
    required String selectedLanguage,
    required bool isDark,
  }) {
    final bool isSelected = selectedLanguage == languageCode;

    return ListTile(
      title: Text(
        languageName,

        style: TextStyle(
          color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
        ),
      ),

      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: Color(0xFF6366F1))
          : null,

      // ==========================================================
      // CURRENT LANGUAGE
      // ==========================================================
      //
      // لو اللغة الحالية هي نفس اللغة المختارة:
      // لا نعمل أي تغيير.
      //
      // ==========================================================
      onTap: isSelected
          ? null
          : () {
              context.read<SettingsCubit>().changeLanguage(languageCode);

              Navigator.pop(context);
            },
    );
  }
}
