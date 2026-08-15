import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int _selectedDuration = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 22),

              _buildCurrentTask(),

              const SizedBox(height: 36),

              _buildTimer(),

              const SizedBox(height: 28),

              _buildSessionProgress(),

              const SizedBox(height: 18),

              _buildDurationSelector(),

              const SizedBox(height: 18),

              _buildNextBreak(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Header
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus Timer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Stay focused, one session at a time.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.go(Routes.notifications);
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 20,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // Current Task
  // ------------------------------------------------------------

  Widget _buildCurrentTask() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.needthis,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prepare Presentation',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Work',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.needthis,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      '• 25 min session',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Timer
  // ------------------------------------------------------------

  Widget _buildTimer() {
    return Center(
      child: SizedBox(
        width: 184,
        height: 184,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 154,
              height: 154,
              child: CircularProgressIndicator(
                value: 0.70,
                strokeWidth: 8,
                backgroundColor: const Color(0xFFEDE9FE),
                color: AppColors.needthis,
              ),
            ),

            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '25:00',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Focus Session',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Session Progress
  // ------------------------------------------------------------

  Widget _buildSessionProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session 1 of 4',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF334155),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Today\'s Focus: 1h 20m',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.only(left: 4),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppColors.needthis
                      : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Duration Selector
  // ------------------------------------------------------------

  Widget _buildDurationSelector() {
    const durations = [25, 45, 60, 90];

    return Row(
      children: durations.map((duration) {
        final bool selected = _selectedDuration == duration;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: duration == durations.last ? 0 : 7),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDuration = duration;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.needthis : Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: selected
                        ? AppColors.needthis
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  '$duration min',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ------------------------------------------------------------
  // Next Break
  // ------------------------------------------------------------

  Widget _buildNextBreak() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.free_breakfast_outlined,
            size: 14,
            color: Color(0xFFF97316),
          ),

          const SizedBox(width: 7),

          const Expanded(
            child: Text(
              'Next Break: 5 min break after this session',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF97316),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
