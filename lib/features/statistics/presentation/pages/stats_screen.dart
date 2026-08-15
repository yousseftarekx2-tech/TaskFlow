import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

enum StatsPeriod { week, month, year }

class _StatsScreenState extends State<StatsScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.week;

  static const Color _completedColor = Color(0xFF16A34A);
  static const Color _pendingColor = Color(0xFFF97316);
  static const Color _overdueColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskBloc>().state;

    final List<TaskModel> allTasks = state is TaskLoaded
        ? state.tasks
        : <TaskModel>[];

    final List<TaskModel> filteredTasks = _filterTasks(allTasks);

    final int totalTasks = filteredTasks.length;

    final int completedTasks = filteredTasks
        .where((task) => task.isCompleted)
        .length;

    final int pendingTasks = filteredTasks
        .where((task) => task.isPending)
        .length;

    final int overdueTasks = filteredTasks
        .where((task) => task.isOverdue)
        .length;

    final double completionRate = totalTasks == 0
        ? 0
        : completedTasks / totalTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 18),

              _buildPeriodSelector(),

              const SizedBox(height: 18),

              _buildSummaryGrid(
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                pendingTasks: pendingTasks,
                overdueTasks: overdueTasks,
              ),

              const SizedBox(height: 18),

              _buildCompletionOverview(
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                pendingTasks: pendingTasks,
                overdueTasks: overdueTasks,
              ),

              const SizedBox(height: 18),

              _buildWeeklyProductivity(allTasks),

              const SizedBox(height: 18),

              _buildCategories(filteredTasks),

              const SizedBox(height: 18),

              _buildInsights(filteredTasks, completionRate),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Track your productivity',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PERIOD SELECTOR
  // ============================================================

  Widget _buildPeriodSelector() {
    return Row(
      children: [
        _periodButton(title: 'Week', period: StatsPeriod.week),
        const SizedBox(width: 8),
        _periodButton(title: 'Month', period: StatsPeriod.month),
        const SizedBox(width: 8),
        _periodButton(title: 'Year', period: StatsPeriod.year),
      ],
    );
  }

  Widget _periodButton({required String title, required StatsPeriod period}) {
    final bool selected = _selectedPeriod == period;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.needthis : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.needthis : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARDS
  // ============================================================

  Widget _buildSummaryGrid({
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
    required int overdueTasks,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _summaryCard(
          title: 'Total Tasks',
          value: totalTasks,
          icon: Icons.checklist_rounded,
          iconColor: AppColors.needthis,
        ),
        _summaryCard(
          title: 'Completed',
          value: completedTasks,
          icon: Icons.check_circle_outline_rounded,
          iconColor: _completedColor,
        ),
        _summaryCard(
          title: 'Pending',
          value: pendingTasks,
          icon: Icons.schedule_rounded,
          iconColor: _pendingColor,
        ),
        _summaryCard(
          title: 'Overdue',
          value: overdueTasks,
          icon: Icons.warning_amber_rounded,
          iconColor: _overdueColor,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required int value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: iconColor),
          const Spacer(),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPLETION OVERVIEW
  // ============================================================

  Widget _buildCompletionOverview({
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
    required int overdueTasks,
  }) {
    final double completionRate = totalTasks == 0
        ? 0
        : completedTasks / totalTasks;

    final int percentage = (completionRate * 100).round();

    return _sectionCard(
      title: 'Completion Overview',
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 8),

            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(110, 110),
                    painter: _TaskStatusChartPainter(
                      completed: completedTasks,
                      pending: pendingTasks,
                      overdue: overdueTasks,
                      backgroundColor: const Color(0xFFE2E8F0),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 8,
              children: [
                _legendItem(
                  color: _completedColor,
                  title: 'Completed',
                  value: completedTasks,
                  total: totalTasks,
                ),
                _legendItem(
                  color: _pendingColor,
                  title: 'Pending',
                  value: pendingTasks,
                  total: totalTasks,
                ),
                _legendItem(
                  color: _overdueColor,
                  title: 'Overdue',
                  value: overdueTasks,
                  total: totalTasks,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem({
    required Color color,
    required String title,
    required int value,
    required int total,
  }) {
    final int percentage = total == 0 ? 0 : ((value / total) * 100).round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$title $percentage%',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WEEKLY PRODUCTIVITY
  // ============================================================

  Widget _buildWeeklyProductivity(List<TaskModel> allTasks) {
    final DateTime now = DateTime.now();

    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final List<int> counts = List.generate(7, (index) {
      final DateTime day = now.subtract(
        Duration(days: now.weekday - 1 - index),
      );

      return allTasks.where((task) {
        return task.scheduledAt.year == day.year &&
            task.scheduledAt.month == day.month &&
            task.scheduledAt.day == day.day &&
            task.isCompleted;
      }).length;
    });

    final int maxValue = counts.isEmpty
        ? 1
        : counts.reduce((a, b) => a > b ? a : b);

    return _sectionCard(
      title: 'Weekly Productivity',
      subtitle: 'Tasks completed per day',
      child: Column(
        children: [
          const SizedBox(height: 18),

          SizedBox(
            height: 145,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final int value = counts[index];

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 5),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 9,
                        height: maxValue == 0 ? 4 : (value / maxValue) * 85,
                        decoration: BoxDecoration(
                          color: AppColors.needthis,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        days[index],
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategories(List<TaskModel> tasks) {
    final Map<String, int> categoryCounts = {};

    for (final task in tasks) {
      categoryCounts[task.category] = (categoryCounts[task.category] ?? 0) + 1;
    }

    final List<MapEntry<String, int>> categories = categoryCounts.entries
        .toList();

    categories.sort((a, b) => b.value.compareTo(a.value));

    if (categories.isEmpty) {
      return _sectionCard(
        title: 'Categories',
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'No category data available',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
      );
    }

    return _sectionCard(
      title: 'Categories',
      child: Column(
        children: categories.take(5).map((entry) {
          final Color color = _categoryColor(entry.key);

          final int maxCount = categories.first.value;

          final double progress = maxCount == 0 ? 0 : entry.value / maxCount;

          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Text(
                    entry.key,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE2E8F0),
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${entry.value} tasks',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // INSIGHTS
  // ============================================================

  Widget _buildInsights(List<TaskModel> tasks, double completionRate) {
    String mostProductiveDay = '—';
    String topCategory = '—';

    if (tasks.isNotEmpty) {
      final Map<int, int> dayCounts = {};

      for (final task in tasks) {
        final int weekday = task.scheduledAt.weekday;

        dayCounts[weekday] = (dayCounts[weekday] ?? 0) + 1;
      }

      if (dayCounts.isNotEmpty) {
        final int bestDay = dayCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;

        mostProductiveDay = _weekdayName(bestDay);
      }

      final Map<String, int> categories = {};

      for (final task in tasks) {
        categories[task.category] = (categories[task.category] ?? 0) + 1;
      }

      if (categories.isNotEmpty) {
        topCategory = categories.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;
      }
    }

    return _sectionCard(
      title: 'Insights',
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          _insightItem(
            icon: Icons.emoji_events_outlined,
            title: 'Most Productive',
            value: mostProductiveDay,
            color: const Color(0xFFF59E0B),
          ),
          _insightItem(
            icon: Icons.category_outlined,
            title: 'Top Category',
            value: topCategory,
            color: AppColors.needthis,
          ),
          _insightItem(
            icon: Icons.check_circle_outline_rounded,
            title: 'Completion',
            value: '${(completionRate * 100).round()}%',
            color: _completedColor,
          ),
          _insightItem(
            icon: Icons.local_fire_department_outlined,
            title: 'Current Streak',
            value: '—',
            color: _pendingColor,
          ),
        ],
      ),
    );
  }

  Widget _insightItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    final DateTime now = DateTime.now();

    switch (_selectedPeriod) {
      case StatsPeriod.week:
        final DateTime startOfWeek = now.subtract(
          Duration(days: now.weekday - 1),
        );

        final DateTime start = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );

        final DateTime end = start.add(const Duration(days: 7));

        return tasks.where((task) {
          return !task.scheduledAt.isBefore(start) &&
              task.scheduledAt.isBefore(end);
        }).toList();

      case StatsPeriod.month:
        return tasks.where((task) {
          return task.scheduledAt.year == now.year &&
              task.scheduledAt.month == now.month;
        }).toList();

      case StatsPeriod.year:
        return tasks.where((task) {
          return task.scheduledAt.year == now.year;
        }).toList();
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _weekdayName(int weekday) {
    const List<String> names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return names[weekday - 1];
  }

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

      case 'Learning':
        return const Color(0xFFF97316);

      default:
        return AppColors.needthis;
    }
  }
}

// ============================================================
// TASK STATUS DONUT CHART
// ============================================================

class _TaskStatusChartPainter extends CustomPainter {
  final int completed;
  final int pending;
  final int overdue;
  final Color backgroundColor;

  const _TaskStatusChartPainter({
    required this.completed,
    required this.pending,
    required this.overdue,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = (completed + pending + overdue).toDouble();

    final Offset center = Offset(size.width / 2, size.height / 2);

    final double radius = math.min(size.width, size.height) / 2;

    const double strokeWidth = 10;

    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);

    if (total == 0) {
      return;
    }

    final List<_ChartPart> parts = [
      _ChartPart(value: completed, color: const Color(0xFF16A34A)),
      _ChartPart(value: pending, color: const Color(0xFFF97316)),
      _ChartPart(value: overdue, color: const Color(0xFFEF4444)),
    ];

    double startAngle = -math.pi / 2;

    for (final part in parts) {
      if (part.value <= 0) {
        continue;
      }

      final double sweepAngle = (part.value / total) * math.pi * 2;

      final Paint paint = Paint()
        ..color = part.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _TaskStatusChartPainter oldDelegate) {
    return oldDelegate.completed != completed ||
        oldDelegate.pending != pending ||
        oldDelegate.overdue != overdue;
  }
}

class _ChartPart {
  final int value;
  final Color color;

  const _ChartPart({required this.value, required this.color});
}
