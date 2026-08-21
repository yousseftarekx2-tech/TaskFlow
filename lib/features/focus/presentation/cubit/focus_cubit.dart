import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/features/notification/data/model/notification_model.dart';
import 'package:task_flow/features/notification/presentaions/cubit/notification_cubit.dart';

import 'focus_state.dart';

class FocusCubit extends Cubit<FocusState> {
  final NotificationCubit notificationCubit;

  FocusCubit(this.notificationCubit) : super(const FocusState());

  Timer? _timer;

  // ============================================================
  // START
  // ============================================================

  void startTimer() {
    if (state.isRunning ||
        state.allSessionsCompleted ||
        state.remainingSeconds <= 0) {
      return;
    }

    _timer?.cancel();

    emit(state.copyWith(isRunning: true, status: FocusStatus.running));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  // ============================================================
  // TICK
  // ============================================================

  void _tick() {
    if (isClosed) {
      return;
    }

    if (state.remainingSeconds > 0) {
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));

      return;
    }

    _finishCurrentTimer();
  }

  // ============================================================
  // PAUSE
  // ============================================================

  void pauseTimer() {
    if (!state.isRunning) {
      return;
    }

    _timer?.cancel();
    _timer = null;

    emit(state.copyWith(isRunning: false, status: FocusStatus.paused));
  }

  // ============================================================
  // RESUME
  // ============================================================

  void resumeTimer() {
    if (state.isRunning ||
        state.allSessionsCompleted ||
        state.remainingSeconds <= 0) {
      return;
    }

    startTimer();
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetTimer() {
    _timer?.cancel();
    _timer = null;

    final int seconds = state.selectedDuration * 60;

    emit(
      FocusState(
        selectedDuration: state.selectedDuration,
        remainingSeconds: seconds,
        totalSeconds: seconds,
        totalSessions: state.totalSessions,
        breakDuration: state.breakDuration,
      ),
    );
  }

  // ============================================================
  // SELECT DURATION
  // ============================================================

  void selectDuration(int duration) {
    if (state.isRunning || state.isBreak || state.allSessionsCompleted) {
      return;
    }

    final int seconds = duration * 60;

    emit(
      state.copyWith(
        selectedDuration: duration,
        remainingSeconds: seconds,
        totalSeconds: seconds,
        status: FocusStatus.ready,
      ),
    );
  }

  // ============================================================
  // FINISH CURRENT TIMER
  // ============================================================

  Future<void> _finishCurrentTimer() async {
    _timer?.cancel();
    _timer = null;

    // ============================================================
    // BREAK FINISHED
    // ============================================================

    if (state.isBreak) {
      // ----------------------------------------------------------
      // BREAK FINISHED NOTIFICATION
      // ----------------------------------------------------------

      await notificationCubit.addNotification(
        type: NotificationType.breakFinished,
      );

      if (isClosed) {
        return;
      }

      if (state.currentSession < state.totalSessions) {
        final int seconds = state.selectedDuration * 60;

        emit(
          state.copyWith(
            currentSession: state.currentSession + 1,
            isBreak: false,
            isRunning: false,
            remainingSeconds: seconds,
            totalSeconds: seconds,
            status: FocusStatus.ready,
          ),
        );
      }

      return;
    }

    // ============================================================
    // FOCUS FINISHED
    // ============================================================

    final int completedMinutes =
        state.completedFocusMinutes + state.selectedDuration;

    // ------------------------------------------------------------
    // FOCUS SESSION FINISHED NOTIFICATION
    // ------------------------------------------------------------

    await notificationCubit.addNotification(
      type: NotificationType.focusSessionFinished,
    );

    if (isClosed) {
      return;
    }

    // ============================================================
    // LAST SESSION
    // ============================================================

    if (state.currentSession >= state.totalSessions) {
      emit(
        state.copyWith(
          completedFocusMinutes: completedMinutes,
          isRunning: false,
          isBreak: false,
          remainingSeconds: 0,
          totalSeconds: state.selectedDuration * 60,
          status: FocusStatus.completed,
        ),
      );

      return;
    }

    // ============================================================
    // START BREAK
    // ============================================================

    final int breakSeconds = state.breakDuration * 60;

    // ------------------------------------------------------------
    // BREAK STARTED NOTIFICATION
    // ------------------------------------------------------------

    await notificationCubit.addNotification(
      type: NotificationType.breakStarted,
    );

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        completedFocusMinutes: completedMinutes,
        isRunning: false,
        isBreak: true,
        remainingSeconds: breakSeconds,
        totalSeconds: breakSeconds,
        status: FocusStatus.breakTime,
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;

    return super.close();
  }
}
