import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/storage/settings_storage.dart';

class SettingsState {
  // ============================================================
  // GENERAL SETTINGS
  // ============================================================

  final bool darkModeEnabled;
  final bool soundEnabled;

  /// Language code:
  /// en = English
  /// ar = Arabic
  final String selectedLanguage;

  // ============================================================
  // NOTIFICATION SETTINGS
  // ============================================================

  final bool notificationsEnabled;

  // Task notifications
  final bool taskRemindersEnabled;
  final int taskReminderMinutes;

  // Focus notifications
  final bool focusNotificationsEnabled;

  // Focus notification types
  final bool focusSessionFinished;
  final bool breakStarted;
  final bool breakFinished;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const SettingsState({
    this.darkModeEnabled = false,
    this.soundEnabled = true,

    // Default language = English
    this.selectedLanguage = 'en',

    // Notifications
    this.notificationsEnabled = true,

    // Tasks
    this.taskRemindersEnabled = true,
    this.taskReminderMinutes = 15,

    // Focus
    this.focusNotificationsEnabled = true,

    // Focus types
    this.focusSessionFinished = true,
    this.breakStarted = true,
    this.breakFinished = true,
  });

  // ============================================================
  // COPY WITH
  // ============================================================

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
      // General
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,

      soundEnabled: soundEnabled ?? this.soundEnabled,

      selectedLanguage: selectedLanguage ?? this.selectedLanguage,

      // Notifications
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,

      // Tasks
      taskRemindersEnabled: taskRemindersEnabled ?? this.taskRemindersEnabled,

      taskReminderMinutes: taskReminderMinutes ?? this.taskReminderMinutes,

      // Focus
      focusNotificationsEnabled:
          focusNotificationsEnabled ?? this.focusNotificationsEnabled,

      // Focus types
      focusSessionFinished: focusSessionFinished ?? this.focusSessionFinished,

      breakStarted: breakStarted ?? this.breakStarted,

      breakFinished: breakFinished ?? this.breakFinished,
    );
  }
}

// ============================================================
// SETTINGS CUBIT
// ============================================================

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage _settingsStorage;

  SettingsCubit(this._settingsStorage) : super(const SettingsState());

  // ============================================================
  // LOAD SETTINGS
  // ============================================================

  Future<void> loadSettings() async {
    final darkMode = await _settingsStorage.getDarkMode();

    final sound = await _settingsStorage.getSound();

    final storedLanguage = await _settingsStorage.getLanguage();

    // ============================================================
    // NORMALIZE LANGUAGE
    // ============================================================
    //
    // We support old saved values such as:
    //
    // English
    // Arabic
    //
    // and convert them permanently to:
    //
    // en
    // ar
    //
    // ============================================================

    final String language = _normalizeLanguage(storedLanguage);

    // Notifications
    final notificationsEnabled = await _settingsStorage
        .getNotificationsEnabled();

    // Task reminders
    final taskRemindersEnabled = await _settingsStorage
        .getTaskRemindersEnabled();

    final taskReminderMinutes = await _settingsStorage.getTaskReminderMinutes();

    // Focus
    final focusNotificationsEnabled = await _settingsStorage
        .getFocusNotificationsEnabled();

    final focusSessionFinished = await _settingsStorage
        .getFocusSessionFinished();

    final breakStarted = await _settingsStorage.getBreakStarted();

    final breakFinished = await _settingsStorage.getBreakFinished();

    // ============================================================
    // MIGRATE OLD LANGUAGE VALUE
    // ============================================================

    if (storedLanguage != language) {
      await _settingsStorage.saveLanguage(language);
    }

    emit(
      SettingsState(
        // General
        darkModeEnabled: darkMode,
        soundEnabled: sound,
        selectedLanguage: language,

        // Notifications
        notificationsEnabled: notificationsEnabled,

        // Task reminders
        taskRemindersEnabled: taskRemindersEnabled,
        taskReminderMinutes: taskReminderMinutes,

        // Focus
        focusNotificationsEnabled: focusNotificationsEnabled,

        // Focus types
        focusSessionFinished: focusSessionFinished,

        breakStarted: breakStarted,

        breakFinished: breakFinished,
      ),
    );
  }

  // ============================================================
  // DARK MODE
  // ============================================================

  Future<void> toggleDarkMode(bool value) async {
    await _settingsStorage.saveDarkMode(value);

    emit(state.copyWith(darkModeEnabled: value));
  }

  // ============================================================
  // SOUND
  // ============================================================

  Future<void> toggleSound(bool value) async {
    await _settingsStorage.saveSound(value);

    emit(state.copyWith(soundEnabled: value));
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  Future<void> changeLanguage(String language) async {
    final String normalizedLanguage = _normalizeLanguage(language);

    // ==========================================================
    // PREVENT UNNECESSARY CHANGE
    // ==========================================================

    if (state.selectedLanguage == normalizedLanguage) {
      return;
    }

    await _settingsStorage.saveLanguage(normalizedLanguage);

    emit(state.copyWith(selectedLanguage: normalizedLanguage));
  }

  // ============================================================
  // NORMALIZE LANGUAGE
  // ============================================================

  String _normalizeLanguage(String language) {
    final String normalized = language.trim().toLowerCase();

    // Arabic
    if (normalized == 'ar' ||
        normalized == 'arabic' ||
        normalized == 'عربي' ||
        normalized == 'العربية') {
      return 'ar';
    }

    // English
    if (normalized == 'en' ||
        normalized == 'english' ||
        normalized == 'انجليزي' ||
        normalized == 'الإنجليزية') {
      return 'en';
    }

    // Default
    return 'en';
  }

  // ============================================================
  // MASTER NOTIFICATIONS
  // ============================================================

  Future<void> toggleNotifications(bool value) async {
    await _settingsStorage.saveNotificationsEnabled(value);

    emit(state.copyWith(notificationsEnabled: value));
  }

  // ============================================================
  // TASK REMINDERS
  // ============================================================

  Future<void> toggleTaskReminders(bool value) async {
    await _settingsStorage.saveTaskRemindersEnabled(value);

    emit(state.copyWith(taskRemindersEnabled: value));
  }

  // ============================================================
  // TASK REMINDER TIME
  // ============================================================

  Future<void> changeTaskReminderMinutes(int minutes) async {
    await _settingsStorage.saveTaskReminderMinutes(minutes);

    emit(state.copyWith(taskReminderMinutes: minutes));
  }

  // ============================================================
  // FOCUS NOTIFICATIONS
  // ============================================================

  Future<void> toggleFocusNotifications(bool value) async {
    await _settingsStorage.saveFocusNotificationsEnabled(value);

    emit(state.copyWith(focusNotificationsEnabled: value));
  }

  // ============================================================
  // FOCUS SESSION FINISHED
  // ============================================================

  Future<void> toggleFocusSessionFinished(bool value) async {
    await _settingsStorage.saveFocusSessionFinished(value);

    emit(state.copyWith(focusSessionFinished: value));
  }

  // ============================================================
  // BREAK STARTED
  // ============================================================

  Future<void> toggleBreakStarted(bool value) async {
    await _settingsStorage.saveBreakStarted(value);

    emit(state.copyWith(breakStarted: value));
  }

  // ============================================================
  // BREAK FINISHED
  // ============================================================

  Future<void> toggleBreakFinished(bool value) async {
    await _settingsStorage.saveBreakFinished(value);

    emit(state.copyWith(breakFinished: value));
  }
}
