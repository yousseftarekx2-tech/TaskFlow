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

class _weekDay extends StatelessWidget {
  const _weekDay({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0XFF94A388),
          ),
        ),
      ),
    );
  }
}
