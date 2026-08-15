import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/features/home/presentation/widgets/home_task_card.dart';
import 'package:task_flow/features/home/presentation/widgets/task_details_screen.dart';
import 'package:task_flow/features/home/presentation/widgets/task_settings.dart';
import 'package:task_flow/features/statistics/presentation/pages/stats_screen.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/home/presentation/widgets/home_drawer.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

// ------------------------------------------------------------
// EDIT SCREEN
// ------------------------------------------------------------
import 'package:task_flow/features/tasks/presentation/pages/create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = 'Youssef';
  final int notificationCount = 0;

  // ------------------------------------------------------------
  // UPCOMING TASKS
  // ------------------------------------------------------------

  List<Widget> _buildUpcomingTasks(List<TaskModel> tasks, DateTime today) {
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No upcoming tasks',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
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
              time: _formatTime(task.scheduledAt),
              color: _categoryColor(task.category),
              completed: task.isCompleted,
              overdue: task.isOverdue,

              // ------------------------------------------------
              // TASK SETTINGS
              // ------------------------------------------------
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
  // UPCOMING TASK TIME
  // ------------------------------------------------------------

  String _upcomingTaskTime(TaskModel task) {
    final DateTime now = DateTime.now();

    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime taskDate = DateTime(
      task.scheduledAt.year,
      task.scheduledAt.month,
      task.scheduledAt.day,
    );

    final int difference = taskDate.difference(today).inDays;

    final String time = _formatTime(task.scheduledAt);

    if (difference == 1) {
      return 'Tomorrow • $time';
    }

    if (difference == 2) {
      return 'In 2 days • $time';
    }

    if (difference == 3) {
      return 'In 3 days • $time';
    }

    return '${task.scheduledAt.day}/'
        '${task.scheduledAt.month}/'
        '${task.scheduledAt.year} • $time';
  }

  // ------------------------------------------------------------
  // FORMAT TIME
  // ------------------------------------------------------------

  String _formatTime(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;

    final String period = hour >= 12 ? 'PM' : 'AM';

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
    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks = state is TaskLoaded ? state.tasks : [];

    final DateTime today = DateTime.now();

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
      backgroundColor: const Color(0xFFF8FAFC),

      drawer: const HomeDrawer(),

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
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.menu, size: 21),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello $userName 👋',
                            style: AppTextStyle.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            'Let\'s make today productive',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: const Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 0.3,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.go(Routes.notifications);
                      },
                      padding: EdgeInsets.zero,
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_outlined,
                            size: 22,
                            color: Color(0xFF1E293B),
                          ),

                          if (notificationCount > 0)
                            Positioned(
                              right: -7,
                              top: -7,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 17,
                                  minHeight: 17,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  notificationCount > 99
                                      ? '99'
                                      : '$notificationCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 0.8,
                  ),
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
                              backgroundColor: const Color(0xFFE2E8F0),
                              color: AppColors.needthis,
                            ),
                          ),

                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
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
                            'Today\'s Progress',
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '$completeTask of $totalTask tasks completed',
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF475569),
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
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 0.3,
                        ),
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
                    'Today\'s Tasks',
                    style: AppTextStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
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
                          'See All',
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No tasks for today',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
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
                          time: _formatTime(task.scheduledAt),
                          color: _categoryColor(task.category),
                          completed: task.isCompleted,
                          overdue: task.isOverdue,

                          // ------------------------------------------------
                          // TASK SETTINGS
                          // ------------------------------------------------
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
                    'Upcoming',
                    style: AppTextStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
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
                          'See All',
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
              ..._buildUpcomingTasks(tasks, today),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
