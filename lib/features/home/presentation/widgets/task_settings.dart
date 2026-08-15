import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/routing/routes.dart';

import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';

class TaskSettings extends StatelessWidget {
  const TaskSettings({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onCancel,
    required Null Function() onDelete,
  });

  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

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
            'Are you sure you want to delete this task? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
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

    context.read<TaskBloc>().add(DeleteTask(task.id));

    if (!context.mounted) {
      return;
    }

    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.6),

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
          // ======================================================
          // EDIT
          // ======================================================
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,

              icon: const Icon(Icons.edit_outlined, size: 18),

              label: const Text('Edit'),

              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF334155),

                side: const BorderSide(color: Color(0xFFE2E8F0)),

                padding: const EdgeInsets.symmetric(vertical: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ======================================================
          // DELETE
          // ======================================================
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _showDeleteConfirmation(context);
              },

              icon: const Icon(Icons.delete_outline_rounded, size: 18),

              label: const Text('Delete'),

              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),

                side: const BorderSide(color: Color(0xFFFECACA)),

                padding: const EdgeInsets.symmetric(vertical: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // ======================================================
          // CLOSE
          // ======================================================
          IconButton(
            onPressed: onCancel,

            icon: const Icon(
              Icons.close_rounded,
              size: 22,
              color: Color(0xFF64748B),
            ),

            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}
