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

  static const Duration overdueDuration = Duration(hours: 1);

  final Set<String> _sentReminderTaskIds = {};
  final Set<String> _sentOverdueTaskIds = {};

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

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    try {
      await _ensureTasksLoaded();

      _checkOverdueTasks();
      await _checkTaskReminders();

      emit(TaskLoaded(List.unmodifiable(_tasks)));
    } catch (_) {
      emit(const TaskError('Failed to load tasks.'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    await _ensureTasksLoaded();

    final TaskModel task = event.task;
    final DateTime overdueAt = task.scheduledAt.add(overdueDuration);

    final bool isAlreadyOverdue =
        task.isPending && !DateTime.now().isBefore(overdueAt);

    final TaskModel updatedTask = isAlreadyOverdue
        ? task.copyWith(status: TaskStatus.overdue)
        : task;

    _tasks.add(updatedTask);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    if (isAlreadyOverdue) {
      await _addOverdueNotification(updatedTask);
    }

    await _checkTaskReminders();

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

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

    if (task.status == TaskStatus.completed) {
      return;
    }

    if (!task.isPending) {
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime startTime = task.scheduledAt;
    final DateTime overdueTime = task.scheduledAt.add(overdueDuration);

    if (now.isBefore(startTime)) {
      return;
    }

    if (!now.isBefore(overdueTime)) {
      return;
    }

    _tasks[index] = task.copyWith(status: TaskStatus.completed);

    _sentReminderTaskIds.remove(task.id);
    _sentOverdueTaskIds.remove(task.id);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    await notificationCubit.addNotification(
      type: NotificationType.taskCompleted,
      taskId: task.id,
      taskTitle: task.title,
    );

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

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

    if (task.status == TaskStatus.overdue) {
      return;
    }

    if (!task.isPending) {
      return;
    }

    final DateTime overdueTime = task.scheduledAt.add(overdueDuration);

    if (DateTime.now().isBefore(overdueTime)) {
      return;
    }

    _tasks[index] = task.copyWith(status: TaskStatus.overdue);

    _sentReminderTaskIds.remove(task.id);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    await _addOverdueNotification(_tasks[index]);

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    await _ensureTasksLoaded();

    final int index = _tasks.indexWhere((task) => task.id == event.task.id);

    if (index == -1) {
      return;
    }

    final TaskModel oldTask = _tasks[index];
    final TaskModel updatedTask = event.task;

    if (oldTask.scheduledAt != updatedTask.scheduledAt) {
      _sentReminderTaskIds.remove(updatedTask.id);
      _sentOverdueTaskIds.remove(updatedTask.id);
    }

    _tasks[index] = updatedTask;

    await taskStorage.saveTasks(List.unmodifiable(_tasks));
    await _checkTaskReminders();

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    await _ensureTasksLoaded();

    _tasks.removeWhere((task) => task.id == event.taskId);

    _sentReminderTaskIds.remove(event.taskId);
    _sentOverdueTaskIds.remove(event.taskId);

    await taskStorage.saveTasks(List.unmodifiable(_tasks));

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TaskState> emit,
  ) async {
    await _ensureTasksLoaded();

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

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

      if (!task.isPending) {
        continue;
      }

      final DateTime overdueTime = task.scheduledAt.add(overdueDuration);

      if (now.isBefore(overdueTime)) {
        continue;
      }

      final TaskModel overdueTask = task.copyWith(status: TaskStatus.overdue);

      _tasks[i] = overdueTask;
      hasChanges = true;

      if (!_sentOverdueTaskIds.contains(overdueTask.id)) {
        _sentOverdueTaskIds.add(overdueTask.id);

        unawaited(_addOverdueNotification(overdueTask));
      }

      _sentReminderTaskIds.remove(overdueTask.id);
    }

    if (!hasChanges) {
      return;
    }

    unawaited(taskStorage.saveTasks(List.unmodifiable(_tasks)));

    add(const RefreshTasks());
  }

  void _startReminderChecker() {
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      unawaited(_checkTaskReminders());
    });
  }

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
      if (!task.isPending) {
        continue;
      }

      final DateTime reminderTime = task.scheduledAt.subtract(
        Duration(minutes: reminderMinutes),
      );

      if (now.isBefore(reminderTime)) {
        continue;
      }

      if (!now.isBefore(task.scheduledAt)) {
        continue;
      }

      if (_sentReminderTaskIds.contains(task.id)) {
        continue;
      }

      _sentReminderTaskIds.add(task.id);

      await notificationCubit.addNotification(
        type: NotificationType.taskReminder,
        taskId: task.id,
        taskTitle: task.title,
      );
    }
  }

  Future<void> _addOverdueNotification(TaskModel task) async {
    if (_sentOverdueTaskIds.contains(task.id)) {
      return;
    }

    _sentOverdueTaskIds.add(task.id);

    await notificationCubit.addNotification(
      type: NotificationType.taskOverdue,
      taskId: task.id,
      taskTitle: task.title,
    );
  }

  @override
  Future<void> close() {
    _overdueTimer?.cancel();
    _overdueTimer = null;

    _reminderTimer?.cancel();
    _reminderTimer = null;

    return super.close();
  }
}
