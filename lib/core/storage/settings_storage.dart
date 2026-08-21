import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  // ============================================================
  // GENERAL SETTINGS KEYS
  // ============================================================

  static const String _darkModeKey = 'dark_mode';
  static const String _soundKey = 'sound_enabled';
  static const String _languageKey = 'language';

  // ============================================================
  // NOTIFICATION SETTINGS KEYS
  // ============================================================

  static const String _notificationsEnabledKey = 'notifications_enabled';

  static const String _taskRemindersEnabledKey = 'task_reminders_enabled';

  static const String _taskReminderMinutesKey = 'task_reminder_minutes';

  static const String _focusNotificationsEnabledKey =
      'focus_notifications_enabled';

  static const String _focusSessionFinishedKey =
      'focus_session_finished_notification';

  static const String _breakStartedKey = 'break_started_notification';

  static const String _breakFinishedKey = 'break_finished_notification';

  // ============================================================
  // DARK MODE
  // ============================================================

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_darkModeKey, value);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_darkModeKey) ?? false;
  }

  // ============================================================
  // SOUND
  // ============================================================

  Future<void> saveSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_soundKey, value);
  }

  Future<bool> getSound() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_soundKey) ?? true;
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_languageKey, language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_languageKey) ?? 'English';
  }

  // ============================================================
  // MASTER NOTIFICATIONS
  // ============================================================

  Future<void> saveNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_notificationsEnabledKey, value);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  // ============================================================
  // TASK REMINDERS
  // ============================================================

  Future<void> saveTaskRemindersEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_taskRemindersEnabledKey, value);
  }

  Future<bool> getTaskRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_taskRemindersEnabledKey) ?? true;
  }

  // ============================================================
  // TASK REMINDER TIME
  // ============================================================

  Future<void> saveTaskReminderMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_taskReminderMinutesKey, minutes);
  }

  Future<int> getTaskReminderMinutes() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_taskReminderMinutesKey) ?? 15;
  }

  // ============================================================
  // FOCUS NOTIFICATIONS
  // ============================================================

  Future<void> saveFocusNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_focusNotificationsEnabledKey, value);
  }

  Future<bool> getFocusNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_focusNotificationsEnabledKey) ?? true;
  }

  // ============================================================
  // FOCUS SESSION FINISHED
  // ============================================================

  Future<void> saveFocusSessionFinished(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_focusSessionFinishedKey, value);
  }

  Future<bool> getFocusSessionFinished() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_focusSessionFinishedKey) ?? true;
  }

  // ============================================================
  // BREAK STARTED
  // ============================================================

  Future<void> saveBreakStarted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_breakStartedKey, value);
  }

  Future<bool> getBreakStarted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_breakStartedKey) ?? true;
  }

  // ============================================================
  // BREAK FINISHED
  // ============================================================

  Future<void> saveBreakFinished(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_breakFinishedKey, value);
  }

  Future<bool> getBreakFinished() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_breakFinishedKey) ?? true;
  }
}
