import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final double horizontalPadding = isSmallWidth ? 14 : 20;
    final double topPadding = isShortScreen ? 8 : 12;
    final double bottomPadding = isShortScreen ? 20 : 30;
    final double cardPadding = isSmallWidth ? 12 : 14;
    final double statusSize = isSmallWidth ? 40 : 42;
    final double statusIconSize = isSmallWidth ? 20 : 21;

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

        const Color secondaryTextColor = Color(0xFF94A3B8);
        final Color categoryColor = _categoryColor();

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
              categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 19 : 21,
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
                    isSmallWidth,
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
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
                        isSmallWidth,
                        cardPadding,
                        statusSize,
                        statusIconSize,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    AppLocalizations l10n,
    Color categoryColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    bool isSmallWidth,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallWidth ? 24 : 40,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isSmallWidth ? 64 : 72,
              height: isSmallWidth ? 64 : 72,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_alt_rounded,
                size: isSmallWidth ? 30 : 34,
                color: categoryColor,
              ),
            ),
            SizedBox(height: isSmallWidth ? 14 : 18),
            Text(
              l10n.categoryNoTasks(categoryName),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 17 : 18,
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            SizedBox(height: isSmallWidth ? 6 : 8),
            Text(
              l10n.categoryTasksDescription,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 12 : 13,
                height: 1.5,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    bool isSmallWidth,
    double cardPadding,
    double statusSize,
    double statusIconSize,
  ) {
    final bool completed = task.isCompleted;
    final bool overdue = task.isOverdue;

    final Color titleColor = completed || overdue
        ? secondaryTextColor
        : primaryTextColor;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isSmallWidth ? 8 : 10),
      padding: EdgeInsets.symmetric(
        horizontal: cardPadding,
        vertical: isSmallWidth ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(isSmallWidth ? 14 : 16),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Row(
        children: [
          Container(
            width: statusSize,
            height: statusSize,
            decoration: BoxDecoration(
              color: completed
                  ? AppColors.needthis.withValues(alpha: 0.10)
                  : overdue
                  ? Colors.red.withValues(alpha: 0.10)
                  : categoryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(isSmallWidth ? 11 : 12),
            ),
            child: Icon(
              completed
                  ? Icons.check_rounded
                  : overdue
                  ? Icons.warning_amber_rounded
                  : Icons.task_alt_rounded,
              size: statusIconSize,
              color: completed
                  ? AppColors.needthis
                  : overdue
                  ? Colors.red
                  : categoryColor,
            ),
          ),
          SizedBox(width: isSmallWidth ? 10 : 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                SizedBox(height: isSmallWidth ? 5 : 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: isSmallWidth ? 13 : 14,
                      color: secondaryTextColor,
                    ),
                    SizedBox(width: isSmallWidth ? 4 : 5),
                    Expanded(
                      child: Text(
                        _formatDateTime(task.scheduledAt, l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 10 : 11,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallWidth ? 8 : 10),
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

  String _formatDateTime(DateTime date, AppLocalizations l10n) {
    final int hour = date.hour;

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    final String period = hour >= 12 ? 'PM' : 'AM';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}'
        '${l10n.categoryDateTimeSeparator}'
        '$displayHour:'
        '${date.minute.toString().padLeft(2, '0')} '
        '$period';
  }
}
