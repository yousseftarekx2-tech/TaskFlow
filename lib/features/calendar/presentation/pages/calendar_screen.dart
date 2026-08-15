import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> tasks = state is TaskLoaded
        ? state.tasks
        : <TaskModel>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalendarCard(tasks),

                    const SizedBox(height: 24),

                    _buildTasksHeader(tasks),

                    const SizedBox(height: 12),

                    _buildTasks(tasks),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime.now();
                });
              },
              icon: const Icon(
                Icons.today_outlined,
                size: 20,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Calendar
  // ------------------------------------------------------------

  Widget _buildCalendarCard(List<TaskModel> tasks) {
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

    final int startingWeekday = firstDay.weekday;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.7),
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
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF64748B),
                ),
              ),

              Expanded(
                child: Text(
                  _monthName(_selectedDate.month),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
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
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              _WeekDay(title: 'Mon'),
              _WeekDay(title: 'Tue'),
              _WeekDay(title: 'Wed'),
              _WeekDay(title: 'Thu'),
              _WeekDay(title: 'Fri'),
              _WeekDay(title: 'Sat'),
              _WeekDay(title: 'Sun'),
            ],
          ),

          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: startingWeekday - 1 + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < startingWeekday - 1) {
                return const SizedBox();
              }

              final int day = index - (startingWeekday - 1) + 1;

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
                              : const Color(0xFF334155),
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

  Widget _buildTasksHeader(List<TaskModel> tasks) {
    final List<TaskModel> selectedTasks = _tasksForSelectedDate(tasks);

    return Row(
      children: [
        const Expanded(
          child: Text(
            'Tasks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ),

        Text(
          '${selectedTasks.length} tasks',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // Tasks
  // ------------------------------------------------------------

  Widget _buildTasks(List<TaskModel> allTasks) {
    final List<TaskModel> tasks = _tasksForSelectedDate(allTasks);

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 34,
              color: Color(0xFFCBD5E1),
            ),
            SizedBox(height: 8),
            Text(
              'No tasks for this day',
              style: TextStyle(
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
              child: _buildTaskCard(task),
            ),
          )
          .toList(),
    );
  }

  // ------------------------------------------------------------
  // READ-ONLY TASK CARD
  // ------------------------------------------------------------

  Widget _buildTaskCard(TaskModel task) {
    final Color taskColor = _categoryColor(task.category);

    final String taskTime = _formatTaskTime(task.scheduledAt);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Row(
        children: [
          // Status
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: task.isOverdue
                  ? const Color(0xFFFEF2F2)
                  : task.isCompleted
                  ? const Color(0xFFF0FDF4)
                  : taskColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              task.isOverdue
                  ? Icons.close_rounded
                  : task.isCompleted
                  ? Icons.check_rounded
                  : Icons.schedule_rounded,
              size: 21,
              color: task.isOverdue
                  ? const Color(0xFFEF4444)
                  : task.isCompleted
                  ? const Color(0xFF16A34A)
                  : taskColor,
            ),
          ),

          const SizedBox(width: 12),

          // Task information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: task.isCompleted
                        ? const Color(0xFF64748B)
                        : const Color(0xFF1E293B),
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
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      taskTime,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Read-only status
          if (task.isOverdue)
            const Text(
              'Overdue',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Color(0xFFEF4444),
              ),
            )
          else if (task.isCompleted)
            const Text(
              'Completed',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16A34A),
              ),
            )
          else
            const Text(
              'Pending',
              style: TextStyle(
                fontSize: 9,
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

  String _monthName(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}
