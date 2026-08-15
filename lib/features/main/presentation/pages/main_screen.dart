import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/calendar/presentation/pages/calendar_screen.dart';
import 'package:task_flow/features/focus/presentation/pages/focus_screen.dart';

import 'package:task_flow/features/home/presentation/pages/home_screen.dart';
import 'package:task_flow/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:task_flow/features/statistics/presentation/pages/stats_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          CalenderScreen(),
          StatsScreen(),
          FocusScreen(),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        onAddTap: () {
          context.push(Routes.task);
        },
      ),
    );
  }
}
