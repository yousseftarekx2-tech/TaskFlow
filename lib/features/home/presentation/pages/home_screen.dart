import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/core/widgets/notification_icon_button.dart';

import 'package:task_flow/features/auth/data/model/user_model.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';

import 'package:task_flow/features/home/presentation/widgets/home_task_card.dart';
import 'package:task_flow/features/home/presentation/widgets/task_details_screen.dart';
import 'package:task_flow/features/home/presentation/widgets/home_drawer.dart';

import 'package:task_flow/features/statistics/presentation/pages/stats_screen.dart';

import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';

import 'package:task_flow/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int notificationCount = 0;

  // ------------------------------------------------------------
  // UPCOMING TASKS
  // ------------------------------------------------------------

  List<Widget> _buildUpcomingTasks(
    List<TaskModel> tasks,
    DateTime today,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final DateTime todayDate = DateTime(today.year, today.month, today.day);

    final List<TaskModel> upcomingTasks = tasks.where((task) {
      final DateTime taskDate = DateTime(
        task.scheduledAt.year,
        task.scheduledAt.month,
        task.scheduledAt.day,
      );

      return taskDate.isAfter(todayDate) &&
          !task.isCompleted &&
          !task.isOverdue;
    }).toList()..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final List<TaskModel> displayedTasks = upcomingTasks.take(3).toList();

    if (displayedTasks.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              l10n.noUpcomingTasks,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
      ];
    }

    return displayedTasks
        .map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HomeTaskCard(
              title: task.title,
              category: task.category,
              taskId: task.id,
              time: _formatTime(task.scheduledAt, l10n),
              color: _categoryColor(task.category),
              completed: task.isCompleted,
              overdue: task.isOverdue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskDetailsScreen(task: task),
                  ),
                );
              },
            ),
          ),
        )
        .toList();
  }

  // ------------------------------------------------------------
  // FORMAT TIME
  // ------------------------------------------------------------

  String _formatTime(DateTime dateTime, AppLocalizations l10n) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;

    final String period = hour >= 12 ? l10n.pm : l10n.am;

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  // ------------------------------------------------------------
  // CATEGORY COLOR
  // ------------------------------------------------------------

  Color _categoryColor(String category) {
    switch (category) {
      case 'Design':
        return const Color(0xFF2563EB);

      case 'Meeting':
        return const Color(0xFFF97316);

      case 'Development':
        return const Color(0xFF16A34A);

      case 'Work':
        return const Color(0xFF8B5CF6);

      case 'Health':
        return const Color(0xFF14B8A6);

      default:
        return AppColors.needthis;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final taskState = context.watch<TaskBloc>().state;

    final settingsState = context.watch<SettingsCubit>().state;

    final bool isDark = settingsState.darkModeEnabled;

    final List<TaskModel> tasks = taskState is TaskLoaded
        ? taskState.tasks
        : [];

    final DateTime today = DateTime.now();

    // ------------------------------------------------------------
    // THEME COLORS
    // ------------------------------------------------------------

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final Color mutedTextColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color iconBackgroundColor = isDark
        ? const Color(0xFF312E81)
        : const Color(0xFFEEF2FF);

    // ------------------------------------------------------------
    // TODAY'S TASKS
    // ------------------------------------------------------------

    final List<TaskModel> todayTasks = tasks.where((task) {
      final bool isToday =
          task.scheduledAt.year == today.year &&
          task.scheduledAt.month == today.month &&
          task.scheduledAt.day == today.day;

      return isToday && !task.isOverdue;
    }).toList()..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final int totalTask = todayTasks.length;

    final int completeTask = todayTasks
        .where((task) => task.isCompleted)
        .length;

    final double progress = totalTask == 0 ? 0 : completeTask / totalTask;

    return Scaffold(
      backgroundColor: backgroundColor,

      drawer: HomeDrawer(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // --------------------------------------------------
              // HEADER
              // --------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.menu,
                                size: 21,
                                color: primaryTextColor,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<UserCubit, UserModel?>(
                            builder: (context, user) {
                              return Text(
                                '${l10n.hello}, ${user?.name ?? l10n.user}',
                                style: AppTextStyle.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 2),

                          Text(
                            l10n.letsMakeTodayProductive,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // --------------------------------------------------
                  // NOTIFICATIONS
                  // --------------------------------------------------
                  NotificationIconButton(isDark: isDark),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // --------------------------------------------------
              // TODAY'S PROGRESS
              // --------------------------------------------------
              Container(
                width: double.infinity,
                height: 110,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 0.8),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 75,
                            height: 75,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              backgroundColor: borderColor,
                              color: AppColors.needthis,
                            ),
                          ),

                          Text(
                            '${(progress * 100).round()}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.todaysProgress,
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            l10n.tasksCompleted(completeTask, totalTask),
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontSize: 12,
                              color: secondaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 0.3),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StatsScreen(),
                            ),
                          );
                        },
                        child: Image.asset(AppImages.static),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // --------------------------------------------------
              // TODAY'S TASKS HEADER
              // --------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.todaysTasks,
                    style: AppTextStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 22,
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      context.push(Routes.todayTasks);
                    },
                    child: Row(
                      children: [
                        Text(
                          l10n.seeAll,
                          style: TextStyle(
                            color: AppColors.needthis,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 3),

                        Icon(
                          Icons.chevron_right,
                          size: 22,
                          color: AppColors.needthis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // TODAY'S TASKS
              // --------------------------------------------------
              if (todayTasks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      l10n.noTasksForToday,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: mutedTextColor,
                      ),
                    ),
                  ),
                )
              else
                ...todayTasks
                    .take(4)
                    .map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HomeTaskCard(
                          title: task.title,
                          category: task.category,
                          taskId: task.id,
                          time: _formatTime(task.scheduledAt, l10n),
                          color: _categoryColor(task.category),
                          completed: task.isCompleted,
                          overdue: task.isOverdue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailsScreen(task: task),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

              const SizedBox(height: AppSpacing.xl),

              // --------------------------------------------------
              // UPCOMING HEADER
              // --------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.upcoming,
                    style: AppTextStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 22,
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      context.push(Routes.upcomingTasks);
                    },
                    child: Row(
                      children: [
                        Text(
                          l10n.seeAll,
                          style: TextStyle(
                            color: AppColors.needthis,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 3),

                        Icon(
                          Icons.chevron_right,
                          size: 22,
                          color: AppColors.needthis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // --------------------------------------------------
              // UPCOMING TASKS
              // --------------------------------------------------
              ..._buildUpcomingTasks(tasks, today, isDark, l10n),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
