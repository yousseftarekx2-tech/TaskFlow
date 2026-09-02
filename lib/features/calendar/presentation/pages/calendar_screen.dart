import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';

import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({
    required this.title,
    required this.isDark,
    required this.fontSize,
  });

  final String title;
  final bool isDark;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
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

  Color _categoryColor(BuildContext context, String categoryName) {
    final CategoryModel? category = context
        .read<CategoryCubit>()
        .getCategoryByName(categoryName);

    return category?.color ?? AppColors.needthis;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final TaskState state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks = state is TaskLoaded
        ? state.tasks
        : <TaskModel>[];

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallWidth = constraints.maxWidth < 360;
            final bool isShortHeight = constraints.maxHeight < 700;

            final double horizontalPadding = isSmallWidth ? 16 : 20;

            return Column(
              children: [
                _buildHeader(isDark, l10n, isSmallWidth),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      isSmallWidth ? 8 : 10,
                      horizontalPadding,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCalendarCard(tasks, isDark, l10n, isSmallWidth),
                        SizedBox(
                          height: isShortHeight
                              ? 20
                              : isSmallWidth
                              ? 22
                              : 24,
                        ),
                        _buildTasksHeader(tasks, isDark, l10n, isSmallWidth),
                        SizedBox(height: isSmallWidth ? 10 : 12),
                        _buildTasks(tasks, isDark, l10n, isSmallWidth),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, AppLocalizations l10n, bool isSmallWidth) {
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
      padding: EdgeInsets.fromLTRB(
        isSmallWidth ? 16 : 20,
        isSmallWidth ? 12 : 16,
        isSmallWidth ? 16 : 20,
        isSmallWidth ? 8 : 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.calendar,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 22 : 24,
                fontWeight: FontWeight.w800,
                color: primaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: isSmallWidth ? 40 : 42,
            height: isSmallWidth ? 40 : 42,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                },
                icon: Icon(
                  Icons.today_outlined,
                  size: isSmallWidth ? 19 : 20,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(
    List<TaskModel> tasks,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
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
      padding: EdgeInsets.fromLTRB(
        isSmallWidth ? 10 : 16,
        isSmallWidth ? 14 : 18,
        isSmallWidth ? 10 : 16,
        isSmallWidth ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
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
              ),
              Expanded(
                child: Text(
                  _monthName(_selectedDate.month, l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 16 : 17,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
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
              ),
            ],
          ),
          SizedBox(height: isSmallWidth ? 8 : 12),
          Row(
            children: [
              _WeekDay(
                title: _weekDayName(l10n.sat, 'Sat'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
              _WeekDay(
                title: _weekDayName(l10n.sun, 'Sun'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
              _WeekDay(
                title: _weekDayName(l10n.mon, 'Mon'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
              _WeekDay(
                title: _weekDayName(l10n.tue, 'Tue'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
              _WeekDay(
                title: _weekDayName(l10n.wed, 'Wed'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
              _WeekDay(
                title: _weekDayName(l10n.thu, 'Thu'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
              _WeekDay(
                title: _weekDayName(l10n.fri, 'Fri'),
                isDark: isDark,
                fontSize: isSmallWidth ? 10 : 12,
              ),
            ],
          ),
          SizedBox(height: isSmallWidth ? 6 : 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: startingWeekday + daysInMonth,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: isSmallWidth ? 5 : 8,
              crossAxisSpacing: isSmallWidth ? 2 : 4,
              childAspectRatio: isSmallWidth ? 1.05 : 1,
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

              final List<TaskModel> dayTasks = tasks.where((task) {
                return task.scheduledAt.year == _selectedDate.year &&
                    task.scheduledAt.month == _selectedDate.month &&
                    task.scheduledAt.day == day;
              }).toList();

              final bool hasTask = dayTasks.isNotEmpty;

              final Color taskCategoryColor = hasTask
                  ? _categoryColor(context, dayTasks.first.category)
                  : AppColors.needthis;

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
                          fontSize: isSmallWidth ? 12 : 13,
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
                          bottom: isSmallWidth ? 1 : 2,
                          child: Container(
                            width: isSmallWidth ? 3.5 : 4,
                            height: isSmallWidth ? 3.5 : 4,
                            decoration: BoxDecoration(
                              color: taskCategoryColor,
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

  Widget _buildTasksHeader(
    List<TaskModel> tasks,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final List<TaskModel> selectedTasks = _tasksForSelectedDate(tasks);

    final Color primaryTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);

    const Color secondaryTextColor = Color(0xFF94A3B8);

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.tasks,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isSmallWidth ? 17 : 18,
              fontWeight: FontWeight.w800,
              color: primaryTextColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.taskCount(selectedTasks.length),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTasks(
    List<TaskModel> allTasks,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final List<TaskModel> tasks = _tasksForSelectedDate(allTasks);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isSmallWidth ? 24 : 28),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: isSmallWidth ? 30 : 34,
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l10n.noTasksForThisDay,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 12 : 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
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
              child: _buildTaskCard(task, isDark, l10n, isSmallWidth),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTaskCard(
    TaskModel task,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final Color taskColor = _categoryColor(context, task.category);

    final String taskTime = _formatTaskTime(task.scheduledAt);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color titleColor = task.isCompleted || task.isOverdue
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
      padding: EdgeInsets.all(isSmallWidth ? 12 : 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: isSmallWidth ? 36 : 40,
            height: isSmallWidth ? 36 : 40,
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
              size: isSmallWidth ? 20 : 23,
              color: task.isOverdue
                  ? const Color(0xFFEF4444)
                  : task.isCompleted
                  ? const Color(0xFF16A34A)
                  : taskColor,
            ),
          ),
          SizedBox(width: isSmallWidth ? 9 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 14 : 16,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 12 : 13,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallWidth ? 5 : 8),
                    Icon(Icons.access_time_rounded, size: 13, color: timeColor),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        taskTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: timeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallWidth ? 8 : 12),
          _buildStatusText(
            task.isOverdue
                ? l10n.overdue
                : task.isCompleted
                ? l10n.completed
                : l10n.pending,
            task.isOverdue
                ? const Color(0xFFEF4444)
                : task.isCompleted
                ? const Color(0xFF16A34A)
                : const Color(0xFFF97316),
            isSmallWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(String text, Color color, bool isSmallWidth) {
    return SizedBox(
      width: isSmallWidth ? 54 : 64,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: isSmallWidth ? 9 : 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  List<TaskModel> _tasksForSelectedDate(List<TaskModel> tasks) {
    return tasks.where((task) {
      return task.scheduledAt.year == _selectedDate.year &&
          task.scheduledAt.month == _selectedDate.month &&
          task.scheduledAt.day == _selectedDate.day;
    }).toList();
  }

  String _formatTaskTime(DateTime scheduledAt) {
    final TimeOfDay time = TimeOfDay.fromDateTime(scheduledAt);

    return time.format(context);
  }

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
