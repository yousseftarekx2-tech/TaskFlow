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

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

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

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final bool isDarkMode = settingsState.darkModeEnabled;

        final Color backgroundColor = isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC);

        final Color textColor = isDarkMode
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF0F172A);

        const Color secondaryTextColor = Color(0xFF94A3B8);

        final TaskState state = context.watch<TaskBloc>().state;

        final List<TaskModel> tasks = state is TaskLoaded
            ? List<TaskModel>.from(state.tasks)
            : <TaskModel>[];

        tasks.sort((a, b) {
          final int dateComparison = b.scheduledAt.compareTo(a.scheduledAt);

          if (dateComparison != 0) {
            return dateComparison;
          }

          return b.scheduledAt.compareTo(a.scheduledAt);
        });

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: isSmallWidth ? 54 : 56,
            leadingWidth: isSmallWidth ? 48 : 56,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: isSmallWidth ? 18 : 20,
                color: textColor,
              ),
            ),
            titleSpacing: isSmallWidth ? 0 : null,
            title: Text(
              l10n.allTasks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 20 : 22,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
          body: tasks.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Text(
                      l10n.noTasksYet,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
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
                  itemCount: tasks.length,
                  separatorBuilder: (_, _) => SizedBox(height: separatorHeight),
                  itemBuilder: (context, index) {
                    final TaskModel task = tasks[index];

                    return TaskCard(
                      title: task.title,
                      category: task.category,
                      taskId: task.id,
                      time: _formatScheduledAt(task.scheduledAt, l10n),
                      color: _categoryColor(context, task.category),
                      completed: task.isCompleted,
                      overdue: task.isOverdue,
                      scheduledAt: task.scheduledAt,
                    );
                  },
                ),
        );
      },
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
