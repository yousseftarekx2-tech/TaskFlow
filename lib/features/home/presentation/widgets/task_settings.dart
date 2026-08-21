import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/l10n/app_localizations.dart';
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

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: Text(
            l10n.deleteTask,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? const Color(0xFFF8FAFC)
                  : const Color(0xFF0F172A),
            ),
          ),

          content: Text(
            l10n.areYouSureDeleteTask,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF64748B),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF64748B),
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

              child: Text(
                l10n.delete,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    // ==========================================================
    // DELETE TASK
    // ==========================================================

    context.read<TaskBloc>().add(DeleteTask(task.id));

    if (!context.mounted) {
      return;
    }

    // ==========================================================
    // RETURN HOME
    // ==========================================================

    context.go(Routes.home);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final AppLocalizations l10n = AppLocalizations.of(context)!;

    // ============================================================
    // THEME COLORS
    // ============================================================

    final Color cardColor = isDark
        ? const Color(0xFF1E293B)
        : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color editTextColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF334155);

    final Color closeIconColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: borderColor,
          width: 0.6,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.20 : 0.04,
            ),
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

              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
              ),

              label: Text(
                l10n.edit,
              ),

              style: OutlinedButton.styleFrom(
                foregroundColor: editTextColor,

                side: BorderSide(
                  color: borderColor,
                ),

                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),

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

              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
              ),

              label: Text(
                l10n.delete,
              ),

              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),

                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF7F1D1D)
                      : const Color(0xFFFECACA),
                ),

                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),

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

            icon: Icon(
              Icons.close_rounded,
              size: 22,
              color: closeIconColor,
            ),

            tooltip: l10n.close,
          ),
        ],
      ),
    );
  }
}