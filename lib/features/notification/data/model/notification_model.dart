enum NotificationType {
  taskCompleted,
  taskOverdue,
  taskReminder,
  focusSessionFinished,
  breakStarted,
  breakFinished,
  dailyApp,
  streak,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String? taskId;
  final String? taskTitle;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    this.taskId,
    this.taskTitle,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? taskId,
    String? taskTitle,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'taskId': taskId,
      'taskTitle': taskTitle,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      type: NotificationType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => NotificationType.taskReminder,
      ),
      taskId: map['taskId'] as String?,
      taskTitle: map['taskTitle'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isRead: map['isRead'] as bool? ?? false,
    );
  }
}