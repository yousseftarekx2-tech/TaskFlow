enum TaskStatus { pending, completed, overdue }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime scheduledAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.scheduledAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  bool get isPending => status == TaskStatus.pending;

  bool get isOverdue => status == TaskStatus.overdue;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? scheduledAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }
}
