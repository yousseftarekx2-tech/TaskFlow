import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildHeader(context, isDark, l10n),

                  const SizedBox(height: 30),

                  _buildTimer(state, isDark, l10n),

                  const SizedBox(height: 20),

                  _buildTimerControls(context, state, isDark, l10n),

                  const SizedBox(height: 28),

                  _buildSessionProgress(state, isDark, l10n),

                  const SizedBox(height: 18),

                  _buildDurationSelector(context, state, isDark, l10n),

                  const SizedBox(height: 18),

                  _buildNextBreak(state, isDark, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                l10n.focusTimer,

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                l10n.stayFocusedOneSessionAtATime,

                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),

        NotificationIconButton(isDark: isDark),
      ],
    );
  }

  // ============================================================
  // TIMER
  // ============================================================

  Widget _buildTimer(FocusState state, bool isDark, AppLocalizations l10n) {
    final Color timerColor = state.isBreak
        ? const Color(0xFFF97316)
        : AppColors.needthis;

    final Color backgroundColor = state.isBreak
        ? const Color(0xFFFFEDD5)
        : isDark
        ? const Color(0xFF312E81)
        : const Color(0xFFEDE9FE);

    return Center(
      child: SizedBox(
        width: 184,
        height: 184,

        child: Stack(
          alignment: Alignment.center,

          children: [
            SizedBox(
              width: 158,
              height: 158,

              child: CircularProgressIndicator(
                value: _timerProgress(state),
                strokeWidth: 9,
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
                    fontSize: 36,
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

                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
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

  // ============================================================
  // TIMER CONTROLS
  // ============================================================

  Widget _buildTimerControls(
    BuildContext context,
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final FocusCubit cubit = context.read<FocusCubit>();

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          SizedBox(
            width: 44,
            height: 44,

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
                size: 20,

                color: isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF64748B),
              ),
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 150,
            height: 48,

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

                padding: const EdgeInsets.symmetric(horizontal: 22),

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

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SESSION PROGRESS
  // ============================================================

  Widget _buildSessionProgress(
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

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

                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,

                    color: isDark ? Colors.white : const Color(0xFF334155),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  l10n.todaysFocus(
                    _formatFocusMinutes(state.completedFocusMinutes),
                  ),

                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: List.generate(state.totalSessions, (index) {
              final bool completed =
                  index < state.currentSession - 1 ||
                  state.allSessionsCompleted;

              final bool current =
                  !state.allSessionsCompleted &&
                  index == state.currentSession - 1;

              return Container(
                margin: const EdgeInsets.only(left: 5),

                width: 7,
                height: 7,

                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.needthis
                      : current
                      ? AppColors.needthis.withOpacity(0.45)
                      : isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFE2E8F0),

                  shape: BoxShape.circle,
                ),
              );
            }),
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

  // ============================================================
  // DURATION SELECTOR
  // ============================================================

  Widget _buildDurationSelector(
    BuildContext context,
    FocusState state,
    bool isDark,
    AppLocalizations l10n,
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
            padding: EdgeInsets.only(right: duration == durations.last ? 0 : 7),

            child: GestureDetector(
              onTap: disabled
                  ? null
                  : () {
                      cubit.selectDuration(duration);
                    },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),

                height: 34,

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

                  style: TextStyle(
                    fontSize: 10,
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

  // ============================================================
  // NEXT BREAK
  // ============================================================

  Widget _buildNextBreak(FocusState state, bool isDark, AppLocalizations l10n) {
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

      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),

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

            size: 14,

            color: const Color(0xFFF97316),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF97316),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

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
