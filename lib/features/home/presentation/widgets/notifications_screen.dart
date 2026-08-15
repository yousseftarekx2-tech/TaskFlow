import 'package:flutter/material.dart';

import 'package:task_flow/core/constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationData(
        title: 'Task completed',
        message: 'You completed your Flutter UI task.',
        time: '10 min ago',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.needthis,
        unread: true,
      ),
      _NotificationData(
        title: 'Task overdue',
        message: 'Your "Review project design" task is overdue.',
        time: '1 hour ago',
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFEF4444),
        unread: true,
      ),
      _NotificationData(
        title: 'Task reminder',
        message: 'Your development task starts in 30 minutes.',
        time: '2 hours ago',
        icon: Icons.access_time_rounded,
        color: const Color(0xFF2563EB),
        unread: false,
      ),
      _NotificationData(
        title: 'Task completed',
        message: 'You completed the team meeting task.',
        time: 'Yesterday',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.needthis,
        unread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
        ),

        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              // UI only for now.
            },
            child: const Text(
              'Read all',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.needthis,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: notifications.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                children: [
                  _buildHeader(),

                  const SizedBox(height: 16),

                  ...notifications.map(
                    (notification) => _buildNotificationCard(notification),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent notifications',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Stay updated with your tasks.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.needthis.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '2 unread',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.needthis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(_NotificationData notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: notification.unread ? Colors.white : const Color(0xFFFBFCFE),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: notification.unread
              ? const Color(0xFFDCE4EE)
              : const Color(0xFFE7ECF2),
          width: 0.7,
        ),

        boxShadow: notification.unread
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color: notification.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(notification.icon, size: 21, color: notification.color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: notification.unread
                              ? FontWeight.w800
                              : FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),

                    if (notification.unread)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(top: 5, left: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.needthis,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  notification.time,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                color: AppColors.needthis.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.notifications_none_rounded,
                size: 38,
                color: AppColors.needthis,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'You are all caught up. New task updates and reminders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationData {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final bool unread;

  const _NotificationData({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.unread,
  });
}
