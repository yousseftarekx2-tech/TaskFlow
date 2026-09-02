import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/core/widgets/notification_icon_button.dart';
import 'package:task_flow/features/auth/data/model/user_model.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';
import 'package:task_flow/features/home/presentation/widgets/home_drawer.dart';
import 'package:task_flow/features/home/presentation/widgets/home_task_card.dart';
import 'package:task_flow/features/home/presentation/widgets/task_details_screen.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/features/statistics/presentation/pages/stats_screen.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int notificationCount = 0;

  Color _categoryColor(BuildContext context, String categoryName) {
    final CategoryModel? category = context
        .read<CategoryCubit>()
        .getCategoryByName(categoryName);

    return category?.color ?? AppColors.needthis;
  }

  List<Widget> _buildUpcomingTasks(
    BuildContext context,
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
              textAlign: TextAlign.center,
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
              color: _categoryColor(context, task.category),
              completed: task.isCompleted,
              overdue: task.isOverdue,
              scheduledAt: task.scheduledAt,
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

  String _formatTime(DateTime dateTime, AppLocalizations l10n) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;

    final String period = hour >= 12 ? l10n.pm : l10n.am;

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  List<TaskModel> _homeTodayTasks(List<TaskModel> tasks, DateTime today) {
    final List<TaskModel> todayTasks = tasks.where((task) {
      final bool isToday =
          task.scheduledAt.year == today.year &&
          task.scheduledAt.month == today.month &&
          task.scheduledAt.day == today.day;

      return isToday && !task.isOverdue;
    }).toList();

    final List<TaskModel> completedTasks =
        todayTasks.where((task) => task.isCompleted).toList()..sort((a, b) {
          final DateTime aTime = a.completedAt ?? a.scheduledAt;
          final DateTime bTime = b.completedAt ?? b.scheduledAt;

          return bTime.compareTo(aTime);
        });

    final List<TaskModel> lastCompleted = completedTasks.take(2).toList();

    final List<TaskModel> pendingTasks =
        todayTasks.where((task) => task.isPending).toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final List<TaskModel> nextPending = pendingTasks.take(2).toList();

    return [...lastCompleted, ...nextPending];
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final TaskState taskState = context.watch<TaskBloc>().state;
    final SettingsState settingsState = context.watch<SettingsCubit>().state;

    final bool isDark = settingsState.darkModeEnabled;

    final List<TaskModel> tasks = taskState is TaskLoaded
        ? taskState.tasks
        : [];

    final DateTime today = DateTime.now();

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

    final List<TaskModel> allTodayTasks = tasks.where((task) {
      final bool isToday =
          task.scheduledAt.year == today.year &&
          task.scheduledAt.month == today.month &&
          task.scheduledAt.day == today.day;

      return isToday && !task.isOverdue;
    }).toList();

    final List<TaskModel> homeTodayTasks = _homeTodayTasks(tasks, today);

    final int totalTask = allTodayTasks.length;

    final int completeTask = allTodayTasks
        .where((task) => task.isCompleted)
        .length;

    final double progress = totalTask == 0 ? 0 : completeTask / totalTask;

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: HomeDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallWidth = constraints.maxWidth < 360;
            final bool isShortHeight = constraints.maxHeight < 700;

            final double horizontalPadding = isSmallWidth ? 16 : 20;
            final double headerSpacing = isSmallWidth ? 10 : 12;
            final double sectionSpacing = isSmallWidth ? 18 : 20;

            final double progressCardHeight = isSmallWidth ? 104 : 110;
            final double progressCardHorizontalPadding = isSmallWidth ? 12 : 16;
            final double progressCircleSize = isSmallWidth ? 58 : 64;
            final double progressIndicatorSize = isSmallWidth ? 68 : 75;

            final double titleFontSize = isSmallWidth ? 20 : 22;
            final double subtitleFontSize = isSmallWidth ? 11 : 12;

            final double topPadding = isShortHeight
                ? AppSpacing.sm
                : AppSpacing.md;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPadding),
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          return Container(
                            width: isSmallWidth ? 38 : 40,
                            height: isSmallWidth ? 38 : 40,
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
                                size: isSmallWidth ? 20 : 21,
                                color: primaryTextColor,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: headerSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<UserCubit, UserModel?>(
                              builder: (context, user) {
                                return Text(
                                  '${l10n.hello}, ${user?.name ?? l10n.user}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                    fontSize: isSmallWidth ? 16 : 18,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.letsMakeTodayProductive,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: secondaryTextColor,
                                fontSize: subtitleFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isSmallWidth ? 8 : 12),
                      NotificationIconButton(isDark: isDark),
                    ],
                  ),
                  SizedBox(height: sectionSpacing),
                  Container(
                    width: double.infinity,
                    height: progressCardHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: progressCardHorizontalPadding,
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
                          width: progressCircleSize,
                          height: progressCircleSize,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: progressIndicatorSize,
                                height: progressIndicatorSize,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: isSmallWidth ? 5 : 6,
                                  backgroundColor: borderColor,
                                  color: AppColors.needthis,
                                ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: TextStyle(
                                  fontSize: isSmallWidth ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isSmallWidth ? 10 : 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.todaysProgress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  fontSize: isSmallWidth ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                l10n.tasksCompleted(completeTask, totalTask),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  fontSize: isSmallWidth ? 11 : 12,
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isSmallWidth ? 8 : 12),
                        Container(
                          width: isSmallWidth ? 38 : 42,
                          height: isSmallWidth ? 38 : 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2.5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StatsScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.bar_chart_rounded,
                              color: AppColors.needthis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.todaysTasks,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            fontSize: titleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.push(Routes.todayTasks);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.seeAll,
                              style: TextStyle(
                                color: AppColors.needthis,
                                fontSize: isSmallWidth ? 13 : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.chevron_right,
                              size: isSmallWidth ? 20 : 22,
                              color: AppColors.needthis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallWidth ? 10 : 12),
                  if (homeTodayTasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.noTasksForToday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: mutedTextColor,
                          ),
                        ),
                      ),
                    )
                  else
                    ...homeTodayTasks.map((task) {
                      final Color categoryColor = _categoryColor(
                        context,
                        task.category,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HomeTaskCard(
                          title: task.title,
                          category: task.category,
                          taskId: task.id,
                          time: _formatTime(task.scheduledAt, l10n),
                          color: categoryColor,
                          completed: task.isCompleted,
                          overdue: task.isOverdue,
                          scheduledAt: task.scheduledAt,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailsScreen(task: task),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  SizedBox(height: isShortHeight ? 20 : AppSpacing.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.upcoming,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            fontSize: titleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.push(Routes.upcomingTasks);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.seeAll,
                              style: TextStyle(
                                color: AppColors.needthis,
                                fontSize: isSmallWidth ? 13 : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.chevron_right,
                              size: isSmallWidth ? 20 : 22,
                              color: AppColors.needthis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallWidth ? 8 : AppSpacing.sm),
                  ..._buildUpcomingTasks(context, tasks, today, isDark, l10n),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
