import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:task_flow/core/storage/settings_storage.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final SettingsStorage _settingsStorage = SettingsStorage();

  static const String _soundChannelId = 'task_flow_notifications_sound';
  static const String _silentChannelId = 'task_flow_notifications_silent';

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings: settings);

    await _createChannels();
    await requestNotificationPermission();
  }

  Future<void> _createChannels() async {
    const AndroidNotificationChannel soundChannel = AndroidNotificationChannel(
      _soundChannelId,
      'TaskFlow Notifications',
      description: 'TaskFlow notifications with sound.',
      importance: Importance.high,
      playSound: true,
    );

    const AndroidNotificationChannel silentChannel = AndroidNotificationChannel(
      _silentChannelId,
      'TaskFlow Silent Notifications',
      description: 'TaskFlow notifications without sound.',
      importance: Importance.high,
      playSound: false,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(soundChannel);
    await androidPlugin?.createNotificationChannel(silentChannel);
  }

  Future<bool> requestNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final bool? granted = await androidPlugin?.requestNotificationsPermission();

    return granted ?? true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required bool soundEnabled,
    String? payload,
  }) async {
    final String channelId = soundEnabled ? _soundChannelId : _silentChannelId;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          soundEnabled
              ? 'TaskFlow Notifications'
              : 'TaskFlow Silent Notifications',
          channelDescription: soundEnabled
              ? 'TaskFlow notifications with sound.'
              : 'TaskFlow notifications without sound.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: soundEnabled,
          enableVibration: true,
        );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  Future<void> scheduleDailyAppNotification({
    required bool soundEnabled,
    int hour = 10,
    int minute = 0,
  }) async {
    final AppLocalizations l10n = await _getLocalizations();

    await _plugin.zonedSchedule(
      id: 1001,
      title: l10n.dailyAppNotificationTitle,
      body: l10n.dailyAppNotificationBody,
      scheduledDate: _nextTime(hour, minute),
      notificationDetails: _notificationDetails(soundEnabled),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_app',
    );
  }

  Future<void> scheduleDailyStreakNotification({
    required bool soundEnabled,
    required int streak,
    int hour = 20,
    int minute = 0,
  }) async {
    final AppLocalizations l10n = await _getLocalizations();

    final String body = streak <= 1
        ? l10n.streakNotificationBodyFirstDay
        : l10n.streakNotificationBody(streak);

    await _plugin.zonedSchedule(
      id: 1002,
      title: l10n.streakNotificationTitle,
      body: body,
      scheduledDate: _nextTime(hour, minute),
      notificationDetails: _notificationDetails(soundEnabled),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'streak',
    );
  }

  Future<AppLocalizations> _getLocalizations() async {
    final String language = await _settingsStorage.getLanguage();
    final String normalizedLanguage = language.trim().toLowerCase();

    final Locale locale =
        normalizedLanguage == 'arabic' ||
            normalizedLanguage == 'ar' ||
            normalizedLanguage == 'العربية' ||
            normalizedLanguage == 'العربي'
        ? const Locale('ar')
        : const Locale('en');

    return lookupAppLocalizations(locale);
  }

  Future<void> cancelDailyAppNotification() async {
    await _plugin.cancel(id: 1001);
  }

  Future<void> cancelStreakNotification() async {
    await _plugin.cancel(id: 1002);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  NotificationDetails _notificationDetails(bool soundEnabled) {
    final String channelId = soundEnabled ? _soundChannelId : _silentChannelId;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        soundEnabled
            ? 'TaskFlow Notifications'
            : 'TaskFlow Silent Notifications',
        channelDescription: soundEnabled
            ? 'TaskFlow notifications with sound.'
            : 'TaskFlow notifications without sound.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundEnabled,
        enableVibration: true,
      ),
    );
  }

  tz.TZDateTime _nextTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
