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
  });

  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isSmallWidth = MediaQuery.sizeOf(context).width < 360;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          titlePadding: EdgeInsets.fromLTRB(isSmallWidth ? 18 : 24, 18, 10, 8),
          contentPadding: EdgeInsets.fromLTRB(
            isSmallWidth ? 18 : 24,
            4,
            isSmallWidth ? 18 : 24,
            8,
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            isSmallWidth ? 18 : 24,
            4,
            isSmallWidth ? 18 : 24,
            16,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.deleteTask,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 17 : 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.close_rounded,
                  size: 21,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          content: Text(
            l10n.areYouSureDeleteTask,
            style: TextStyle(
              fontSize: isSmallWidth ? 13 : 14,
              height: 1.4,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: isSmallWidth ? 46 : 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallWidth ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  l10n.delete,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 12 : 13,
                    fontWeight: FontWeight.w700,
                  ),
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

    context.read<TaskBloc>().add(DeleteTask(task.id));

    if (!context.mounted) {
      return;
    }

    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isDark = theme.brightness == Brightness.dark;
    final bool isSmallWidth = screenSize.width < 360;

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

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
      padding: EdgeInsets.fromLTRB(
        isSmallWidth ? 12 : 16,
        isSmallWidth ? 12 : 16,
        isSmallWidth ? 6 : 8,
        isSmallWidth ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: Icon(Icons.edit_outlined, size: isSmallWidth ? 16 : 18),
              label: Text(
                l10n.edit,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: editTextColor,
                side: BorderSide(color: borderColor),
                padding: EdgeInsets.symmetric(
                  vertical: isSmallWidth ? 10 : 12,
                  horizontal: isSmallWidth ? 6 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: isSmallWidth ? 7 : 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                size: isSmallWidth ? 16 : 18,
              ),
              label: Text(
                l10n.delete,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF7F1D1D)
                      : const Color(0xFFFECACA),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isSmallWidth ? 10 : 12,
                  horizontal: isSmallWidth ? 6 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: isSmallWidth ? 2 : 6),
          IconButton(
            onPressed: onCancel,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: isSmallWidth ? 34 : 40,
              minHeight: isSmallWidth ? 34 : 40,
            ),
            icon: Icon(
              Icons.close_rounded,
              size: isSmallWidth ? 20 : 22,
              color: closeIconColor,
            ),
            tooltip: l10n.close,
          ),
        ],
      ),
    );
  }
}
