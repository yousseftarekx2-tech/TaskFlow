enum TaskStatus { pending, completed, overdue }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime scheduledAt;
  final DateTime? completedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.scheduledAt,
    this.completedAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  bool get isPending => status == TaskStatus.pending;

  bool get isOverdue => status == TaskStatus.overdue;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'scheduledAt': scheduledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final dynamic completedAtValue = json['completedAt'];

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
      completedAt: completedAtValue == null
          ? null
          : DateTime.parse(completedAtValue as String),
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? scheduledAt,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
