import 'package:equatable/equatable.dart';

import '../../data/model/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final TaskModel task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class CompleteTask extends TaskEvent {
  final String taskId;

  const CompleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class MarkTaskOverdue extends TaskEvent {
  final String taskId;

  const MarkTaskOverdue(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class RefreshTasks extends TaskEvent {
  const RefreshTasks();
}

class UpdateTask extends TaskEvent {
  final TaskModel task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}
