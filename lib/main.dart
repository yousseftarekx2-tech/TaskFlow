import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/service/notification_service.dart';
import 'package:task_flow/core/storage/notification_storage.dart';
import 'package:task_flow/core/storage/settings_storage.dart';
import 'package:task_flow/core/storage/task_storage.dart';
import 'package:task_flow/core/storage/user_storage.dart';

import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/data/category_storage.dart';
import 'package:task_flow/features/focus/presentation/cubit/focus_cubit.dart';
import 'package:task_flow/features/notification/presentaions/cubit/notification_cubit.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/features/streak/data/streak_storage.dart';
import 'package:task_flow/features/streak/presentation/cubit/streak_cubit.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsStorage = SettingsStorage();
  final taskStorage = TaskStorage();
  final notificationStorage = NotificationStorage();
  final categoryStorage = CategoryStorage();
  final userStorage = UserStorage();

  await LocalNotificationService.instance.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(userStorage)..loadUser(),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(settingsStorage)..loadSettings(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) =>
              NotificationCubit(notificationStorage, settingsStorage)
                ..loadNotifications(),
        ),
        BlocProvider<FocusCubit>(
          create: (context) => FocusCubit(context.read<NotificationCubit>()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            taskStorage,
            context.read<NotificationCubit>(),
            settingsStorage,
          )..add(const LoadTasks()),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit(categoryStorage)..loadCategories(),
        ),
        BlocProvider<StreakCubit>(
          create: (_) => StreakCubit(StreakStorage(), settingsStorage),
        ),
      ],
      child: const TaskFlowApp(),
    ),
  );
}
