import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';

class HomeTaskCard extends StatelessWidget {
  const HomeTaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.color,
    this.completed = false,
    this.overdue = false,
    required this.taskId,
    this.onTap,
  });

  final VoidCallback? onTap;

  final String title;
  final String category;
  final String taskId;
  final String time;
  final Color color;
  final bool completed;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // --------------------------------------------------
            // Category Color Indicator
            // --------------------------------------------------
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

            // --------------------------------------------------
            // Task Information
            // --------------------------------------------------
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
                      color: completed || overdue
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF0F172A),
                      decoration: completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: const Color(0xFF94A3B8),
                      decorationThickness: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Category
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

                      // Time Icon
                      const Icon(
                        Icons.access_time_outlined,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),

                      const SizedBox(width: 4),

                      // Time
                      Flexible(
                        child: Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
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

            // --------------------------------------------------
            // Complete Button
            // --------------------------------------------------
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
                    ? const Icon(
                        Icons.check,
                        color: AppColors.needthis,
                        size: 17,
                      )
                    : overdue
                    ? const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                        size: 17,
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}
