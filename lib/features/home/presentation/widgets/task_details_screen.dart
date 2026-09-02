import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_flow/features/tasks/presentation/pages/create_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key, required this.task});

  final TaskModel task;

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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatTime(DateTime date) {
    final int hour = date.hour;
    final int minute = date.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _statusText(AppLocalizations l10n) {
    if (task.isCompleted) {
      return l10n.completed;
    }

    if (task.isOverdue) {
      return l10n.overdue;
    }

    return l10n.pending;
  }

  Color _statusColor() {
    if (task.isCompleted) {
      return AppColors.needthis;
    }

    if (task.isOverdue) {
      return const Color(0xFFEF4444);
    }

    return const Color(0xFF2563EB);
  }

  void _editTask(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CreateTaskScreen(task: task)));
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isSmallWidth = MediaQuery.sizeOf(context).width < 360;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.brightness == Brightness.dark
              ? const Color(0xFF1E293B)
              : Colors.white,
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
                  l10n.deleteTaskTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 17 : 18,
                    fontWeight: FontWeight.w700,
                    color: theme.brightness == Brightness.dark
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
            l10n.deleteTaskConfirmation,
            style: TextStyle(
              fontSize: isSmallWidth ? 13 : 14,
              height: 1.45,
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF64748B),
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
                  l10n.deleteTask,
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

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF475569);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color categoryColor = _categoryColor(task.category);
    final Color statusColor = _statusColor();

    final double horizontalPadding = isSmallWidth ? 16 : 20;
    final double topPadding = isShortScreen ? 8 : 12;
    final double bottomPadding = isShortScreen ? 22 : 30;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: isSmallWidth ? 17 : 18,
            color: primaryTextColor,
          ),
        ),
        title: Text(
          l10n.taskDetails,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 18 : 19,
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallWidth ? 16 : 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: 0.7),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: isSmallWidth ? 64 : 72,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(width: isSmallWidth ? 12 : 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallWidth ? 19 : 21,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                              color: task.isCompleted || task.isOverdue
                                  ? (isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8))
                                  : primaryTextColor,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: isSmallWidth ? 150 : 180,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallWidth ? 9 : 10,
                              vertical: isSmallWidth ? 5 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              task.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: isSmallWidth ? 11 : 12,
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
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildSectionLabel(l10n.status, isDark, isSmallWidth),
              const SizedBox(height: 9),
              _buildInfoCard(
                icon: task.isCompleted
                    ? Icons.check_circle_outline_rounded
                    : task.isOverdue
                    ? Icons.warning_amber_rounded
                    : Icons.radio_button_unchecked_rounded,
                iconColor: statusColor,
                title: _statusText(l10n),
                isDark: isDark,
                isSmallWidth: isSmallWidth,
              ),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildSectionLabel(l10n.description, isDark, isSmallWidth),
              const SizedBox(height: 9),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallWidth ? 14 : 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 0.7),
                ),
                child: Text(
                  task.description.isEmpty
                      ? l10n.noDescriptionAdded
                      : task.description,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 13 : 14,
                    height: 1.5,
                    color: secondaryTextColor,
                  ),
                ),
              ),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildSectionLabel(l10n.scheduledDate, isDark, isSmallWidth),
              const SizedBox(height: 9),
              _buildInfoCard(
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.needthis,
                title: _formatDate(task.scheduledAt),
                isDark: isDark,
                isSmallWidth: isSmallWidth,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.access_time_outlined,
                iconColor: AppColors.needthis,
                title: _formatTime(task.scheduledAt),
                isDark: isDark,
                isSmallWidth: isSmallWidth,
              ),
              SizedBox(height: isShortScreen ? 22 : 28),
              SizedBox(
                width: double.infinity,
                height: isSmallWidth ? 48 : 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _editTask(context);
                  },
                  icon: Icon(Icons.edit_outlined, size: isSmallWidth ? 17 : 18),
                  label: Text(
                    l10n.editTask,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 13 : 14,
                      fontWeight: FontWeight.w700,
                    ),
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
              SizedBox(
                width: double.infinity,
                height: isSmallWidth ? 48 : 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context, l10n);
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: isSmallWidth ? 18 : 19,
                  ),
                  label: Text(
                    l10n.deleteTask,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 13 : 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF7F1D1D)
                          : const Color(0xFFFECACA),
                    ),
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

  Widget _buildSectionLabel(String text, bool isDark, bool isSmallWidth) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: isSmallWidth ? 13 : 14,
        fontWeight: FontWeight.w700,
        color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isDark,
    required bool isSmallWidth,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 52),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallWidth ? 13 : 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 0.7,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: isSmallWidth ? 18 : 19, color: iconColor),
          SizedBox(width: isSmallWidth ? 9 : 11),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFF8FAFC)
                    : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
