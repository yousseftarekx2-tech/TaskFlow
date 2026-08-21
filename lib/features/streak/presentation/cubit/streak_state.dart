import 'package:equatable/equatable.dart';

class StreakState extends Equatable {
  final int streak;
  final DateTime? lastVisit;
  final bool loading;

  const StreakState({this.streak = 0, this.lastVisit, this.loading = false});

  StreakState copyWith({int? streak, DateTime? lastVisit, bool? loading}) {
    return StreakState(
      streak: streak ?? this.streak,
      lastVisit: lastVisit ?? this.lastVisit,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [streak, lastVisit, loading];
}
