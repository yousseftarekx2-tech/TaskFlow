import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/widgets/notification_icon_button.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import '../cubit/focus_cubit.dart';
import '../cubit/focus_state.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusCubit, FocusState>(
      builder: (context, state) {
        final ThemeData theme = Theme.of(context);
        final AppLocalizations l10n = AppLocalizations.of(context)!;

        final bool isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF8FAFC),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isSmallWidth = constraints.maxWidth < 360;
                final bool isShortHeight = constraints.maxHeight < 700;

                final double horizontalPadding = isSmallWidth ? 16 : 20;

                final double topPadding = isShortHeight
                    ? 16
                    : isSmallWidth
                    ? 20
                    : 24;

                final double headerSpacing = isShortHeight
                    ? 20
                    : isSmallWidth
                    ? 24
                    : 30;

                final double sectionSpacing = isShortHeight
                    ? 16
                    : isSmallWidth
                    ? 18
                    : 20;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    topPadding,
                    horizontalPadding,
                    30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, isDark, l10n, isSmallWidth),
                      SizedBox(height: headerSpacing),
                      _buildTimer(state, isDark, l10n, isSmallWidth),
                      SizedBox(height: sectionSpacing),
                      _buildTimerControls(
                        context,
                        state,
                        isDark,
                        l10n,
                        isSmallWidth,
                      ),
                      SizedBox(height: isShortHeight ? 22 : 28),
                      _buildSessionProgress(state, isDark, l10n, isSmallWidth),
                      SizedBox(height: isShortHeight ? 14 : 18),
                      _buildDurationSelector(
                        context,
                        state,
                        isDark,
                        l10n,
                        isSmallWidth,
                      ),
                      SizedBox(height: isShortHeight ? 14 : 18),
                      _buildNextBreak(state, isDark, l10n, isSmallWidth),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.focusTimer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 22 : 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.stayFocusedOneSessionAtATime,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 10 : 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        NotificationIconButton(isDark: isDark),
      ],
    );
  }

  Widget _buildTimer(
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final Color timerColor = state.isBreak
        ? const Color(0xFFF97316)
        : AppColors.needthis;

    final Color backgroundColor = state.isBreak
        ? const Color(0xFFFFEDD5)
        : isDark
        ? const Color(0xFF312E81)
        : const Color(0xFFEDE9FE);

    final double timerContainerSize = isSmallWidth ? 168 : 184;
    final double progressSize = isSmallWidth ? 144 : 158;
    final double progressStrokeWidth = isSmallWidth ? 8 : 9;

    return Center(
      child: SizedBox(
        width: timerContainerSize,
        height: timerContainerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: progressSize,
              height: progressSize,
              child: CircularProgressIndicator(
                value: _timerProgress(state),
                strokeWidth: progressStrokeWidth,
                backgroundColor: backgroundColor,
                color: timerColor,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTimer(state.remainingSeconds),
                  style: TextStyle(
                    fontSize: isSmallWidth ? 32 : 36,
                    fontWeight: FontWeight.w800,
                    color: state.isBreak
                        ? const Color(0xFF7C2D12)
                        : isDark
                        ? Colors.white
                        : const Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _timerStatusText(state, l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 8 : 9,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timerStatusText(FocusState state, AppLocalizations l10n) {
    if (state.isBreak) {
      return l10n.breakLabel;
    }

    if (state.status == FocusStatus.completed) {
      return l10n.completed;
    }

    if (state.isRunning) {
      return l10n.focusSession;
    }

    if (state.status == FocusStatus.paused) {
      return l10n.paused;
    }

    return l10n.readyToFocus;
  }

  Widget _buildTimerControls(
    BuildContext context,
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final FocusCubit cubit = context.read<FocusCubit>();

    final double resetSize = isSmallWidth ? 42 : 44;
    final double mainButtonWidth = isSmallWidth ? 136 : 150;
    final double mainButtonHeight = isSmallWidth ? 46 : 48;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: resetSize,
            height: resetSize,
            child: OutlinedButton(
              onPressed: cubit.resetTimer,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
                backgroundColor: isDark
                    ? const Color(0xFF1E293B)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: isSmallWidth ? 19 : 20,
                color: isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
          SizedBox(width: isSmallWidth ? 8 : 12),
          SizedBox(
            width: mainButtonWidth,
            height: mainButtonHeight,
            child: ElevatedButton.icon(
              onPressed: state.isRunning
                  ? cubit.pauseTimer
                  : state.canStart
                  ? state.status == FocusStatus.paused
                        ? cubit.resumeTimer
                        : cubit.startTimer
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.needthis,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
                disabledForegroundColor: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallWidth ? 14 : 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: Icon(
                state.isRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 20,
              ),
              label: Text(
                state.isRunning
                    ? l10n.pause
                    : state.status == FocusStatus.paused
                    ? l10n.resume
                    : l10n.startFocus,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 12 : 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionProgress(
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallWidth ? 10 : 12,
        vertical: isSmallWidth ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sessionProgressText(state, l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 10 : 11,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.todaysFocus(
                    _formatFocusMinutes(state.completedFocusMinutes),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 8 : 9,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(state.totalSessions, (index) {
                final bool completed =
                    index < state.currentSession - 1 ||
                    state.allSessionsCompleted;

                final bool current =
                    !state.allSessionsCompleted &&
                    index == state.currentSession - 1;

                return Container(
                  margin: EdgeInsets.only(left: isSmallWidth ? 4 : 5),
                  width: isSmallWidth ? 6 : 7,
                  height: isSmallWidth ? 6 : 7,
                  decoration: BoxDecoration(
                    color: completed
                        ? AppColors.needthis
                        : current
                        ? AppColors.needthis.withValues(alpha: 0.45)
                        : isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _sessionProgressText(FocusState state, AppLocalizations l10n) {
    if (state.allSessionsCompleted) {
      return l10n.allSessionsCompleted;
    }

    if (state.isBreak) {
      return l10n.breakAfterSession(state.currentSession);
    }

    return l10n.sessionOf(state.currentSession, state.totalSessions);
  }

  Widget _buildDurationSelector(
    BuildContext context,
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    const List<int> durations = [25, 45, 60, 90];

    final FocusCubit cubit = context.read<FocusCubit>();

    return Row(
      children: durations.map((duration) {
        final bool selected = state.selectedDuration == duration;

        final bool disabled =
            state.isRunning || state.isBreak || state.allSessionsCompleted;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: duration == durations.last
                  ? 0
                  : isSmallWidth
                  ? 5
                  : 7,
            ),
            child: GestureDetector(
              onTap: disabled
                  ? null
                  : () {
                      cubit.selectDuration(duration);
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: isSmallWidth ? 32 : 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.needthis
                      : isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: selected
                        ? AppColors.needthis
                        : isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  l10n.minutes(duration),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 9 : 10,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : disabled
                        ? isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNextBreak(
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
    bool isSmallWidth,
  ) {
    final bool lastSession = state.currentSession == state.totalSessions;

    final String text;

    if (state.allSessionsCompleted) {
      text = l10n.allFocusSessionsCompleted;
    } else if (state.isBreak) {
      text = l10n.breakInProgress(state.breakDuration);
    } else if (lastSession) {
      text = l10n.finalFocusSession;
    } else {
      text = l10n.nextBreak(state.breakDuration);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallWidth ? 10 : 11,
        vertical: isSmallWidth ? 8 : 9,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFED7AA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            state.isBreak
                ? Icons.self_improvement_outlined
                : Icons.free_breakfast_outlined,
            size: isSmallWidth ? 13 : 14,
            color: const Color(0xFFF97316),
          ),
          SizedBox(width: isSmallWidth ? 6 : 7),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 9 : 10,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF97316),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimer(int remainingSeconds) {
    final int minutes = remainingSeconds ~/ 60;
    final int seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  double _timerProgress(FocusState state) {
    if (state.totalSeconds <= 0) {
      return 0;
    }

    return 1 - (state.remainingSeconds / state.totalSeconds);
  }

  String _formatFocusMinutes(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    }

    return '${remainingMinutes}m';
  }
}
