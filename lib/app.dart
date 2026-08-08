import 'package:flutter/material.dart';
import 'package:task_flow/core/routing/app_router.dart';
import 'package:task_flow/core/theme/app_text_style/app_theme.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}