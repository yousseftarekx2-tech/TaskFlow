import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/l10n/app_localizations.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final SettingsState settingsState = context.watch<SettingsCubit>().state;

    final bool isDarkMode = settingsState.darkModeEnabled;
    final TaskState taskState = context.watch<TaskBloc>().state;

    final Size screenSize = MediaQuery.sizeOf(context);
    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final List<TaskModel> allTasks = taskState is TaskLoaded
        ? taskState.tasks
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

    final int currentStreak = _calculateCurrentStreak(allTasks);

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isSmallWidth ? 16 : 20,
            isShortScreen ? 12 : 16,
            isSmallWidth ? 16 : 20,
            isShortScreen ? 20 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDarkMode, l10n, isSmallWidth),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildPeriodSelector(isDarkMode, l10n, isSmallWidth),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildSummaryGrid(
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                pendingTasks: pendingTasks,
                overdueTasks: overdueTasks,
                isDarkMode: isDarkMode,
                l10n: l10n,
                isSmallWidth: isSmallWidth,
              ),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildCompletionOverview(
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                pendingTasks: pendingTasks,
                overdueTasks: overdueTasks,
                isDarkMode: isDarkMode,
                l10n: l10n,
                isSmallWidth: isSmallWidth,
              ),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildWeeklyProductivity(
                allTasks,
                isDarkMode,
                l10n,
                isSmallWidth,
              ),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildCategories(
                context,
                filteredTasks,
                isDarkMode,
                l10n,
                isSmallWidth,
              ),
              SizedBox(height: isShortScreen ? 14 : 18),
              _buildInsights(
                filteredTasks,
                completionRate,
                currentStreak,
                isDarkMode,
                l10n,
                isSmallWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    bool isDarkMode,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.statistics,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 22 : 25,
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.trackYourProductivity,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(
    bool isDarkMode,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    return Row(
      children: [
        Expanded(
          child: _periodButton(
            title: l10n.week,
            period: StatsPeriod.week,
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
          ),
        ),
        SizedBox(width: isSmallWidth ? 6 : 8),
        Expanded(
          child: _periodButton(
            title: l10n.month,
            period: StatsPeriod.month,
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
          ),
        ),
        SizedBox(width: isSmallWidth ? 6 : 8),
        Expanded(
          child: _periodButton(
            title: l10n.year,
            period: StatsPeriod.year,
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
          ),
        ),
      ],
    );
  }

  Widget _periodButton({
    required String title,
    required StatsPeriod period,
    required bool isDarkMode,
    required bool isSmallWidth,
  }) {
    final bool selected = _selectedPeriod == period;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallWidth ? 8 : 15,
          vertical: isSmallWidth ? 7 : 8,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.needthis
              : isDarkMode
              ? const Color(0xFF1E293B)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.needthis
                : isDarkMode
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallWidth ? 10 : 11,
            fontWeight: FontWeight.w700,
            color: selected
                ? Colors.white
                : isDarkMode
                ? const Color(0xFFCBD5E1)
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryGrid({
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
    required int overdueTasks,
    required bool isDarkMode,
    required AppLocalizations l10n,
    required bool isSmallWidth,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: isSmallWidth ? 9 : 12,
      mainAxisSpacing: isSmallWidth ? 9 : 12,
      childAspectRatio: isSmallWidth ? 1.55 : 1.7,
      children: [
        _summaryCard(
          title: l10n.totalTasks,
          value: totalTasks,
          icon: Icons.checklist_rounded,
          iconColor: AppColors.needthis,
          isDarkMode: isDarkMode,
          isSmallWidth: isSmallWidth,
        ),
        _summaryCard(
          title: l10n.completed,
          value: completedTasks,
          icon: Icons.check_circle_outline_rounded,
          iconColor: _completedColor,
          isDarkMode: isDarkMode,
          isSmallWidth: isSmallWidth,
        ),
        _summaryCard(
          title: l10n.pending,
          value: pendingTasks,
          icon: Icons.schedule_rounded,
          iconColor: _pendingColor,
          isDarkMode: isDarkMode,
          isSmallWidth: isSmallWidth,
        ),
        _summaryCard(
          title: l10n.overdue,
          value: overdueTasks,
          icon: Icons.warning_amber_rounded,
          iconColor: _overdueColor,
          isDarkMode: isDarkMode,
          isSmallWidth: isSmallWidth,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required int value,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
    required bool isSmallWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallWidth ? 11 : 13),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: isSmallWidth ? 18 : 19, color: iconColor),
          const Spacer(),
          Text(
            '$value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isSmallWidth ? 18 : 20,
              fontWeight: FontWeight.w900,
              color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isSmallWidth ? 9 : 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionOverview({
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
    required int overdueTasks,
    required bool isDarkMode,
    required AppLocalizations l10n,
    required bool isSmallWidth,
  }) {
    final double completionRate = totalTasks == 0
        ? 0
        : completedTasks / totalTasks;

    final int percentage = (completionRate * 100).round();

    final double chartSize = isSmallWidth ? 125 : 150;

    return _sectionCard(
      title: l10n.completionOverview,
      isDarkMode: isDarkMode,
      isSmallWidth: isSmallWidth,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(
                      isSmallWidth ? 100 : 110,
                      isSmallWidth ? 100 : 110,
                    ),
                    painter: _TaskStatusChartPainter(
                      completed: completedTasks,
                      pending: pendingTasks,
                      overdue: overdueTasks,
                      backgroundColor: isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: isSmallWidth ? 18 : 20,
                          fontWeight: FontWeight.w900,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.completed,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 8 : 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF94A3B8),
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
              spacing: isSmallWidth ? 10 : 14,
              runSpacing: 8,
              children: [
                _legendItem(
                  color: _completedColor,
                  title: l10n.completed,
                  value: completedTasks,
                  total: totalTasks,
                  isDarkMode: isDarkMode,
                  isSmallWidth: isSmallWidth,
                ),
                _legendItem(
                  color: _pendingColor,
                  title: l10n.pending,
                  value: pendingTasks,
                  total: totalTasks,
                  isDarkMode: isDarkMode,
                  isSmallWidth: isSmallWidth,
                ),
                _legendItem(
                  color: _overdueColor,
                  title: l10n.overdue,
                  value: overdueTasks,
                  total: totalTasks,
                  isDarkMode: isDarkMode,
                  isSmallWidth: isSmallWidth,
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
    required bool isDarkMode,
    required bool isSmallWidth,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 9 : 10,
            fontWeight: FontWeight.w700,
            color: isDarkMode
                ? const Color(0xFFCBD5E1)
                : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProductivity(
    List<TaskModel> allTasks,
    bool isDarkMode,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final DateTime now = DateTime.now();
    final DateTime startOfWeek = _getStartOfWeek(now);

    final List<String> days = [
      l10n.sat,
      l10n.sun,
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
    ];

    final List<int> counts = List.generate(7, (index) {
      final DateTime day = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      ).add(Duration(days: index));

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
      title: l10n.weeklyProductivity,
      subtitle: l10n.tasksCompletedPerDay,
      isDarkMode: isDarkMode,
      isSmallWidth: isSmallWidth,
      child: Column(
        children: [
          const SizedBox(height: 18),
          SizedBox(
            height: isSmallWidth ? 135 : 145,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 8 : 9,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 5),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isSmallWidth ? 8 : 9,
                        height: maxValue == 0 ? 4 : (value / maxValue) * 85,
                        decoration: BoxDecoration(
                          color: AppColors.needthis,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        days[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 8 : 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
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

  Widget _buildCategories(
    BuildContext context,
    List<TaskModel> tasks,
    bool isDarkMode,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final Map<String, int> categoryCounts = {};

    for (final task in tasks) {
      categoryCounts[task.category] = (categoryCounts[task.category] ?? 0) + 1;
    }

    final List<MapEntry<String, int>> categories = categoryCounts.entries
        .toList();

    categories.sort((a, b) => b.value.compareTo(a.value));

    if (categories.isEmpty) {
      return _sectionCard(
        title: l10n.categories,
        isDarkMode: isDarkMode,
        isSmallWidth: isSmallWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            l10n.noCategoryDataAvailable,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isSmallWidth ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ),
      );
    }

    return _sectionCard(
      title: l10n.categories,
      isDarkMode: isDarkMode,
      isSmallWidth: isSmallWidth,
      child: Column(
        children: categories.take(5).map((entry) {
          final Color color = _categoryColor(context, entry.key);
          final int maxCount = categories.first.value;
          final double progress = maxCount == 0 ? 0 : entry.value / maxCount;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 10),
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
                  width: isSmallWidth ? 58 : 72,
                  child: Text(
                    entry.key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 10 : 11,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF334155),
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
                      backgroundColor: isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${entry.value} ${l10n.tasks}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 8 : 9,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsights(
    List<TaskModel> tasks,
    double completionRate,
    int currentStreak,
    bool isDarkMode,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    String mostProductiveDay = '—';
    String topCategory = '—';

    if (tasks.isNotEmpty) {
      final Map<int, int> dayCounts = {};

      for (final task in tasks) {
        if (!task.isCompleted) {
          continue;
        }

        final int weekday = task.scheduledAt.weekday;

        dayCounts[weekday] = (dayCounts[weekday] ?? 0) + 1;
      }

      if (dayCounts.isNotEmpty) {
        final int bestDay = dayCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;

        mostProductiveDay = _weekdayName(bestDay, l10n);
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
      title: l10n.insights,
      isDarkMode: isDarkMode,
      isSmallWidth: isSmallWidth,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: isSmallWidth ? 1.8 : 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          _insightItem(
            icon: Icons.emoji_events_outlined,
            title: l10n.mostProductive,
            value: mostProductiveDay,
            color: const Color(0xFFF59E0B),
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
          ),
          _insightItem(
            icon: Icons.category_outlined,
            title: l10n.topCategory,
            value: topCategory,
            color: AppColors.needthis,
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
          ),
          _insightItem(
            icon: Icons.check_circle_outline_rounded,
            title: l10n.completion,
            value: '${(completionRate * 100).round()}%',
            color: _completedColor,
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
          ),
          _insightItem(
            icon: Icons.local_fire_department_outlined,
            title: l10n.currentStreak,
            value: '$currentStreak ${l10n.days}',
            color: _pendingColor,
            isDarkMode: isDarkMode,
            isSmallWidth: isSmallWidth,
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
    required bool isDarkMode,
    required bool isSmallWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallWidth ? 8 : 9),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: isSmallWidth ? 20 : 23, color: color),
          SizedBox(width: isSmallWidth ? 5 : 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 10 : 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 10 : 11,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    String? subtitle,
    required Widget child,
    required bool isDarkMode,
    required bool isSmallWidth,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallWidth ? 12 : 14),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isSmallWidth ? 15 : 17,
              fontWeight: FontWeight.w800,
              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 9 : 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    final DateTime now = DateTime.now();

    switch (_selectedPeriod) {
      case StatsPeriod.week:
        final DateTime start = _getStartOfWeek(now);
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

  DateTime _getStartOfWeek(DateTime date) {
    final DateTime today = DateTime(date.year, date.month, date.day);

    final int daysSinceSaturday = (today.weekday - DateTime.saturday) % 7;

    return today.subtract(Duration(days: daysSinceSaturday));
  }

  int _calculateCurrentStreak(List<TaskModel> tasks) {
    final Set<DateTime> completedDays = {};

    for (final task in tasks) {
      if (!task.isCompleted) {
        continue;
      }

      final DateTime day = DateTime(
        task.scheduledAt.year,
        task.scheduledAt.month,
        task.scheduledAt.day,
      );

      completedDays.add(day);
    }

    if (completedDays.isEmpty) {
      return 0;
    }

    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    DateTime currentDay;

    if (completedDays.contains(today)) {
      currentDay = today;
    } else {
      final DateTime yesterday = today.subtract(const Duration(days: 1));

      if (!completedDays.contains(yesterday)) {
        return 0;
      }

      currentDay = yesterday;
    }

    int streak = 0;

    while (completedDays.contains(currentDay)) {
      streak++;
      currentDay = currentDay.subtract(const Duration(days: 1));
    }

    return streak;
  }

  String _weekdayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.monday;
      case DateTime.tuesday:
        return l10n.tuesday;
      case DateTime.wednesday:
        return l10n.wednesday;
      case DateTime.thursday:
        return l10n.thursday;
      case DateTime.friday:
        return l10n.friday;
      case DateTime.saturday:
        return l10n.saturday;
      case DateTime.sunday:
        return l10n.sunday;
      default:
        return '—';
    }
  }

  Color _categoryColor(BuildContext context, String categoryName) {
    final CategoryModel? category = context
        .read<CategoryCubit>()
        .getCategoryByName(categoryName);

    return category?.color ?? AppColors.needthis;
  }
}

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
        oldDelegate.overdue != overdue ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _ChartPart {
  final int value;
  final Color color;

  const _ChartPart({required this.value, required this.color});
}
