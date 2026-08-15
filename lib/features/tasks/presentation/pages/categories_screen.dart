import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(
        name: 'Design',
        color: const Color(0xFF2563EB),
        icon: Icons.design_services_outlined,
      ),
      _CategoryData(
        name: 'Meeting',
        color: const Color(0xFFF97316),
        icon: Icons.groups_outlined,
      ),
      _CategoryData(
        name: 'Development',
        color: const Color(0xFF16A34A),
        icon: Icons.code_rounded,
      ),
      _CategoryData(
        name: 'Work',
        color: const Color(0xFF8B5CF6),
        icon: Icons.work_outline_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xFF0F172A),
          ),
        ),

        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),

        children: [
          const Text(
            'Organize your tasks',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 18),

          ...categories.map((category) => _buildCategoryCard(category)),

          const SizedBox(height: 14),

          _buildAddCategoryButton(),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard(_CategoryData category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.7),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // ICON
          // ------------------------------------------------------
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(category.icon, size: 21, color: category.color),
          ),

          const SizedBox(width: 13),

          // ------------------------------------------------------
          // NAME
          // ------------------------------------------------------
          Expanded(
            child: Text(
              category.name,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),

          // ------------------------------------------------------
          // COLOR INDICATOR
          // ------------------------------------------------------
          Container(
            width: 8,
            height: 8,

            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.chevron_right_rounded,
            size: 19,
            color: Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Widget _buildAddCategoryButton() {
    return Container(
      height: 52,

      decoration: BoxDecoration(
        color: AppColors.needthis,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),

        child: InkWell(
          onTap: () {
            // Category logic will be added later.
          },

          borderRadius: BorderRadius.circular(14),

          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(Icons.add_rounded, size: 21, color: Colors.white),

              SizedBox(width: 7),

              Text(
                'Add Category',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY DATA
// ============================================================

class _CategoryData {
  final String name;
  final Color color;
  final IconData icon;

  const _CategoryData({
    required this.name,
    required this.color,
    required this.icon,
  });
}
