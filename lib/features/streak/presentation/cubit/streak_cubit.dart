import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/service/notification_service.dart';
import 'package:task_flow/core/storage/settings_storage.dart';

import '../../data/streak_storage.dart';
import 'streak_state.dart';

class StreakCubit extends Cubit<StreakState> {
  final StreakStorage _storage;

  StreakCubit(this._storage, SettingsStorage settingsStorage)
    : super(const StreakState());

  Future<void> recordDailyVisit(String userId) async {
    emit(state.copyWith(loading: true));

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime? lastVisit = await _storage.getLastVisit(userId);
    final int oldStreak = await _storage.getStreak(userId);

    if (lastVisit == null) {
      await _storage.saveStreak(userId: userId, streak: 1, lastVisit: today);

      emit(StreakState(streak: 1, lastVisit: today));

      await _scheduleStreakNotification(1);
      return;
    }

    final DateTime lastDay = DateTime(
      lastVisit.year,
      lastVisit.month,
      lastVisit.day,
    );

    final int difference = today.difference(lastDay).inDays;

    if (difference == 0) {
      emit(StreakState(streak: oldStreak, lastVisit: lastDay));

      await _scheduleStreakNotification(oldStreak);
      return;
    }

    if (difference == 1) {
      final int newStreak = oldStreak + 1;

      await _storage.saveStreak(
        userId: userId,
        streak: newStreak,
        lastVisit: today,
      );

      emit(StreakState(streak: newStreak, lastVisit: today));

      await _scheduleStreakNotification(newStreak);
      return;
    }

    await _storage.saveStreak(userId: userId, streak: 1, lastVisit: today);

    emit(StreakState(streak: 1, lastVisit: today));

    await _scheduleStreakNotification(1);
  }

  Future<void> loadStreak(String userId) async {
    emit(state.copyWith(loading: true));

    final int storedStreak = await _storage.getStreak(userId);
    final DateTime? lastVisit = await _storage.getLastVisit(userId);

    if (lastVisit == null) {
      emit(const StreakState());
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime lastDay = DateTime(
      lastVisit.year,
      lastVisit.month,
      lastVisit.day,
    );

    final int difference = today.difference(lastDay).inDays;

    if (difference > 1) {
      await _storage.saveStreak(userId: userId, streak: 0, lastVisit: lastDay);

      emit(StreakState(streak: 0, lastVisit: lastDay));

      await LocalNotificationService.instance.cancelStreakNotification();

      return;
    }

    emit(StreakState(streak: storedStreak, lastVisit: lastDay));
  }

  Future<void> clearStreak(String userId) async {
    await _storage.clearUserStreak(userId);

    await LocalNotificationService.instance.cancelStreakNotification();

    emit(const StreakState());
  }

  Future<void> _scheduleStreakNotification(int streak) async {
    final bool notificationsEnabled = await _getNotificationsEnabled();

    if (!notificationsEnabled) {
      await LocalNotificationService.instance.cancelStreakNotification();

      return;
    }

    final bool soundEnabled = await _getSoundEnabled();

    await LocalNotificationService.instance.scheduleDailyStreakNotification(
      soundEnabled: soundEnabled,
      streak: streak,
    );
  }

  Future<bool> _getNotificationsEnabled() async {
    final settingsStorage = SettingsStorage();

    return settingsStorage.getNotificationsEnabled();
  }

  Future<bool> _getSoundEnabled() async {
    final settingsStorage = SettingsStorage();

    return settingsStorage.getSound();
  }
}
