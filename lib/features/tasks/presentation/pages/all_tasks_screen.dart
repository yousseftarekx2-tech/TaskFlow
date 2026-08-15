import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks = state is TaskLoaded
        ? List<TaskModel>.from(state.tasks)
        : [];

    tasks.sort((a, b) {
      final dateComparison = b.scheduledAt.compareTo(a.scheduledAt);

      if (dateComparison != 0) {
        return dateComparison;
      }

      return b.scheduledAt.compareTo(a.scheduledAt);
    });

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
          'All Tasks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),

      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              itemCount: tasks.length,

              separatorBuilder: (_, __) {
                return const SizedBox(height: 10);
              },

              itemBuilder: (context, index) {
                final task = tasks[index];

                return TaskCard(
                  title: task.title,
                  category: task.category,
                  taskId: task.id,
                  time: _formatScheduledAt(task.scheduledAt),
                  color: _categoryColor(task.category),
                  completed: task.isCompleted,
                  overdue: task.isOverdue,
                );
              },
            ),
    );
  }

  String _formatScheduledAt(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year} • '
        '$hour:$minute $period';
  }

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
}
