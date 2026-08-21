import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/l10n/app_localizations.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({required this.title, required this.isDark});

  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _selectedDate = DateTime.now();
  String _weekDayName(String arabicOrEnglishName, String englishShortName) {
    final String languageCode = Localizations.localeOf(context).languageCode;

    if (languageCode == 'en') {
      return englishShortName;
    }

    return arabicOrEnglishName;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks = state is TaskLoaded
        ? state.tasks
        : <TaskModel>[];

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark, l10n),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalendarCard(tasks, isDark, l10n),

                    const SizedBox(height: 24),

                    _buildTasksHeader(tasks, isDark, l10n),

                    const SizedBox(height: 12),

                    _buildTasks(tasks, isDark, l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Header
  // ------------------------------------------------------------

  Widget _buildHeader(bool isDark, AppLocalizations l10n) {
    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color iconColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.calendar,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime.now();
                });
              },
              icon: Icon(Icons.today_outlined, size: 20, color: iconColor),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Calendar
  // ------------------------------------------------------------

  Widget _buildCalendarCard(
    List<TaskModel> tasks,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final DateTime firstDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );

    final int daysInMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    ).day;

    // Dart:
    // Monday = 1
    // Tuesday = 2
    // ...
    // Saturday = 6
    // Sunday = 7
    //
    // We want:
    // Saturday = first column
    // Sunday = second column
    // Monday = third column
    //
    // Therefore we shift the weekday so Saturday becomes 0.
    final int startingWeekday = (firstDay.weekday + 1) % 7;

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final Color dayTextColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF334155);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month - 1,
                      1,
                    );
                  });
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: secondaryTextColor,
                ),
              ),

              Expanded(
                child: Text(
                  _monthName(_selectedDate.month, l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month + 1,
                      1,
                    );
                  });
                },
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Saturday → Sunday → Monday → Tuesday
          // → Wednesday → Thursday → Friday
          Row(
            children: [
              _WeekDay(title: _weekDayName(l10n.sat, 'Sat'), isDark: isDark),
              _WeekDay(title: _weekDayName(l10n.sun, 'Sun'), isDark: isDark),
              _WeekDay(title: _weekDayName(l10n.mon, 'Mon'), isDark: isDark),
              _WeekDay(title: _weekDayName(l10n.tue, 'Tue'), isDark: isDark),
              _WeekDay(title: _weekDayName(l10n.wed, 'Wed'), isDark: isDark),
              _WeekDay(title: _weekDayName(l10n.thu, 'Thu'), isDark: isDark),
              _WeekDay(title: _weekDayName(l10n.fri, 'Fri'), isDark: isDark),
            ],
          ),

          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: startingWeekday + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < startingWeekday) {
                return const SizedBox();
              }

              final int day = index - startingWeekday + 1;

              final DateTime today = DateTime.now();

              final bool isToday =
                  day == today.day &&
                  _selectedDate.month == today.month &&
                  _selectedDate.year == today.year;

              final bool selected =
                  day == _selectedDate.day &&
                  _selectedDate.month == firstDay.month &&
                  _selectedDate.year == firstDay.year;

              final bool hasTask = tasks.any(
                (task) =>
                    task.scheduledAt.year == _selectedDate.year &&
                    task.scheduledAt.month == _selectedDate.month &&
                    task.scheduledAt.day == day,
              );

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      day,
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selected ? AppColors.needthis : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !selected
                        ? Border.all(color: AppColors.needthis, width: 1.5)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected || isToday
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: selected
                              ? Colors.white
                              : isToday
                              ? AppColors.needthis
                              : dayTextColor,
                        ),
                      ),

                      if (hasTask && !selected)
                        Positioned(
                          bottom: 2,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.needthis,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Tasks Header
  // ------------------------------------------------------------

  Widget _buildTasksHeader(
    List<TaskModel> tasks,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final List<TaskModel> selectedTasks = _tasksForSelectedDate(tasks);

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = const Color(0xFF94A3B8);

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.tasks,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: primaryTextColor,
            ),
          ),
        ),

        Text(
          l10n.taskCount(selectedTasks.length),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // Tasks
  // ------------------------------------------------------------

  Widget _buildTasks(
    List<TaskModel> allTasks,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final List<TaskModel> tasks = _tasksForSelectedDate(allTasks);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 34,
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.noTasksForThisDay,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    tasks.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTaskCard(task, isDark, l10n),
            ),
          )
          .toList(),
    );
  }

  // ------------------------------------------------------------
  // READ-ONLY TASK CARD
  // ------------------------------------------------------------

  Widget _buildTaskCard(TaskModel task, bool isDark, AppLocalizations l10n) {
    final Color taskColor = _categoryColor(task.category);

    final String taskTime = _formatTaskTime(task.scheduledAt);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color titleColor = task.isCompleted
        ? const Color(0xFF64748B)
        : isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF1E293B);

    final Color secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final Color timeColor = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        children: [
          // ======================================================
          // STATUS
          // ======================================================
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: task.isOverdue
                  ? (isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2))
                  : task.isCompleted
                  ? (isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4))
                  : taskColor.withValues(alpha: isDark ? 0.16 : 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              task.isOverdue
                  ? Icons.close_rounded
                  : task.isCompleted
                  ? Icons.check_rounded
                  : Icons.schedule_rounded,
              size: 23,
              color: task.isOverdue
                  ? const Color(0xFFEF4444)
                  : task.isCompleted
                  ? const Color(0xFF16A34A)
                  : taskColor,
            ),
          ),

          const SizedBox(width: 12),

          // ======================================================
          // TASK INFORMATION
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: taskColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Flexible(
                      child: Text(
                        task.category,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Icon(Icons.access_time_rounded, size: 13, color: timeColor),

                    const SizedBox(width: 3),

                    Text(
                      taskTime,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: timeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ======================================================
          // READ-ONLY STATUS
          // ======================================================
          if (task.isOverdue)
            Text(
              l10n.overdue,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFFEF4444),
              ),
            )
          else if (task.isCompleted)
            Text(
              l10n.completed,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16A34A),
              ),
            )
          else
            Text(
              l10n.pending,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFFF97316),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Filter Tasks By Selected Date
  // ------------------------------------------------------------

  List<TaskModel> _tasksForSelectedDate(List<TaskModel> tasks) {
    return tasks.where((task) {
      return task.scheduledAt.year == _selectedDate.year &&
          task.scheduledAt.month == _selectedDate.month &&
          task.scheduledAt.day == _selectedDate.day;
    }).toList();
  }

  // ------------------------------------------------------------
  // Format Time
  // ------------------------------------------------------------

  String _formatTaskTime(DateTime scheduledAt) {
    final TimeOfDay time = TimeOfDay.fromDateTime(scheduledAt);

    return time.format(context);
  }

  // ------------------------------------------------------------
  // Category Colors
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // Month Name
  // ------------------------------------------------------------

  String _monthName(int month, AppLocalizations l10n) {
    switch (month) {
      case 1:
        return l10n.january;

      case 2:
        return l10n.february;

      case 3:
        return l10n.march;

      case 4:
        return l10n.april;

      case 5:
        return l10n.may;

      case 6:
        return l10n.june;

      case 7:
        return l10n.july;

      case 8:
        return l10n.august;

      case 9:
        return l10n.september;

      case 10:
        return l10n.october;

      case 11:
        return l10n.november;

      case 12:
        return l10n.december;

      default:
        return '';
    }
  }
}
