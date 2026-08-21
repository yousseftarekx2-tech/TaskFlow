import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/cubit/category_state.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';

import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';

import 'package:task_flow/features/tasks/presentation/pages/category_tasks_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final bool isDarkMode = settingsState.darkModeEnabled;

        final AppLocalizations l10n = AppLocalizations.of(context)!;

        final Color backgroundColor = isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC);

        final Color cardColor = isDarkMode
            ? const Color(0xFF1E293B)
            : Colors.white;

        final Color primaryTextColor = isDarkMode
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF1E293B);

        final Color titleColor = isDarkMode
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF0F172A);

        final Color borderColor = isDarkMode
            ? const Color(0xFF334155)
            : const Color(0xFFE2E8F0);

        final Color iconColor = isDarkMode
            ? const Color(0xFFCBD5E1)
            : const Color(0xFF0F172A);

        final Color chevronColor = isDarkMode
            ? const Color(0xFF64748B)
            : const Color(0xFFCBD5E1);

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: iconColor,
              ),
            ),

            title: Text(
              l10n.categories,

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
          ),

          body: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, categoryState) {
              if (categoryState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<CategoryModel> categories =
                  categoryState.categories;

              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  30,
                ),

                children: [
                  Text(
                    l10n.organizeYourTasks,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 18),

                  ...categories.map(
                    (category) => _buildCategoryCard(
                      context,
                      category,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: primaryTextColor,
                      chevronColor: chevronColor,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildAddCategoryButton(
                    context,
                    isDarkMode,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category, {
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color chevronColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: borderColor,
          width: 0.7,
        ),
      ),

      child: Material(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(14),

        child: InkWell(
          borderRadius: BorderRadius.circular(14),

          onTap: () {
            _openCategoryTasks(
              context,
              category,
            );
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),

            child: Row(
              children: [
                // ==================================================
                // ICON
                // ==================================================

                Container(
                  width: 44,
                  height: 44,

                  decoration: BoxDecoration(
                    color: category.color.withValues(
                      alpha: 0.10,
                    ),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    category.icon,
                    size: 21,
                    color: category.color,
                  ),
                ),

                const SizedBox(width: 13),

                // ==================================================
                // NAME
                // ==================================================

                Expanded(
                  child: Text(
                    category.name,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),

                // ==================================================
                // COLOR INDICATOR
                // ==================================================

                Container(
                  width: 8,
                  height: 8,

                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 10),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 19,
                  color: chevronColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN CATEGORY TASKS
  // ============================================================

  void _openCategoryTasks(
    BuildContext context,
    CategoryModel category,
  ) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) => CategoryTasksScreen(
          categoryName: category.name, tasks: [],
        ),
      ),
    );
  }

  // ============================================================
  // ADD CATEGORY BUTTON
  // ============================================================

  Widget _buildAddCategoryButton(
    BuildContext context,
    bool isDarkMode,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context)!;

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
          borderRadius: BorderRadius.circular(14),

          onTap: () {
            _showAddCategoryDialog(
              context,
              isDarkMode,
            );
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.add_rounded,
                size: 21,
                color: Colors.white,
              ),

              const SizedBox(width: 7),

              Text(
                l10n.addCategory,

                style: const TextStyle(
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

  // ============================================================
  // ADD CATEGORY DIALOG
  // ============================================================

  void _showAddCategoryDialog(
    BuildContext context,
    bool isDarkMode,
  ) {
    final TextEditingController controller =
        TextEditingController();

    Color selectedColor = AppColors.needthis;

    showDialog(
      context: context,

      builder: (dialogContext) {
        final AppLocalizations l10n =
            AppLocalizations.of(dialogContext)!;

        return StatefulBuilder(
          builder: (
            dialogContext,
            setState,
          ) {
            return AlertDialog(
              backgroundColor: isDarkMode
                  ? const Color(0xFF1E293B)
                  : Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              title: Text(
                l10n.addCategory,

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDarkMode
                      ? Colors.white
                      : const Color(0xFF0F172A),
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  TextField(
                    controller: controller,

                    textCapitalization:
                        TextCapitalization.words,

                    decoration: InputDecoration(
                      hintText: l10n.categoryName,

                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                      ),

                      filled: true,

                      fillColor: isDarkMode
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    l10n.chooseColor,

                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: [
                      const Color(0xFF2563EB),
                      const Color(0xFFF97316),
                      const Color(0xFF16A34A),
                      const Color(0xFF8B5CF6),
                      const Color(0xFF14B8A6),
                      const Color(0xFFEF4444),
                      const Color(0xFFEC4899),
                      AppColors.needthis,
                    ].map((color) {
                      final bool selected =
                          selectedColor == color;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },

                        child: Container(
                          width: 30,
                          height: 30,

                          decoration: BoxDecoration(
                            color: color,

                            shape: BoxShape.circle,

                            border: selected
                                ? Border.all(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(
                                            0xFF0F172A,
                                          ),
                                    width: 3,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },

                  child: Text(
                    l10n.cancel,

                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final String name =
                        controller.text.trim();

                    if (name.isEmpty) {
                      return;
                    }

                    await context
                        .read<CategoryCubit>()
                        .addCategory(
                          name: name,
                          color: selectedColor,
                          icon: Icons.category_outlined,
                        );

                    if (!dialogContext.mounted) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.needthis,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  child: Text(
                    l10n.add,

                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }
}