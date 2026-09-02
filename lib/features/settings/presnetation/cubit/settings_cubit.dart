import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/service/notification_service.dart';
import 'package:task_flow/core/storage/settings_storage.dart';

class SettingsState {
  final bool darkModeEnabled;
  final bool soundEnabled;
  final String selectedLanguage;

  final bool notificationsEnabled;

  final bool taskRemindersEnabled;
  final int taskReminderMinutes;

  final bool focusNotificationsEnabled;

  final bool focusSessionFinished;
  final bool breakStarted;
  final bool breakFinished;

  const SettingsState({
    this.darkModeEnabled = false,
    this.soundEnabled = true,
    this.selectedLanguage = 'en',
    this.notificationsEnabled = true,
    this.taskRemindersEnabled = true,
    this.taskReminderMinutes = 15,
    this.focusNotificationsEnabled = true,
    this.focusSessionFinished = true,
    this.breakStarted = true,
    this.breakFinished = true,
  });

  SettingsState copyWith({
    bool? darkModeEnabled,
    bool? soundEnabled,
    String? selectedLanguage,
    bool? notificationsEnabled,
    bool? taskRemindersEnabled,
    int? taskReminderMinutes,
    bool? focusNotificationsEnabled,
    bool? focusSessionFinished,
    bool? breakStarted,
    bool? breakFinished,
  }) {
    return SettingsState(
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      taskRemindersEnabled: taskRemindersEnabled ?? this.taskRemindersEnabled,
      taskReminderMinutes: taskReminderMinutes ?? this.taskReminderMinutes,
      focusNotificationsEnabled:
          focusNotificationsEnabled ?? this.focusNotificationsEnabled,
      focusSessionFinished: focusSessionFinished ?? this.focusSessionFinished,
      breakStarted: breakStarted ?? this.breakStarted,
      breakFinished: breakFinished ?? this.breakFinished,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage _settingsStorage;

  SettingsCubit(this._settingsStorage) : super(const SettingsState());

  Future<void> loadSettings() async {
    final darkMode = await _settingsStorage.getDarkMode();
    final sound = await _settingsStorage.getSound();

    final storedLanguage = await _settingsStorage.getLanguage();
    final String language = _normalizeLanguage(storedLanguage);

    final notificationsEnabled = await _settingsStorage
        .getNotificationsEnabled();

    final taskRemindersEnabled = await _settingsStorage
        .getTaskRemindersEnabled();

    final taskReminderMinutes = await _settingsStorage.getTaskReminderMinutes();

    final focusNotificationsEnabled = await _settingsStorage
        .getFocusNotificationsEnabled();

    final focusSessionFinished = await _settingsStorage
        .getFocusSessionFinished();

    final breakStarted = await _settingsStorage.getBreakStarted();

    final breakFinished = await _settingsStorage.getBreakFinished();

    if (storedLanguage != language) {
      await _settingsStorage.saveLanguage(language);
    }

    emit(
      SettingsState(
        darkModeEnabled: darkMode,
        soundEnabled: sound,
        selectedLanguage: language,
        notificationsEnabled: notificationsEnabled,
        taskRemindersEnabled: taskRemindersEnabled,
        taskReminderMinutes: taskReminderMinutes,
        focusNotificationsEnabled: focusNotificationsEnabled,
        focusSessionFinished: focusSessionFinished,
        breakStarted: breakStarted,
        breakFinished: breakFinished,
      ),
    );

    await _syncDailyNotification(
      notificationsEnabled: notificationsEnabled,
      soundEnabled: sound,
    );
  }

  Future<void> toggleDarkMode(bool value) async {
    await _settingsStorage.saveDarkMode(value);

    emit(state.copyWith(darkModeEnabled: value));
  }

  Future<void> toggleSound(bool value) async {
    await _settingsStorage.saveSound(value);

    emit(state.copyWith(soundEnabled: value));

    if (state.notificationsEnabled) {
      await _syncDailyNotification(
        notificationsEnabled: true,
        soundEnabled: value,
      );
    }
  }

  Future<void> changeLanguage(String language) async {
    final String normalizedLanguage = _normalizeLanguage(language);

    if (state.selectedLanguage == normalizedLanguage) {
      return;
    }

    await _settingsStorage.saveLanguage(normalizedLanguage);

    emit(state.copyWith(selectedLanguage: normalizedLanguage));

    if (state.notificationsEnabled) {
      await _syncDailyNotification(
        notificationsEnabled: true,
        soundEnabled: state.soundEnabled,
      );
    }
  }

  String _normalizeLanguage(String language) {
    final String normalized = language.trim().toLowerCase();

    if (normalized == 'ar' ||
        normalized == 'arabic' ||
        normalized == 'عربي' ||
        normalized == 'العربية') {
      return 'ar';
    }

    if (normalized == 'en' ||
        normalized == 'english' ||
        normalized == 'انجليزي' ||
        normalized == 'الإنجليزية') {
      return 'en';
    }

    return 'en';
  }

  Future<void> toggleNotifications(bool value) async {
    await _settingsStorage.saveNotificationsEnabled(value);

    emit(state.copyWith(notificationsEnabled: value));

    if (value) {
      await _syncDailyNotification(
        notificationsEnabled: true,
        soundEnabled: state.soundEnabled,
      );
    } else {
      await LocalNotificationService.instance.cancelDailyAppNotification();

      await LocalNotificationService.instance.cancelStreakNotification();
    }
  }

  Future<void> toggleTaskReminders(bool value) async {
    await _settingsStorage.saveTaskRemindersEnabled(value);

    emit(state.copyWith(taskRemindersEnabled: value));
  }

  Future<void> changeTaskReminderMinutes(int minutes) async {
    await _settingsStorage.saveTaskReminderMinutes(minutes);

    emit(state.copyWith(taskReminderMinutes: minutes));
  }

  Future<void> toggleFocusNotifications(bool value) async {
    await _settingsStorage.saveFocusNotificationsEnabled(value);

    emit(state.copyWith(focusNotificationsEnabled: value));
  }

  Future<void> toggleFocusSessionFinished(bool value) async {
    await _settingsStorage.saveFocusSessionFinished(value);

    emit(state.copyWith(focusSessionFinished: value));
  }

  Future<void> toggleBreakStarted(bool value) async {
    await _settingsStorage.saveBreakStarted(value);

    emit(state.copyWith(breakStarted: value));
  }

  Future<void> toggleBreakFinished(bool value) async {
    await _settingsStorage.saveBreakFinished(value);

    emit(state.copyWith(breakFinished: value));
  }

  Future<void> _syncDailyNotification({
    required bool notificationsEnabled,
    required bool soundEnabled,
  }) async {
    if (!notificationsEnabled) {
      await LocalNotificationService.instance.cancelDailyAppNotification();
      return;
    }

    await LocalNotificationService.instance.scheduleDailyAppNotification(
      soundEnabled: soundEnabled,
    );
  }
}
