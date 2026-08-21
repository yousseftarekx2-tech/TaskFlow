import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks';

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> jsonList = tasks
        .map((task) => task.toJson())
        .toList();

    await prefs.setString(_tasksKey, jsonEncode(jsonList));
  }

  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final String? tasksJson = prefs.getString(_tasksKey);

    if (tasksJson == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(tasksJson) as List<dynamic>;

      return jsonList
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tasksKey);
  }
}
