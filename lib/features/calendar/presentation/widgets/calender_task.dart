import 'package:flutter/material.dart';

class CalenderTask {
  final String title;
  final String category;
  final String time;
  final Color color;
  final DateTime date;
  bool isCompleted;

  CalenderTask({
    required this.title,
    required this.category,
    required this.time,
    required this.color,
    required this.date,
    this.isCompleted = false,
  });
}
