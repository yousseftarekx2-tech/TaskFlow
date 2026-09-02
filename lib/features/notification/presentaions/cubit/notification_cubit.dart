import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/service/notification_service.dart';
import 'package:task_flow/core/storage/notification_storage.dart';
import 'package:task_flow/core/storage/settings_storage.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import '../../data/model/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationStorage _notificationStorage;
  final SettingsStorage _settingsStorage;

  NotificationCubit(this._notificationStorage, this._settingsStorage)
    : super(const NotificationInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationLoading());

    try {
      final notifications = await _notificationStorage.getNotifications();

      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(NotificationLoaded(List.unmodifiable(notifications)));
    } catch (_) {
      emit(const NotificationError('Failed to load notifications.'));
    }
  }

  Future<void> addNotification({
    required NotificationType type,
    String? taskId,
    String? taskTitle,
  }) async {
    if (type == NotificationType.taskCompleted) {
      return;
    }

    final bool notificationsEnabled = await _settingsStorage
        .getNotificationsEnabled();

    if (!notificationsEnabled) {
      return;
    }

    final bool typeEnabled = await _isNotificationTypeEnabled(type);

    if (!typeEnabled) {
      return;
    }

    final notifications = await _notificationStorage.getNotifications();

    if (type == NotificationType.taskReminder && taskId != null) {
      final bool alreadyExists = notifications.any(
        (notification) =>
            notification.type == NotificationType.taskReminder &&
            notification.taskId == taskId,
      );

      if (alreadyExists) {
        return;
      }
    }

    final DateTime now = DateTime.now();

    final NotificationModel notification = NotificationModel(
      id: now.microsecondsSinceEpoch.toString(),
      type: type,
      taskId: taskId,
      taskTitle: taskTitle,
      createdAt: now,
      isRead: false,
    );

    notifications.insert(0, notification);

    await _notificationStorage.saveNotifications(notifications);

    final bool soundEnabled = await _settingsStorage.getSound();

    final String language = await _settingsStorage.getLanguage();

    final String normalizedLanguage = language.toLowerCase();

    final bool isArabic =
        normalizedLanguage == 'arabic' || normalizedLanguage == 'ar';

    final AppLocalizations l10n = isArabic
        ? lookupAppLocalizations(const Locale('ar'))
        : lookupAppLocalizations(const Locale('en'));

    final String title = _getTitle(type, l10n);

    final String body = _getBody(type, l10n, taskTitle: taskTitle);

    await LocalNotificationService.instance.showNotification(
      id: now.millisecondsSinceEpoch.remainder(2147483647),
      title: title,
      body: body,
      soundEnabled: soundEnabled,
      payload: notification.id,
    );

    emit(NotificationLoaded(List.unmodifiable(notifications)));
  }

  Future<bool> _isNotificationTypeEnabled(NotificationType type) async {
    switch (type) {
      case NotificationType.taskCompleted:
        return false;

      case NotificationType.taskOverdue:
        return true;

      case NotificationType.taskReminder:
        return _settingsStorage.getTaskRemindersEnabled();

      case NotificationType.focusSessionFinished:
        final bool focusEnabled = await _settingsStorage
            .getFocusNotificationsEnabled();

        final bool sessionFinishedEnabled = await _settingsStorage
            .getFocusSessionFinished();

        return focusEnabled && sessionFinishedEnabled;

      case NotificationType.breakStarted:
        final bool focusEnabled = await _settingsStorage
            .getFocusNotificationsEnabled();

        final bool breakStartedEnabled = await _settingsStorage
            .getBreakStarted();

        return focusEnabled && breakStartedEnabled;

      case NotificationType.breakFinished:
        final bool focusEnabled = await _settingsStorage
            .getFocusNotificationsEnabled();

        final bool breakFinishedEnabled = await _settingsStorage
            .getBreakFinished();

        return focusEnabled && breakFinishedEnabled;

      case NotificationType.dailyApp:
        return true;

      case NotificationType.streak:
        return true;
    }
  }

  String _getTitle(NotificationType type, AppLocalizations l10n) {
    switch (type) {
      case NotificationType.taskCompleted:
        return l10n.notificationTaskCompletedTitle;

      case NotificationType.taskOverdue:
        return l10n.notificationTaskOverdueTitle;

      case NotificationType.taskReminder:
        return l10n.notificationTaskReminderTitle;

      case NotificationType.focusSessionFinished:
        return l10n.notificationFocusSessionFinishedTitle;

      case NotificationType.breakStarted:
        return l10n.notificationBreakStartedTitle;

      case NotificationType.breakFinished:
        return l10n.notificationBreakFinishedTitle;

      case NotificationType.dailyApp:
        return l10n.notificationDailyAppTitle;

      case NotificationType.streak:
        return l10n.notificationStreakTitle;
    }
  }

  String _getBody(
    NotificationType type,
    AppLocalizations l10n, {
    String? taskTitle,
  }) {
    switch (type) {
      case NotificationType.taskCompleted:
        return l10n.notificationTaskCompletedBody;

      case NotificationType.taskOverdue:
        if (taskTitle != null && taskTitle.isNotEmpty) {
          return l10n.notificationTaskOverdueBodyWithTask(taskTitle);
        }

        return l10n.notificationTaskOverdueBody;

      case NotificationType.taskReminder:
        if (taskTitle != null && taskTitle.isNotEmpty) {
          return l10n.notificationTaskReminderBodyWithTask(taskTitle);
        }

        return l10n.notificationTaskReminderBody;

      case NotificationType.focusSessionFinished:
        return l10n.notificationFocusSessionFinishedBody;

      case NotificationType.breakStarted:
        return l10n.notificationBreakStartedBody;

      case NotificationType.breakFinished:
        return l10n.notificationBreakFinishedBody;

      case NotificationType.dailyApp:
        return l10n.notificationDailyAppBody;

      case NotificationType.streak:
        return l10n.notificationStreakBody;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final notifications = await _notificationStorage.getNotifications();

    final int index = notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );

    if (index == -1) {
      return;
    }

    notifications[index] = notifications[index].copyWith(isRead: true);

    await _notificationStorage.saveNotifications(notifications);

    emit(NotificationLoaded(List.unmodifiable(notifications)));
  }

  Future<void> markAllAsRead() async {
    final notifications = await _notificationStorage.getNotifications();

    if (notifications.isEmpty) {
      return;
    }

    final List<NotificationModel> updatedNotifications = notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();

    await _notificationStorage.saveNotifications(updatedNotifications);

    emit(NotificationLoaded(List.unmodifiable(updatedNotifications)));
  }

  Future<void> deleteNotification(String notificationId) async {
    final notifications = await _notificationStorage.getNotifications();

    notifications.removeWhere(
      (notification) => notification.id == notificationId,
    );

    await _notificationStorage.saveNotifications(notifications);

    emit(NotificationLoaded(List.unmodifiable(notifications)));
  }

  Future<void> clearAll() async {
    await _notificationStorage.clearNotifications();

    emit(const NotificationLoaded([]));
  }
}
