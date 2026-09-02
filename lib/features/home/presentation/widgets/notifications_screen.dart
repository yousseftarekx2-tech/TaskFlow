import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/features/notification/data/model/notification_model.dart';
import 'package:task_flow/features/notification/presentaions/cubit/notification_cubit.dart';
import 'package:task_flow/features/notification/presentaions/cubit/notification_state.dart';

import 'package:task_flow/l10n/app_localizations.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationInitial) {
          context.read<NotificationCubit>().loadNotifications();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallWidth = constraints.maxWidth < 360;

            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => context.go(Routes.home),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: isSmallWidth ? 17 : 18,
                    color: colorScheme.onSurface,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.notifications,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 18 : 19,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                centerTitle: false,
                actions: [
                  if (state is NotificationLoaded && state.unreadCount > 0)
                    TextButton(
                      onPressed: () {
                        context.read<NotificationCubit>().markAllAsRead();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.readAll,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 11 : 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.needthis,
                        ),
                      ),
                    ),
                ],
              ),
              body: SafeArea(child: _buildBody(context, state, isSmallWidth)),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationState state,
    bool isSmallWidth,
  ) {
    if (state is NotificationLoading || state is NotificationInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.needthis),
      );
    }

    if (state is NotificationError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallWidth ? 24 : 32),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallWidth ? 12 : 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    if (state is NotificationLoaded) {
      if (state.notifications.isEmpty) {
        return _buildEmptyState(context, isSmallWidth);
      }

      return ListView(
        padding: EdgeInsets.fromLTRB(
          isSmallWidth ? 16 : 20,
          isSmallWidth ? 8 : 10,
          isSmallWidth ? 16 : 20,
          isSmallWidth ? 24 : 30,
        ),
        children: [
          _buildHeader(context, state.unreadCount, isSmallWidth),
          SizedBox(height: isSmallWidth ? 12 : 16),
          ...state.notifications.map(
            (notification) =>
                _buildNotificationCard(context, notification, isSmallWidth),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildHeader(
    BuildContext context,
    int unreadCount,
    bool isSmallWidth,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.recentNotifications,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 14 : 15,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.stayUpdatedWithYourTasks,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 11 : 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (unreadCount > 0) ...[
          SizedBox(width: isSmallWidth ? 8 : 12),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallWidth ? 8 : 10,
                vertical: isSmallWidth ? 5 : 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.needthis.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.unreadCount(unreadCount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallWidth ? 10 : 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.needthis,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
    bool isSmallWidth,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final _NotificationInfo notificationInfo = _getNotificationInfo(
      notification,
      l10n,
    );

    final double iconContainerSize = isSmallWidth ? 40 : 44;

    final double iconSize = isSmallWidth ? 19 : 21;

    final double cardPadding = isSmallWidth ? 12 : 14;

    return GestureDetector(
      onTap: notification.isRead
          ? null
          : () {
              context.read<NotificationCubit>().markAsRead(notification.id);
            },
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallWidth ? 8 : 10),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: notification.isRead
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: notification.isRead
                ? colorScheme.outline.withValues(alpha: 0.20)
                : colorScheme.outline.withValues(alpha: 0.35),
            width: 0.7,
          ),
          boxShadow: notification.isRead
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.12 : 0.025,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: notificationInfo.color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notificationInfo.icon,
                size: iconSize,
                color: notificationInfo.color,
              ),
            ),
            SizedBox(width: isSmallWidth ? 10 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notificationInfo.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 12 : 13,
                            fontWeight: notification.isRead
                                ? FontWeight.w700
                                : FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(top: 5, left: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.needthis,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notificationInfo.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 10 : 11,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    _formatTime(notification.createdAt, l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 9 : 10,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _NotificationInfo _getNotificationInfo(
    NotificationModel notification,
    AppLocalizations l10n,
  ) {
    switch (notification.type) {
      case NotificationType.taskCompleted:
        return _NotificationInfo(
          title: l10n.taskCompletedNotification,
          message: notification.taskTitle ?? l10n.completedFlutterUiTask,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.needthis,
        );

      case NotificationType.taskOverdue:
        return _NotificationInfo(
          title: l10n.taskOverdueNotification,
          message: notification.taskTitle ?? l10n.overdueTaskMessage,
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFEF4444),
        );

      case NotificationType.taskReminder:
        return _NotificationInfo(
          title: l10n.taskReminderNotification,
          message: notification.taskTitle ?? l10n.taskStartsIn30Minutes,
          icon: Icons.access_time_rounded,
          color: const Color(0xFF2563EB),
        );

      case NotificationType.focusSessionFinished:
        return _NotificationInfo(
          title: l10n.focusSessionFinishedNotification,
          message: l10n.focusSessionFinishedMessage,
          icon: Icons.center_focus_strong,
          color: const Color(0xFF8B5CF6),
        );

      case NotificationType.breakStarted:
        return _NotificationInfo(
          title: l10n.breakStartedNotification,
          message: l10n.breakStartedMessage,
          icon: Icons.free_breakfast_outlined,
          color: const Color(0xFF10B981),
        );

      case NotificationType.breakFinished:
        return _NotificationInfo(
          title: l10n.breakFinishedNotification,
          message: l10n.breakFinishedMessage,
          icon: Icons.timer_outlined,
          color: const Color(0xFF2563EB),
        );

      case NotificationType.dailyApp:
        return _NotificationInfo(
          title: l10n.notificationDailyAppTitle,
          message: l10n.notificationDailyAppBody,
          icon: Icons.wb_sunny_outlined,
          color: const Color(0xFFF59E0B),
        );

      case NotificationType.streak:
        return _NotificationInfo(
          title: l10n.notificationStreakTitle,
          message: l10n.notificationStreakBody,
          icon: Icons.local_fire_department_outlined,
          color: const Color(0xFFEF4444),
        );
    }
  }

  String _formatTime(DateTime createdAt, AppLocalizations l10n) {
    final Duration difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    }

    if (difference.inMinutes < 60) {
      return l10n.minutesAgo(difference.inMinutes);
    }

    if (difference.inHours < 24) {
      return l10n.hourAgo(difference.inHours);
    }

    if (difference.inDays == 1) {
      return l10n.yesterday;
    }

    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  Widget _buildEmptyState(BuildContext context, bool isSmallWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isShortHeight = constraints.maxHeight < 600;

        final double iconContainerSize = isSmallWidth ? 66 : 76;

        final double iconSize = isSmallWidth ? 32 : 38;

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallWidth ? 24 : 40,
              vertical: isShortHeight ? 16 : 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    color: AppColors.needthis.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: iconSize,
                    color: AppColors.needthis,
                  ),
                ),
                SizedBox(height: isSmallWidth ? 14 : 18),
                Text(
                  l10n.noNotifications,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 16 : 18,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: isSmallWidth ? 6 : 7),
                Text(
                  l10n.allCaughtUp,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 11 : 12,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationInfo {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const _NotificationInfo({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });
}
