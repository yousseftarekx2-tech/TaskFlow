import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';

class CategoryTasksScreen extends StatelessWidget {
  const CategoryTasksScreen({
    super.key,
    required this.categoryName,
    required this.tasks,
  });

  final String categoryName;
  final List<TaskModel> tasks;

  Color _categoryColor() {
    switch (categoryName) {
      case 'Design':
        return const Color(0xFF2563EB);

      case 'Meeting':
        return const Color(0xFFF97316);

      case 'Development':
        return const Color(0xFF16A34A);

      case 'Work':
        return const Color(0xFF8B5CF6);

      default:
        return AppColors.needthis;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final bool isDarkMode = settingsState.darkModeEnabled;

        final Color backgroundColor = isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC);

        final Color cardColor = isDarkMode
            ? const Color(0xFF1E293B)
            : Colors.white;

        final Color primaryTextColor = isDarkMode
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF0F172A);

        final Color borderColor = isDarkMode
            ? const Color(0xFF334155)
            : const Color(0xFFE2E8F0);

        final Color chevronColor = isDarkMode
            ? const Color(0xFF64748B)
            : const Color(0xFFCBD5E1);

        final Color secondaryTextColor = const Color(0xFF94A3B8);

        final Color categoryColor = _categoryColor();

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
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
              categoryName,

              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
          ),

          body: SafeArea(
            child: tasks.isEmpty
                ? _buildEmptyState(
                    l10n,
                    categoryColor,
                    primaryTextColor,
                    secondaryTextColor,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

                    itemCount: tasks.length,

                    itemBuilder: (context, index) {
                      return _buildTaskCard(
                        context,
                        l10n,
                        tasks[index],
                        categoryColor,
                        cardColor,
                        borderColor,
                        primaryTextColor,
                        secondaryTextColor,
                        chevronColor,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
    AppLocalizations l10n,
    Color categoryColor,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 72,
              height: 72,

              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.task_alt_rounded,
                size: 34,
                color: categoryColor,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              l10n.categoryNoTasks(categoryName),
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.categoryTasksDescription,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TASK CARD
  // ============================================================

  Widget _buildTaskCard(
    BuildContext context,
    AppLocalizations l10n,
    TaskModel task,
    Color categoryColor,
    Color cardColor,
    Color borderColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color chevronColor,
  ) {
    final bool completed = task.isCompleted;
    final bool overdue = task.isOverdue;

    final Color titleColor = completed || overdue
        ? secondaryTextColor
        : primaryTextColor;

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: borderColor,
          width: 0.7,
        ),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // STATUS
          // ------------------------------------------------------

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: completed
                  ? AppColors.needthis.withValues(alpha: 0.10)
                  : overdue
                  ? Colors.red.withValues(alpha: 0.10)
                  : categoryColor.withValues(alpha: 0.10),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              completed
                  ? Icons.check_rounded
                  : overdue
                  ? Icons.warning_amber_rounded
                  : Icons.task_alt_rounded,

              size: 21,

              color: completed
                  ? AppColors.needthis
                  : overdue
                  ? Colors.red
                  : categoryColor,
            ),
          ),

          const SizedBox(width: 13),

          // ------------------------------------------------------
          // TASK INFO
          // ------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  task.title,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,

                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: secondaryTextColor,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      _formatDateTime(
                        task.scheduledAt,
                        l10n,
                      ),

                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ------------------------------------------------------
          // STATUS DOT
          // ------------------------------------------------------

          Container(
            width: 8,
            height: 8,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: completed
                  ? AppColors.needthis
                  : overdue
                  ? Colors.red
                  : categoryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDateTime(
    DateTime date,
    AppLocalizations l10n,
  ) {
    final int hour = date.hour;

    final int displayHour = hour % 12 == 0
        ? 12
        : hour % 12;

    final String period = hour >= 12
        ? 'PM'
        : 'AM';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}'
        '${l10n.categoryDateTimeSeparator}'
        '$displayHour:'
        '${date.minute.toString().padLeft(2, '0')} '
        '$period';
  }
}