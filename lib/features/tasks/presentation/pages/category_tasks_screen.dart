import 'package:flutter/material.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';

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
    final Color categoryColor = _categoryColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF0F172A),
          ),
        ),

        title: Text(
          categoryName,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),

      body: SafeArea(
        child: tasks.isEmpty
            ? _buildEmptyState(categoryColor)
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(context, tasks[index], categoryColor);
                },
              ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(Color categoryColor) {
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
              'No tasks in $categoryName',
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tasks assigned to this category will appear here.',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF94A3B8),
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
    TaskModel task,
    Color categoryColor,
  ) {
    final bool completed = task.isCompleted;
    final bool overdue = task.isOverdue;

    final Color titleColor = completed || overdue
        ? const Color(0xFF94A3B8)
        : const Color(0xFF0F172A);

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.7),
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
                      color: const Color(0xFF94A3B8),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      _formatDateTime(task.scheduledAt),

                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
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

  String _formatDateTime(DateTime date) {
    final int hour = date.hour;

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    final String period = hour >= 12 ? 'PM' : 'AM';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} • '
        '$displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }
}
