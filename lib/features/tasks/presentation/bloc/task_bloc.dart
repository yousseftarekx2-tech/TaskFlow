import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final List<TaskModel> _tasks = [];

  Timer? _overdueTimer;

  TaskBloc() : super(const TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<CompleteTask>(_onCompleteTask);
    on<MarkTaskOverdue>(_onMarkTaskOverdue);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RefreshTasks>(_onRefreshTasks);

    _startOverdueChecker();
  }

  // ============================================================
  // ADD TASK
  // ============================================================

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    final task = event.task;

    final TaskModel updatedTask =
        task.isPending && DateTime.now().isAfter(task.scheduledAt)
        ? task.copyWith(status: TaskStatus.overdue)
        : task;

    _tasks.add(updatedTask);

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // COMPLETE TASK
  // ============================================================

  void _onCompleteTask(CompleteTask event, Emitter<TaskState> emit) {
    final int index = _tasks.indexWhere((task) => task.id == event.taskId);

    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(status: TaskStatus.completed);

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // MARK TASK OVERDUE
  // ============================================================

  void _onMarkTaskOverdue(MarkTaskOverdue event, Emitter<TaskState> emit) {
    final int index = _tasks.indexWhere((task) => task.id == event.taskId);

    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(status: TaskStatus.overdue);

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }
  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    final int index = _tasks.indexWhere((task) => task.id == event.task.id);

    if (index == -1) {
      return;
    }

    _tasks[index] = event.task;

    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  // ============================================================
  // DELETE TASK
  // ============================================================

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) {
    _tasks.removeWhere((task) => task.id == event.taskId);

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

  void _onRefreshTasks(RefreshTasks event, Emitter<TaskState> emit) {
    emit(TaskLoaded(List.unmodifiable(_tasks)));
  }

  void _checkOverdueTasks() {
    if (_tasks.isEmpty || isClosed) {
      return;
    }

    final DateTime now = DateTime.now();

    bool hasChanges = false;

    for (int i = 0; i < _tasks.length; i++) {
      final TaskModel task = _tasks[i];

      if (task.isPending && !now.isBefore(task.scheduledAt)) {
        _tasks[i] = task.copyWith(status: TaskStatus.overdue);

        hasChanges = true;
      }
    }

    if (hasChanges) {
      add(RefreshTasks());
    }
  }

  @override
  Future<void> close() {
    _overdueTimer?.cancel();
    _overdueTimer = null;

    return super.close();
  }
}
