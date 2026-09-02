import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final bool isDark = state.darkModeEnabled;
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
                onPressed: () {
                  context.go(Routes.settings);
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: isSmallWidth ? 16 : 17,
                  color: primaryTextColor,
                ),
              ),
            ),
            title: Text(
              l10n.notificationSettings,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 19 : 21,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              isShortScreen ? 6 : 8,
              horizontalPadding,
              isShortScreen ? 20 : 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(l10n.notifications, isDark, isSmallWidth),
                _buildSwitchTile(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notifications,
                  subtitle: l10n.enableOrDisableAllNotifications,
                  value: state.notificationsEnabled,
                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleNotifications(value);
                  },
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                SizedBox(height: isShortScreen ? 20 : 24),
                _buildSectionTitle(l10n.taskReminders, isDark, isSmallWidth),
                _buildSwitchTile(
                  icon: Icons.alarm_outlined,
                  title: l10n.taskReminders,
                  subtitle: l10n.receiveRemindersBeforeTasks,
                  value:
                      state.taskRemindersEnabled && state.notificationsEnabled,
                  onChanged: state.notificationsEnabled
                      ? (value) {
                          context.read<SettingsCubit>().toggleTaskReminders(
                            value,
                          );
                        }
                      : null,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                const SizedBox(height: 8),
                _buildReminderTimeTile(
                  context: context,
                  state: state,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                SizedBox(height: isShortScreen ? 20 : 24),
                _buildSectionTitle(
                  l10n.focusNotifications,
                  isDark,
                  isSmallWidth,
                ),
                _buildSwitchTile(
                  icon: Icons.center_focus_strong,
                  title: l10n.focusNotifications,
                  subtitle: l10n.receiveFocusSessionNotifications,
                  value:
                      state.focusNotificationsEnabled &&
                      state.notificationsEnabled,
                  onChanged: state.notificationsEnabled
                      ? (value) {
                          context
                              .read<SettingsCubit>()
                              .toggleFocusNotifications(value);
                        }
                      : null,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                const SizedBox(height: 8),
                _buildSwitchTile(
                  icon: Icons.check_circle_outline_rounded,
                  title: l10n.focusSessionFinished,
                  subtitle: l10n.notifyWhenFocusSessionEnds,
                  value:
                      state.focusSessionFinished &&
                      state.focusNotificationsEnabled &&
                      state.notificationsEnabled,
                  onChanged:
                      state.notificationsEnabled &&
                          state.focusNotificationsEnabled
                      ? (value) {
                          context
                              .read<SettingsCubit>()
                              .toggleFocusSessionFinished(value);
                        }
                      : null,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                _buildSwitchTile(
                  icon: Icons.free_breakfast_outlined,
                  title: l10n.breakStarted,
                  subtitle: l10n.notifyWhenBreakStarts,
                  value:
                      state.breakStarted &&
                      state.focusNotificationsEnabled &&
                      state.notificationsEnabled,
                  onChanged:
                      state.notificationsEnabled &&
                          state.focusNotificationsEnabled
                      ? (value) {
                          context.read<SettingsCubit>().toggleBreakStarted(
                            value,
                          );
                        }
                      : null,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                _buildSwitchTile(
                  icon: Icons.play_circle_outline_rounded,
                  title: l10n.breakFinished,
                  subtitle: l10n.notifyWhenBreakEnds,
                  value:
                      state.breakFinished &&
                      state.focusNotificationsEnabled &&
                      state.notificationsEnabled,
                  onChanged:
                      state.notificationsEnabled &&
                          state.focusNotificationsEnabled
                      ? (value) {
                          context.read<SettingsCubit>().toggleBreakFinished(
                            value,
                          );
                        }
                      : null,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                  iconBackgroundColor: iconBackgroundColor,
                  iconColor: iconColor,
                  isSmallWidth: isSmallWidth,
                ),
                SizedBox(height: isShortScreen ? 14 : 18),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallWidth ? 12 : 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF172033)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 0.7),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: isSmallWidth ? 18 : 19,
                        color: iconColor,
                      ),
                      SizedBox(width: isSmallWidth ? 8 : 10),
                      Expanded(
                        child: Text(
                          l10n.notificationSettingsInfo,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 10 : 11,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark, bool isSmallWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isSmallWidth ? 9 : 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required bool isSmallWidth,
  }) {
    final bool disabled = onChanged == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallWidth ? 11 : 14,
        vertical: isSmallWidth ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: disabled ? 0.45 : 1,
            child: _buildIconContainer(
              icon,
              iconBackgroundColor,
              iconColor,
              isSmallWidth,
            ),
          ),
          SizedBox(width: isSmallWidth ? 9 : 13),
          Expanded(
            child: Opacity(
              opacity: disabled ? 0.45 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 12 : 13,
                      fontWeight: FontWeight.w700,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 9 : 10,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF6366F1),
            activeTrackColor: isDark ? const Color(0xFF4338CA) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTimeTile({
    required BuildContext context,
    required SettingsState state,
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required bool isSmallWidth,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final bool enabled =
        state.notificationsEnabled && state.taskRemindersEnabled;

    return GestureDetector(
      onTap: enabled
          ? () {
              _showReminderTimeDialog(
                context,
                state.taskReminderMinutes,
                isDark,
              );
            }
          : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallWidth ? 11 : 14,
            vertical: isSmallWidth ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.7),
          ),
          child: Row(
            children: [
              _buildIconContainer(
                Icons.schedule_outlined,
                iconBackgroundColor,
                iconColor,
                isSmallWidth,
              ),
              SizedBox(width: isSmallWidth ? 9 : 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.reminderBeforeTask,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatMinutes(state.taskReminderMinutes, l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 9 : 10,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: isSmallWidth ? 18 : 19,
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReminderTimeDialog(
    BuildContext context,
    int selectedMinutes,
    bool isDark,
  ) {
    final l10n = AppLocalizations.of(context)!;

    const List<int> options = [5, 10, 15, 30, 60];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            l10n.reminderBeforeTask,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((minutes) {
                final bool selected = minutes == selectedMinutes;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    _formatMinutes(minutes, l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 13,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF6366F1),
                        )
                      : null,
                  onTap: () {
                    context.read<SettingsCubit>().changeTaskReminderMinutes(
                      minutes,
                    );

                    Navigator.pop(dialogContext);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _formatMinutes(int minutes, AppLocalizations l10n) {
    if (minutes == 60) {
      return l10n.oneHourBefore;
    }

    return l10n.minutesBefore(minutes);
  }

  Widget _buildIconContainer(
    IconData icon,
    Color backgroundColor,
    Color iconColor,
    bool isSmallWidth,
  ) {
    final double size = isSmallWidth ? 38 : 40;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, size: isSmallWidth ? 19 : 20, color: iconColor),
    );
  }
}
