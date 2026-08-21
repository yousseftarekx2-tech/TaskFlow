import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final taskState = context.watch<TaskBloc>().state;
    final settingsState =
        context.watch<SettingsCubit>().state;

    final bool isDark =
        settingsState.darkModeEnabled;

    final List<TaskModel> completedTasks =
        taskState is TaskLoaded
        ? taskState.tasks
              .where((task) => task.isCompleted)
              .toList()
        : [];

    completedTasks.sort(
      (a, b) => b.scheduledAt.compareTo(a.scheduledAt),
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark
                ? Colors.white
                : const Color(0xFF0F172A),
          ),
        ),
        title: Text(
          l10n.completedTasks,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark
                ? Colors.white
                : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: completedTasks.isEmpty
          ? Center(
              child: Text(
                l10n.noCompletedTasks,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                30,
              ),
              itemCount: completedTasks.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final task = completedTasks[index];

                return TaskCard(
                  title: task.title,
                  category: task.category,
                  taskId: task.id,
                  time: _formatScheduledAt(
                    task.scheduledAt,
                  ),
                  color: _categoryColor(task.category),
                  completed: true,
                  overdue: false,
                );
              },
            ),
    );
  }

  String _formatScheduledAt(DateTime dateTime) {
    final int hour =
        dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final String minute =
        dateTime.minute.toString().padLeft(2, '0');

    final String period =
        dateTime.hour >= 12 ? 'PM' : 'AM';

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
      case 'Learning':
        return const Color(0xFFF97316);
      default:
        return AppColors.needthis;
    }
  }
}