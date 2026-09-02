import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';
import 'package:task_flow/features/home/presentation/widgets/task_card.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final double horizontalPadding = isSmallWidth ? 14 : 20;
    final double topPadding = isShortScreen ? 8 : 12;
    final double bottomPadding = isShortScreen ? 20 : 30;
    final double separatorHeight = isSmallWidth ? 8 : 10;

    final TaskState taskState = context.watch<TaskBloc>().state;
    final SettingsState settingsState = context.watch<SettingsCubit>().state;

    final bool isDark = settingsState.darkModeEnabled;

    final List<TaskModel> completedTasks = taskState is TaskLoaded
        ? taskState.tasks.where((task) => task.isCompleted).toList()
        : <TaskModel>[];

    completedTasks.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color primaryTextColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A);

    final Color mutedTextColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: isSmallWidth ? 54 : 56,
        leadingWidth: isSmallWidth ? 48 : 56,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: isSmallWidth ? 18 : 20,
            color: primaryTextColor,
          ),
        ),
        titleSpacing: isSmallWidth ? 0 : null,
        title: Text(
          l10n.completedTasks,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 20 : 22,
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
          ),
        ),
      ),
      body: completedTasks.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  l10n.noCompletedTasks,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: mutedTextColor,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              itemCount: completedTasks.length,
              separatorBuilder: (_, _) => SizedBox(height: separatorHeight),
              itemBuilder: (context, index) {
                final TaskModel task = completedTasks[index];

                return TaskCard(
                  title: task.title,
                  category: task.category,
                  taskId: task.id,
                  time: _formatScheduledAt(task.scheduledAt, l10n),
                  color: _categoryColor(context, task.category),
                  completed: true,
                  overdue: false,
                  scheduledAt: task.scheduledAt,
                );
              },
            ),
    );
  }

  String _formatScheduledAt(DateTime dateTime, AppLocalizations l10n) {
    final int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final String minute = dateTime.minute.toString().padLeft(2, '0');

    final String period = dateTime.hour >= 12 ? l10n.pm : l10n.am;

    return '${dateTime.day}/${dateTime.month}/${dateTime.year} • '
        '$hour:$minute $period';
  }

  Color _categoryColor(BuildContext context, String categoryName) {
    final CategoryModel? category = context
        .read<CategoryCubit>()
        .getCategoryByName(categoryName);

    return category?.color ?? AppColors.needthis;
  }
}
