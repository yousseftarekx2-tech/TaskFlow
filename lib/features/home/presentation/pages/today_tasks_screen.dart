import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/l10n/app_localizations.dart';

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

  String _formatTime(DateTime dateTime, AppLocalizations l10n) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;

    final String period = hour >= 12 ? l10n.pm : l10n.am;

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
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

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color mutedTextColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    // ------------------------------------------------------------
    // TODAY'S TASKS
    // ------------------------------------------------------------

    final List<TaskModel> todayTasks = tasks.where((task) {
      return task.scheduledAt.year == today.year &&
          task.scheduledAt.month == today.month &&
          task.scheduledAt.day == today.day;
    }).toList();

    todayTasks.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return Scaffold(
      backgroundColor: backgroundColor,

      // ------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: primaryTextColor,
          ),
        ),

        title: Text(
          l10n.todaysTasks,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
          ),
        ),
      ),

      // ------------------------------------------------------------
      // BODY
      // ------------------------------------------------------------
      body: todayTasks.isEmpty
          ? Center(
              child: Text(
                l10n.noTasksForToday,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: mutedTextColor,
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
                    time: _formatTime(task.scheduledAt, l10n),
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
