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

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'scheduledAt': scheduledAt.toIso8601String(),
    };
  }

  // ============================================================
  // FROM JSON
  // ============================================================

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      status: TaskStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
    );
  }

  // ============================================================
  // COPY WITH
  // ============================================================

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
