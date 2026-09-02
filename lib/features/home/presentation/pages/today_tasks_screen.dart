import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class TodayTasksScreen extends StatelessWidget {
  const TodayTasksScreen({super.key});

  Color _categoryColor(BuildContext context, String categoryName) {
    final CategoryModel? category = context
        .read<CategoryCubit>()
        .getCategoryByName(categoryName);

    return category?.color ?? const Color(0xFF2563EB);
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

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color mutedTextColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    final List<TaskModel> todayTasks = tasks.where((task) {
      return task.scheduledAt.year == today.year &&
          task.scheduledAt.month == today.month &&
          task.scheduledAt.day == today.day;
    }).toList();

    todayTasks.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallWidth = constraints.maxWidth < 360;
        final bool isShortHeight = constraints.maxHeight < 650;

        final double horizontalPadding = isSmallWidth ? 16 : 20;
        final double topPadding = isShortHeight ? 8 : 12;
        final double bottomPadding = isShortHeight ? 24 : 30;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: isSmallWidth ? 18 : 20,
                color: primaryTextColor,
              ),
            ),
            title: Text(
              l10n.todaysTasks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 20 : 22,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
          ),
          body: todayTasks.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Text(
                      l10n.noTasksForToday,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: mutedTextColor,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    topPadding,
                    horizontalPadding,
                    bottomPadding,
                  ),
                  itemCount: todayTasks.length,
                  itemBuilder: (context, index) {
                    final TaskModel task = todayTasks[index];

                    final Color categoryColor = _categoryColor(
                      context,
                      task.category,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(
                        title: task.title,
                        category: task.category,
                        taskId: task.id,
                        time: _formatTime(task.scheduledAt, l10n),
                        color: categoryColor,
                        completed: task.isCompleted,
                        overdue: task.isOverdue,
                        scheduledAt: task.scheduledAt,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
