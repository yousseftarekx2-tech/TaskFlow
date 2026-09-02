import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.color,
    required this.scheduledAt,
    this.completed = false,
    this.overdue = false,
    required this.taskId,
  });

  final String title;
  final String category;
  final String taskId;
  final String time;
  final Color color;
  final DateTime scheduledAt;
  final bool completed;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final bool isSmallWidth = MediaQuery.sizeOf(context).width < 360;

    final Color titleColor = completed || overdue
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;

    final Color secondaryColor = colorScheme.onSurfaceVariant;

    final DateTime now = DateTime.now();
    final DateTime overdueAt = scheduledAt.add(TaskBloc.overdueDuration);

    final bool hasStarted = !now.isBefore(scheduledAt);

    final bool canComplete =
        !completed && !overdue && hasStarted && now.isBefore(overdueAt);

    final Color statusColor = completed
        ? AppColors.needthis
        : overdue
        ? Colors.red
        : canComplete
        ? AppColors.needthis
        : colorScheme.onSurfaceVariant;

    final double cardHeight = isSmallWidth ? 88 : 96;
    final double indicatorHeight = isSmallWidth ? 64 : 72;
    final double horizontalGap = isSmallWidth ? 12 : 16;
    final double trailingGap = isSmallWidth ? 14 : 18;
    final double statusSize = isSmallWidth ? 22 : 24;

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.35),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.15 : 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 5,
              height: indicatorHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          ),
          SizedBox(width: horizontalGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: secondaryColor,
                    decorationThickness: 1.5,
                  ),
                ),
                SizedBox(height: isSmallWidth ? 6 : 8),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isSmallWidth ? 105 : 140,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallWidth ? 8 : 10,
                          vertical: isSmallWidth ? 4 : 5,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontSize: isSmallWidth ? 11 : 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallWidth ? 7 : 9),
                    Icon(
                      Icons.access_time_outlined,
                      size: isSmallWidth ? 14 : 16,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: isSmallWidth ? 11 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallWidth ? 8 : 12),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: canComplete
                ? () {
                    context.read<TaskBloc>().add(CompleteTask(taskId));
                  }
                : null,
            child: Container(
              width: statusSize,
              height: statusSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: statusColor, width: 2),
              ),
              child: completed
                  ? Icon(
                      Icons.check,
                      color: AppColors.needthis,
                      size: isSmallWidth ? 15 : 17,
                    )
                  : overdue
                  ? Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: isSmallWidth ? 15 : 17,
                    )
                  : null,
            ),
          ),
          SizedBox(width: trailingGap),
        ],
      ),
    );
  }
}
