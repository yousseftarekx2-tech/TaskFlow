import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_flow/features/tasks/presentation/pages/create_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final TaskModel task;

  // ============================================================
  // CATEGORY COLOR
  // ============================================================

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

      default:
        return AppColors.needthis;
    }
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(DateTime date) {
    final int hour = date.hour;
    final int minute = date.minute;

    final String period = hour >= 12 ? 'PM' : 'AM';

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  String _statusText() {
    if (task.isCompleted) {
      return 'Completed';
    }

    if (task.isOverdue) {
      return 'Overdue';
    }

    return 'Pending';
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor() {
    if (task.isCompleted) {
      return AppColors.needthis;
    }

    if (task.isOverdue) {
      return const Color(0xFFEF4444);
    }

    return const Color(0xFF2563EB);
  }

  // ============================================================
  // EDIT TASK
  // ============================================================

  void _editTask(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CreateTaskScreen(task: task)));
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text(
            'Delete Task',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),

          content: const Text(
            'Are you sure you want to delete this task? '
            'This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF64748B),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    // ------------------------------------------------------------
    // DELETE FROM BLOC
    // ------------------------------------------------------------

    context.read<TaskBloc>().add(DeleteTask(task.id));

    if (!context.mounted) {
      return;
    }

    // ------------------------------------------------------------
    // CLOSE DETAILS AND RETURN HOME
    // ------------------------------------------------------------

    Navigator.of(context).pop();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = _categoryColor(task.category);
    final Color statusColor = _statusColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
        ),

        title: const Text(
          'Task Details',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE CARD
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 0.7,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 72,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: task.isCompleted || task.isOverdue
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF0F172A),
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              task.category,
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // STATUS
              // ==================================================
              _buildSectionLabel('Status'),

              const SizedBox(height: 9),

              _buildInfoCard(
                icon: task.isCompleted
                    ? Icons.check_circle_outline_rounded
                    : task.isOverdue
                    ? Icons.warning_amber_rounded
                    : Icons.radio_button_unchecked_rounded,
                iconColor: statusColor,
                title: _statusText(),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // DESCRIPTION
              // ==================================================
              _buildSectionLabel('Description'),

              const SizedBox(height: 9),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 0.7,
                  ),
                ),
                child: Text(
                  task.description.isEmpty
                      ? 'No description added.'
                      : task.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF475569),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // DATE
              // ==================================================
              _buildSectionLabel('Scheduled Date'),

              const SizedBox(height: 9),

              _buildInfoCard(
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.needthis,
                title: _formatDate(task.scheduledAt),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // TIME
              // ==================================================
              _buildInfoCard(
                icon: Icons.access_time_outlined,
                iconColor: AppColors.needthis,
                title: _formatTime(task.scheduledAt),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // EDIT BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _editTask(context);
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text(
                    'Edit Task',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.needthis,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // DELETE BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 19),
                  label: const Text(
                    'Delete Task',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION LABEL
  // ============================================================

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.7),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: iconColor),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
