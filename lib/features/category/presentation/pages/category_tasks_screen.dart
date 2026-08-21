import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';

class CategoryTasksScreen extends StatelessWidget {
  final String categoryName;

  const CategoryTasksScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final bool isDark =
            settingsState.darkModeEnabled;

        final AppLocalizations l10n =
            AppLocalizations.of(context)!;

        final Color backgroundColor = isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC);

        final Color cardColor = isDark
            ? const Color(0xFF1E293B)
            : Colors.white;

        final Color textColor = isDark
            ? Colors.white
            : const Color(0xFF0F172A);

        const Color secondaryTextColor =
            Color(0xFF94A3B8);

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,

            centerTitle: true,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 19,
                color: textColor,
              ),
            ),

            title: Text(
              categoryName,

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),

          body: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              if (taskState is TaskLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (taskState is TaskError) {
                return Center(
                  child: Text(
                    taskState.message,

                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                );
              }

              if (taskState is! TaskLoaded) {
                return const SizedBox.shrink();
              }

              final List<TaskModel> categoryTasks =
                  taskState.tasks
                      .where(
                        (task) =>
                            task.category
                                .trim()
                                .toLowerCase() ==
                            categoryName
                                .trim()
                                .toLowerCase(),
                      )
                      .toList();

              if (categoryTasks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          size: 55,
                          color: secondaryTextColor,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          l10n.noTasksInThisCategory,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          l10n.createTaskAndAssignToCategory(
                            categoryName,
                          ),

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 13,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  30,
                ),

                itemCount: categoryTasks.length,

                separatorBuilder: (_, __) {
                  return const SizedBox(height: 10);
                },

                itemBuilder: (context, index) {
                  final TaskModel task =
                      categoryTasks[index];

                  return _TaskCard(
                    task: task,
                    cardColor: cardColor,
                    textColor: textColor,
                    secondaryTextColor:
                        secondaryTextColor,
                    l10n: l10n,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ============================================================
// TASK CARD
// ============================================================

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final AppLocalizations l10n;

  const _TaskCard({
    required this.task,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),

              _StatusBadge(
                status: task.status,
                l10n: l10n,
              ),
            ],
          ),

          if (task.description
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 7),

            Text(
              task.description,

              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),
          ],

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 15,
                color: secondaryTextColor,
              ),

              const SizedBox(width: 5),

              Text(
                _formatDate(task.scheduledAt),

                style: TextStyle(
                  fontSize: 11,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ============================================================
// STATUS BADGE
// ============================================================

class _StatusBadge extends StatelessWidget {
  final TaskStatus status;
  final AppLocalizations l10n;

  const _StatusBadge({
    required this.status,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    late String text;
    late Color color;

    switch (status) {
      case TaskStatus.pending:
        text = l10n.pending;
        color = const Color(0xFF2563EB);
        break;

      case TaskStatus.completed:
        text = l10n.completed;
        color = const Color(0xFF16A34A);
        break;

      case TaskStatus.overdue:
        text = l10n.overdue;
        color = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}