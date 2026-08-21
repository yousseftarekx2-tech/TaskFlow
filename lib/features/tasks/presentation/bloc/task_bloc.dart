import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/storage/settings_storage.dart';
import 'package:task_flow/core/storage/task_storage.dart';
import 'package:task_flow/features/notification/data/model/notification_model.dart';
import 'package:task_flow/features/notification/presentaions/cubit/notification_cubit.dart';

import '../../data/model/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskStorage taskStorage;

  final NotificationCubit notificationCubit;

  final SettingsStorage settingsStorage;

  final List<TaskModel> _tasks = [];

  Timer? _overdueTimer;

  Timer? _reminderTimer;

  bool _isLoaded = false;

  Future<void>? _loadingFuture;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  TaskBloc(this.taskStorage, this.notificationCubit, this.settingsStorage)
    : super(const TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<CompleteTask>(_onCompleteTask);
    on<MarkTaskOverdue>(_onMarkTaskOverdue);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RefreshTasks>(_onRefreshTasks);
    on<LoadTasks>(_onLoadTasks);

    _startOverdueChecker();
    _startReminderChecker();
  }

  // ============================================================
  // ENSURE TASKS ARE LOADED
  // ============================================================

  Future<void> _ensureTasksLoaded() async {
    if (_isLoaded) {
      return;
    }

    _loadingFuture ??= _loadTasksFromStorage();

    await _loadingFuture;
  }

  Future<void> _loadTasksFromStorage() async {
    final List<TaskModel> storedTasks = await taskStorage.getTasks();

    _tasks
      ..clear()
      ..addAll(storedTasks);

    _isLoaded = true;
  }

  // ============================================================
  // LOAD TASKS
  // ============================================================

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    try {
      await _ensureTasksLoaded();

      _checkOverdueTasks();

      await _checkTaskReminders();

      emit(TaskLoaded(List.unmodifiable(_tasks)));
    } catch (e) {
      emit(const TaskError('Failed to load tasks.'));
    }
  }

  // ============================================================
  // ADD TASK
  // ============================================================

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    await _ensureTasksLoaded();

    final TaskModel task = event.task;

    final bool isAlreadyOverdue =
        task.isPending && DateTime.now().isAfter(task.scheduledAt);

    final TaskModel updatedTask = isAlreadyOverdue
        ? task.copyWith(status: TaskStatus.overdue)
        : task;

    _tasks.add(updatedTask);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    // ============================================================
    // OVERDUE NOTIFICATION
    // ============================================================

    if (isAlreadyOverdue) {
      await _addOverdueNotification(updatedTask);
    }

    // ============================================================
    // CHECK REMINDER
    // ============================================================

    await _checkTaskReminders();

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // COMPLETE TASK
  // ============================================================

  Future<void> _onCompleteTask(
    CompleteTask event,
    Emitter<TaskState> emit,
  ) async {
    await _ensureTasksLoaded();

    final int index = _tasks.indexWhere((task) => task.id == event.taskId);

    if (index == -1) {
      return;
    }

    final TaskModel task = _tasks[index];

    // ============================================================
    // PREVENT DUPLICATE COMPLETION
    // ============================================================

    if (task.status == TaskStatus.completed) {
      return;
    }

    _tasks[index] = task.copyWith(status: TaskStatus.completed);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    // ============================================================
    // COMPLETED NOTIFICATION
    // ============================================================

    await notificationCubit.addNotification(
      type: NotificationType.taskCompleted,
      taskId: task.id,
      taskTitle: task.title,
    );

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // MARK TASK OVERDUE
  // ============================================================

  Future<void> _onMarkTaskOverdue(
    MarkTaskOverdue event,
    Emitter<TaskState> emit,
  ) async {
    await _ensureTasksLoaded();

    final int index = _tasks.indexWhere((task) => task.id == event.taskId);

    if (index == -1) {
      return;
    }

    final TaskModel task = _tasks[index];

    // ============================================================
    // PREVENT DUPLICATE OVERDUE NOTIFICATION
    // ============================================================

    if (task.status == TaskStatus.overdue) {
      return;
    }

    _tasks[index] = task.copyWith(status: TaskStatus.overdue);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    // ============================================================
    // OVERDUE NOTIFICATION
    // ============================================================

    await _addOverdueNotification(_tasks[index]);

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // UPDATE TASK
  // ============================================================

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    await _ensureTasksLoaded();

    final int index = _tasks.indexWhere((task) => task.id == event.task.id);

    if (index == -1) {
      return;
    }

    _tasks[index] = event.task;

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    await _checkTaskReminders();

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // DELETE TASK
  // ============================================================

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    await _ensureTasksLoaded();

    _tasks.removeWhere((task) => task.id == event.taskId);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // REFRESH TASKS
  // ============================================================

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TaskState> emit,
  ) async {
    await _ensureTasksLoaded();

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // OVERDUE CHECKER
  // ============================================================

  void _startOverdueChecker() {
    _overdueTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkOverdueTasks();
    });
  }

  void _checkOverdueTasks() {
    if (_tasks.isEmpty || isClosed || !_isLoaded) {
      return;
    }

    final DateTime now = DateTime.now();

    bool hasChanges = false;

    for (int i = 0; i < _tasks.length; i++) {
      final TaskModel task = _tasks[i];

      if (task.isPending && !now.isBefore(task.scheduledAt)) {
        final TaskModel overdueTask = task.copyWith(status: TaskStatus.overdue);

        _tasks[i] = overdueTask;

        hasChanges = true;

        // ========================================================
        // OVERDUE NOTIFICATION
        // ========================================================

        _addOverdueNotification(overdueTask);
      }
    }

    if (hasChanges) {
      taskStorage.saveTasks(List.unmodifiable(_tasks));

      add(const RefreshTasks());
    }
  }

  // ============================================================
  // REMINDER CHECKER
  // ============================================================

  void _startReminderChecker() {
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkTaskReminders();
    });
  }

  // ============================================================
  // CHECK TASK REMINDERS
  // ============================================================

  Future<void> _checkTaskReminders() async {
    if (_tasks.isEmpty || isClosed || !_isLoaded) {
      return;
    }

    final bool notificationsEnabled = await settingsStorage
        .getNotificationsEnabled();

    final bool taskRemindersEnabled = await settingsStorage
        .getTaskRemindersEnabled();

    if (!notificationsEnabled || !taskRemindersEnabled) {
      return;
    }

    final int reminderMinutes = await settingsStorage.getTaskReminderMinutes();

    final DateTime now = DateTime.now();

    for (final TaskModel task in _tasks) {
      // ==========================================================
      // ONLY PENDING TASKS
      // ==========================================================

      if (!task.isPending) {
        continue;
      }

      // ==========================================================
      // REMINDER TIME
      // ==========================================================

      final DateTime reminderTime = task.scheduledAt.subtract(
        Duration(minutes: reminderMinutes),
      );

      // ==========================================================
      // TOO EARLY
      // ==========================================================

      if (now.isBefore(reminderTime)) {
        continue;
      }

      // ==========================================================
      // TASK ALREADY STARTED / OVERDUE
      // ==========================================================

      if (!now.isBefore(task.scheduledAt)) {
        continue;
      }

      // ==========================================================
      // SEND REMINDER
      // ==========================================================

      await notificationCubit.addNotification(
        type: NotificationType.taskReminder,
        taskId: task.id,
        taskTitle: task.title,
      );
    }
  }

  // ============================================================
  // ADD OVERDUE NOTIFICATION
  // ============================================================

  Future<void> _addOverdueNotification(TaskModel task) async {
    await notificationCubit.addNotification(
      type: NotificationType.taskOverdue,
      taskId: task.id,
      taskTitle: task.title,
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  Future<void> close() {
    _overdueTimer?.cancel();
    _overdueTimer = null;

    _reminderTimer?.cancel();
    _reminderTimer = null;

    return super.close();
  }
}
