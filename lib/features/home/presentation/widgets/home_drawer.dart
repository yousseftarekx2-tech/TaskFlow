import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/auth/data/model/user_model.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final UserModel? user = context.watch<UserCubit>().state;
    final SettingsState settings = context.watch<SettingsCubit>().state;

    final bool isDark = settings.darkModeEnabled;

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF334155);

    final Color iconColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF64748B);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color mutedColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.sizeOf(context).width;
        final bool isSmallWidth = screenWidth < 360;

        final double drawerWidth = isSmallWidth
            ? screenWidth * 0.88
            : screenWidth * 0.82;

        final double horizontalPadding = isSmallWidth ? 14 : 16;

        return Drawer(
          backgroundColor: backgroundColor,
          width: drawerWidth,
          child: SafeArea(
            child: Column(
              children: [
                _buildProfileHeader(
                  context,
                  user,
                  isDark,
                  surfaceColor,
                  borderColor,
                  primaryTextColor,
                  mutedColor,
                  l10n,
                  isSmallWidth,
                ),
                SizedBox(height: isSmallWidth ? 14 : 18),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        _buildSectionTitle(l10n.main, mutedColor, isSmallWidth),
                        _buildDrawerItem(
                          context,
                          icon: Icons.home_outlined,
                          title: l10n.home,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);

                            if (GoRouterState.of(context).uri.path !=
                                Routes.home) {
                              context.push(Routes.home);
                            }
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.calendar_month_outlined,
                          title: l10n.calendar,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.calendar);
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.center_focus_strong_outlined,
                          title: l10n.focus,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.focus);
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.bar_chart_outlined,
                          title: l10n.statistics,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.state);
                          },
                        ),
                        SizedBox(height: isSmallWidth ? 16 : 20),
                        _buildSectionTitle(
                          l10n.tasks,
                          mutedColor,
                          isSmallWidth,
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.task_alt_outlined,
                          title: l10n.allTasks,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.allTasks);
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.check_circle_outline,
                          title: l10n.completedTasks,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.completedTasks);
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.category_outlined,
                          title: l10n.categories,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.category);
                          },
                        ),
                        SizedBox(height: isSmallWidth ? 16 : 20),
                        _buildSectionTitle(
                          l10n.application,
                          mutedColor,
                          isSmallWidth,
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.notifications_none_rounded,
                          title: l10n.notifications,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.notifications);
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.settings_outlined,
                          title: l10n.settings,
                          iconColor: iconColor,
                          textColor: primaryTextColor,
                          arrowColor: mutedColor,
                          isSmallWidth: isSmallWidth,
                          onTap: () {
                            Navigator.pop(context);
                            context.push(Routes.settings);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _buildLogoutItem(context, isDark, l10n, isSmallWidth),
                _buildDrawerFooter(
                  isDark,
                  surfaceColor,
                  borderColor,
                  mutedColor,
                  l10n,
                  isSmallWidth,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UserModel? user,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryTextColor,
    Color mutedColor,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final double avatarSize = isSmallWidth ? 52 : 58;

    return Material(
      color: surfaceColor,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.push(Routes.profile);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isSmallWidth ? 16 : 22,
            isSmallWidth ? 18 : 24,
            isSmallWidth ? 16 : 22,
            isSmallWidth ? 18 : 22,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(bottom: BorderSide(color: borderColor, width: 0.7)),
          ),
          child: Row(
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF312E81)
                      : const Color(0xFFEEF2FF),
                  border: Border.all(color: borderColor),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: user?.photoUrl != null
                      ? NetworkImage(user!.photoUrl!)
                      : null,
                  child: user?.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: isSmallWidth ? 22 : 24,
                          color: mutedColor,
                        )
                      : null,
                ),
              ),
              SizedBox(width: isSmallWidth ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? l10n.user,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 14 : 15,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 10 : 11,
                        fontWeight: FontWeight.w500,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isSmallWidth ? 4 : 8),
              Icon(
                Icons.chevron_right_rounded,
                size: isSmallWidth ? 18 : 20,
                color: mutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color, bool isSmallWidth) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, isSmallWidth ? 6 : 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 9 : 10,
            fontWeight: FontWeight.w800,
            letterSpacing: isSmallWidth ? 0.6 : 0.8,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color textColor,
    required Color arrowColor,
    required VoidCallback onTap,
    required bool isSmallWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallWidth ? 12 : 14,
              vertical: isSmallWidth ? 10 : 12,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(icon, size: isSmallWidth ? 20 : 21, color: iconColor),
                SizedBox(width: isSmallWidth ? 11 : 14),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 12 : 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(width: isSmallWidth ? 4 : 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: isSmallWidth ? 17 : 18,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutItem(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isSmallWidth ? 12 : 16,
        0,
        isSmallWidth ? 12 : 16,
        isSmallWidth ? 10 : 12,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () async {
            Navigator.pop(context);

            await context.read<UserCubit>().logout();

            if (!context.mounted) return;

            context.go(Routes.login);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallWidth ? 12 : 14,
              vertical: isSmallWidth ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: isSmallWidth ? 20 : 21,
                  color: Colors.red,
                ),
                SizedBox(width: isSmallWidth ? 11 : 14),
                Expanded(
                  child: Text(
                    l10n.logout,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 12 : 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color mutedColor,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isSmallWidth ? 16 : 20,
        isSmallWidth ? 12 : 14,
        isSmallWidth ? 16 : 20,
        isSmallWidth ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: borderColor, width: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.needthis,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.taskFlow,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 10 : 11,
                fontWeight: FontWeight.w700,
                color: mutedColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: isSmallWidth ? 9 : 10,
              fontWeight: FontWeight.w600,
              color: mutedColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
