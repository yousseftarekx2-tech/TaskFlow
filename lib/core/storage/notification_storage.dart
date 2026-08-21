import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/features/notification/data/model/notification_model.dart';

class NotificationStorage {
  static const String _notificationsKey = 'notifications';

  // ============================================================
  // GET NOTIFICATIONS
  // ============================================================

  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_notificationsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(data);

      return decoded
          .map(
            (item) =>
                NotificationModel.fromMap(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ============================================================
  // SAVE NOTIFICATIONS
  // ============================================================

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();

    final String data = jsonEncode(
      notifications.map((notification) => notification.toMap()).toList(),
    );

    await prefs.setString(_notificationsKey, data);
  }

  // ============================================================
  // CLEAR
  // ============================================================

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_notificationsKey);
  }
}
