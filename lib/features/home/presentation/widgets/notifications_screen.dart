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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationInitial) {
          context.read<NotificationCubit>().loadNotifications();
        }

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
                size: 18,
                color: colorScheme.onSurface,
              ),
            ),

            title: Text(
              AppLocalizations.of(context)!.notifications,

              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            centerTitle: false,

            actions: [
              if (state is NotificationLoaded &&
                  state.unreadCount > 0)
                TextButton(
                  onPressed: () {
                    context
                        .read<NotificationCubit>()
                        .markAllAsRead();
                  },

                  child: Text(
                    AppLocalizations.of(context)!.readAll,

                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.needthis,
                    ),
                  ),
                ),
            ],
          ),

          body: SafeArea(
            child: _buildBody(
              context,
              state,
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody(
    BuildContext context,
    NotificationState state,
  ) {
    if (state is NotificationLoading ||
        state is NotificationInitial) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.needthis,
        ),
      );
    }

    if (state is NotificationError) {
      return Center(
        child: Text(
          state.message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    if (state is NotificationLoaded) {
      if (state.notifications.isEmpty) {
        return _buildEmptyState(context);
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),

        children: [
          _buildHeader(
            context,
            state.unreadCount,
          ),

          const SizedBox(height: 16),

          ...state.notifications.map(
            (notification) => _buildNotificationCard(
              context,
              notification,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
    int unreadCount,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.recentNotifications,

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                l10n.stayUpdatedWithYourTasks,

                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        if (unreadCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: AppColors.needthis.withValues(
                alpha: 0.08,
              ),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Text(
              l10n.unreadCount(unreadCount),

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.needthis,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final notificationInfo = _getNotificationInfo(
      notification,
      l10n,
    );

    return GestureDetector(
      onTap: notification.isRead
          ? null
          : () {
              context
                  .read<NotificationCubit>()
                  .markAsRead(notification.id);
            },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: notification.isRead
              ? colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.35)
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
                      alpha: theme.brightness ==
                              Brightness.dark
                          ? 0.12
                          : 0.025,
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
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: notificationInfo.color.withValues(
                  alpha: 0.10,
                ),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                notificationInfo.icon,
                size: 21,
                color: notificationInfo.color,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          notificationInfo.title,

                          style: TextStyle(
                            fontSize: 13,

                            fontWeight:
                                notification.isRead
                                    ? FontWeight.w700
                                    : FontWeight.w800,

                            color:
                                colorScheme.onSurface,
                          ),
                        ),
                      ),

                      if (!notification.isRead)
                        Container(
                          width: 7,
                          height: 7,

                          margin:
                              const EdgeInsets.only(
                            top: 5,
                            left: 8,
                          ),

                          decoration:
                              const BoxDecoration(
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

                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color:
                          colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    _formatTime(
                      notification.createdAt,
                      l10n,
                    ),

                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.8),
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

  // ============================================================
  // NOTIFICATION INFO
  // ============================================================

  _NotificationInfo _getNotificationInfo(
    NotificationModel notification,
    AppLocalizations l10n,
  ) {
    switch (notification.type) {
      case NotificationType.taskCompleted:
        return _NotificationInfo(
          title: l10n.taskCompletedNotification,
          message: notification.taskTitle ??
              l10n.completedFlutterUiTask,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.needthis,
        );

      case NotificationType.taskOverdue:
        return _NotificationInfo(
          title: l10n.taskOverdueNotification,
          message:
              notification.taskTitle ??
              l10n.overdueTaskMessage,
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFEF4444),
        );

      case NotificationType.taskReminder:
        return _NotificationInfo(
          title: l10n.taskReminderNotification,
          message:
              notification.taskTitle ??
              l10n.taskStartsIn30Minutes,
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
        // TODO: Handle this case.
        throw UnimplementedError();
      case NotificationType.streak:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  // ============================================================
  // TIME
  // ============================================================

  String _formatTime(
    DateTime createdAt,
    AppLocalizations l10n,
  ) {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    }

    if (difference.inMinutes < 60) {
      return l10n.minutesAgo(
        difference.inMinutes,
      );
    }

    if (difference.inHours < 24) {
      return l10n.hourAgo(
        difference.inHours,
      );
    }

    if (difference.inDays == 1) {
      return l10n.yesterday;
    }

    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 40),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                color:
                    AppColors.needthis.withValues(
                  alpha: 0.08,
                ),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.notifications_none_rounded,
                size: 38,
                color: AppColors.needthis,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              l10n.noNotifications,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              l10n.allCaughtUp,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color:
                    colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NOTIFICATION INFO
// ============================================================

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