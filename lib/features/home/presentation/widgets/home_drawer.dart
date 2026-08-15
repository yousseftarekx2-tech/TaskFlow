import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8FAFC),
      width: MediaQuery.of(context).size.width * 0.82,
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(context),

            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildSectionTitle('Main'),

                    // Home
                    _buildDrawerItem(
                      context,
                      icon: Icons.home_outlined,
                      title: 'Home',
                      onTap: () {
                        Navigator.pop(context);

                        if (GoRouterState.of(context).uri.path != Routes.home) {
                          context.push(Routes.home);
                        }
                      },
                    ),

                    // Calendar
                    _buildDrawerItem(
                      context,
                      icon: Icons.calendar_month_outlined,
                      title: 'Calendar',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.calendar);
                      },
                    ),

                    // Focus
                    _buildDrawerItem(
                      context,
                      icon: Icons.center_focus_strong_outlined,
                      title: 'Focus',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.focus);
                      },
                    ),

                    // Statistics
                    _buildDrawerItem(
                      context,
                      icon: Icons.bar_chart_outlined,
                      title: 'Statistics',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.state);
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle('Tasks'),

                    // All Tasks - later
                    _buildDrawerItem(
                      context,
                      icon: Icons.task_alt_outlined,
                      title: 'All Tasks',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.allTasks);
                      },
                    ),
                    // Completed Tasks - later
                    _buildDrawerItem(
                      context,
                      icon: Icons.check_circle_outline,
                      title: 'Completed Tasks',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.completedTasks);
                      },
                    ),

                    // Categories - later
                    _buildDrawerItem(
                      context,
                      icon: Icons.category_outlined,
                      title: 'Categories',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.category);
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle('App'),
                    // Notifications
                    _buildDrawerItem(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.notifications);
                      },
                    ),

                    // Settings
                    _buildDrawerItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.settings);
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle('Other'),

                    // About - later
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.pop(context);
                        context.push(Routes.about);
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.push(Routes.profile);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.7),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEEF2FF),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 30,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Youssef',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'youssef@example.com',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
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
                Icon(icon, size: 21, color: const Color(0xFF64748B)),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 0.7)),
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

          const Text(
            'TaskFlow',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
            ),
          ),

          const Spacer(),

          const Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }
}
