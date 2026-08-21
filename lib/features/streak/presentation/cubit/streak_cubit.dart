import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/streak_storage.dart';
import 'streak_state.dart';

class StreakCubit extends Cubit<StreakState> {
  final StreakStorage _storage;

  StreakCubit(this._storage) : super(const StreakState());

  // ============================================================
  // RECORD DAILY VISIT
  // ============================================================

  Future<void> recordDailyVisit(String userId) async {
    emit(state.copyWith(loading: true));

    final DateTime now = DateTime.now();

    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime? lastVisit = await _storage.getLastVisit(userId);

    final int oldStreak = await _storage.getStreak(userId);

    // ------------------------------------------------------------
    // FIRST VISIT EVER
    // ------------------------------------------------------------

    if (lastVisit == null) {
      await _storage.saveStreak(userId: userId, streak: 1, lastVisit: today);

      emit(StreakState(streak: 1, lastVisit: today));

      return;
    }

    final DateTime lastDay = DateTime(
      lastVisit.year,
      lastVisit.month,
      lastVisit.day,
    );

    final int difference = today.difference(lastDay).inDays;

    // ------------------------------------------------------------
    // SAME DAY
    // ------------------------------------------------------------

    if (difference == 0) {
      emit(StreakState(streak: oldStreak, lastVisit: lastDay));

      return;
    }

    // ------------------------------------------------------------
    // NEXT DAY
    // ------------------------------------------------------------

    if (difference == 1) {
      final int newStreak = oldStreak + 1;

      await _storage.saveStreak(
        userId: userId,
        streak: newStreak,
        lastVisit: today,
      );

      emit(StreakState(streak: newStreak, lastVisit: today));

      return;
    }

    // ------------------------------------------------------------
    // USER MISSED ONE OR MORE DAYS
    // ------------------------------------------------------------

    final int newStreak = 1;

    await _storage.saveStreak(
      userId: userId,
      streak: newStreak,
      lastVisit: today,
    );

    emit(StreakState(streak: newStreak, lastVisit: today));
  }

  // ============================================================
  // LOAD STREAK
  // ============================================================

  Future<void> loadStreak(String userId) async {
    final int streak = await _storage.getStreak(userId);

    final DateTime? lastVisit = await _storage.getLastVisit(userId);

    emit(StreakState(streak: streak, lastVisit: lastVisit));
  }

  // ============================================================
  // CLEAR
  // ============================================================

  Future<void> clearStreak(String userId) async {
    await _storage.clearUserStreak(userId);

    emit(const StreakState());
  }
}
