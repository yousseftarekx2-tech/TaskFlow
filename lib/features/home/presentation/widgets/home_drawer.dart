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
  HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final user = context.watch<UserCubit>().state;
    final settings = context.watch<SettingsCubit>().state;

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

    return Drawer(
      backgroundColor: backgroundColor,
      width: MediaQuery.of(context).size.width * 0.82,

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
            ),

            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  children: [
                    _buildSectionTitle(l10n.main, mutedColor),

                    _buildDrawerItem(
                      context,
                      icon: Icons.home_outlined,
                      title: l10n.home,
                      iconColor: iconColor,
                      textColor: primaryTextColor,
                      arrowColor: mutedColor,
                      onTap: () {
                        Navigator.pop(context);

                        if (GoRouterState.of(context).uri.path != Routes.home) {
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
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.state);
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle(l10n.tasks, mutedColor),

                    _buildDrawerItem(
                      context,
                      icon: Icons.task_alt_outlined,
                      title: l10n.allTasks,
                      iconColor: iconColor,
                      textColor: primaryTextColor,
                      arrowColor: mutedColor,
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
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.category);
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle(l10n.application, mutedColor),

                    _buildDrawerItem(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: l10n.notifications,
                      iconColor: iconColor,
                      textColor: primaryTextColor,
                      arrowColor: mutedColor,
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
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.settings);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------------------
            // LOGOUT
            // ------------------------------------------------------------
            _buildLogoutItem(context, isDark, l10n),

            // ------------------------------------------------------------
            // FOOTER
            // ------------------------------------------------------------
            _buildDrawerFooter(
              isDark,
              surfaceColor,
              borderColor,
              mutedColor,
              l10n,
            ),
          ],
        ),
      ),
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
  ) {
    return Material(
      color: surfaceColor,

      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.push(Routes.profile);
        },

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),

          decoration: BoxDecoration(
            color: surfaceColor,

            border: Border(bottom: BorderSide(color: borderColor, width: 0.7)),
          ),

          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,

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
                      ? Icon(Icons.person, color: mutedColor)
                      : null,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      user?.name ?? l10n.user,

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user?.email ?? '',

                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right_rounded, size: 20, color: mutedColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title.toUpperCase(),

          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),

            child: Row(
              children: [
                Icon(icon, size: 21, color: iconColor),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),

                Icon(Icons.chevron_right_rounded, size: 18, color: arrowColor),
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
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),

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

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: isDark ? 0.12 : 0.06),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                const Icon(Icons.logout_rounded, size: 21, color: Colors.red),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    l10n.logout,

                    style: const TextStyle(
                      fontSize: 13,
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
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),

      decoration: BoxDecoration(
        color: surfaceColor,

        border: Border(top: BorderSide(color: borderColor, width: 0.7)),
      ),

      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,

            decoration: BoxDecoration(
              color: AppColors.needthis,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          Text(
            l10n.taskFlow,

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: mutedColor,
            ),
          ),

          const Spacer(),

          Text(
            'v1.0.0',

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: mutedColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
