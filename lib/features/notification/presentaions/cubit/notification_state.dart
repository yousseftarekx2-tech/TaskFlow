import 'package:equatable/equatable.dart';

import '../../data/model/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// ============================================================
// INITIAL
// ============================================================

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

// ============================================================
// LOADING
// ============================================================

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

// ============================================================
// LOADED
// ============================================================

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  const NotificationLoaded(this.notifications);

  int get unreadCount {
    return notifications.where((notification) => !notification.isRead).length;
  }

  @override
  List<Object?> get props => [notifications];
}

// ============================================================
// ERROR
// ============================================================

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
