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
    this.completed = false,
    this.overdue = false,
    required this.taskId,
  });

  final String title;
  final String category;
  final String taskId;
  final String time;
  final Color color;
  final bool completed;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color titleColor = completed || overdue
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;

    final Color secondaryColor = colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      height: 96,
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
          Container(
            width: 5,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),

          const SizedBox(width: 16),

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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: secondaryColor,
                    decorationThickness: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 9),

                    Icon(
                      Icons.access_time_outlined,
                      size: 16,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: completed || overdue
                ? null
                : () {
                    context.read<TaskBloc>().add(CompleteTask(taskId));
                  },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed
                    ? AppColors.needthis.withValues(alpha: 0.10)
                    : overdue
                    ? Colors.red.withValues(alpha: 0.10)
                    : Colors.transparent,
                border: Border.all(
                  color: completed
                      ? AppColors.needthis
                      : overdue
                      ? Colors.red
                      : AppColors.needthis,
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, color: AppColors.needthis, size: 17)
                  : overdue
                  ? const Icon(Icons.close_rounded, color: Colors.red, size: 17)
                  : null,
            ),
          ),

          const SizedBox(width: 18),
        ],
      ),
    );
  }
}
