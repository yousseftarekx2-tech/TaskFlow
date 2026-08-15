import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

class TodayTasksScreen extends StatelessWidget {
  const TodayTasksScreen({super.key});

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

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks = state is TaskLoaded ? state.tasks : [];

    final DateTime today = DateTime.now();

    // See All بتاعة النهارده:
    // نعرض pending + completed + overdue.
    final List<TaskModel> todayTasks = tasks.where((task) {
      return task.scheduledAt.year == today.year &&
          task.scheduledAt.month == today.month &&
          task.scheduledAt.day == today.day;
    }).toList();

    todayTasks.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

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
          "Today's Tasks",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: todayTasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks for today',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              itemCount: todayTasks.length,
              itemBuilder: (context, index) {
                final TaskModel task = todayTasks[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    title: task.title,
                    category: task.category,
                    taskId: task.id,
                    time: _formatTime(task.scheduledAt),
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
