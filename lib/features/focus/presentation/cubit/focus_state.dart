enum FocusStatus { ready, running, paused, breakTime, completed }

class FocusState {
  final int selectedDuration;
  final int remainingSeconds;
  final int totalSeconds;
  final int currentSession;
  final int totalSessions;
  final int completedFocusMinutes;
  final int breakDuration;

  final bool isBreak;
  final bool isRunning;

  final FocusStatus status;

  const FocusState({
    this.selectedDuration = 25,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.currentSession = 1,
    this.totalSessions = 4,
    this.completedFocusMinutes = 0,
    this.breakDuration = 5,
    this.isBreak = false,
    this.isRunning = false,
    this.status = FocusStatus.ready,
  });

  bool get allSessionsCompleted => status == FocusStatus.completed;

  bool get canStart =>
      !isRunning && !allSessionsCompleted && remainingSeconds > 0;

  FocusState copyWith({
    int? selectedDuration,
    int? remainingSeconds,
    int? totalSeconds,
    int? currentSession,
    int? totalSessions,
    int? completedFocusMinutes,
    int? breakDuration,
    bool? isBreak,
    bool? isRunning,
    FocusStatus? status,
  }) {
    return FocusState(
      selectedDuration: selectedDuration ?? this.selectedDuration,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      currentSession: currentSession ?? this.currentSession,
      totalSessions: totalSessions ?? this.totalSessions,
      completedFocusMinutes:
          completedFocusMinutes ?? this.completedFocusMinutes,
      breakDuration: breakDuration ?? this.breakDuration,
      isBreak: isBreak ?? this.isBreak,
      isRunning: isRunning ?? this.isRunning,
      status: status ?? this.status,
    );
  }
}
