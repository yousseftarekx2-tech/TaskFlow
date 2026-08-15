import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

class UpcomingTasksScreen extends StatelessWidget {
  const UpcomingTasksScreen({super.key});

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

  String _formatTime(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;

    final String period = hour >= 12 ? 'PM' : 'AM';

    final int displayHour =
        hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _upcomingTaskTime(TaskModel task) {
    final DateTime now = DateTime.now();

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime taskDate = DateTime(
      task.scheduledAt.year,
      task.scheduledAt.month,
      task.scheduledAt.day,
    );

    final int difference =
        taskDate.difference(today).inDays;

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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks =
        state is TaskLoaded ? state.tasks : [];

    final DateTime today = DateTime.now();

    final DateTime todayDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final List<TaskModel> upcomingTasks = tasks.where((task) {
      final DateTime taskDate = DateTime(
        task.scheduledAt.year,
        task.scheduledAt.month,
        task.scheduledAt.day,
      );

      // Upcoming = future pending tasks only.
      return taskDate.isAfter(todayDate) &&
          !task.isCompleted &&
          !task.isOverdue;
    }).toList();

    upcomingTasks.sort(
      (a, b) => a.scheduledAt.compareTo(b.scheduledAt),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF0F172A),
          ),
        ),
        title: const Text(
          'Upcoming',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: upcomingTasks.isEmpty
          ? const Center(
              child: Text(
                'No upcoming tasks',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                30,
              ),
              itemCount: upcomingTasks.length,
              itemBuilder: (context, index) {
                final TaskModel task = upcomingTasks[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    title: task.title,
                    category: task.category,
                    taskId: task.id,
                    time: _upcomingTaskTime(task),
                    color: _categoryColor(task.category),
                    completed: task.isCompleted,
                    overdue: task.isOverdue,
                  ),
                );
              },
            ),
    );
  }
}