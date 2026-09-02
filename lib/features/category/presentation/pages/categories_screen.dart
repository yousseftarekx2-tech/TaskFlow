import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/cubit/category_state.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';

import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';

import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool isSmallWidth = constraints.maxWidth < 360;

              final double horizontalPadding = isSmallWidth ? 16 : 20;

              return BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, categoryState) {
                  if (categoryState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<CategoryModel> categories =
                      categoryState.categories;

                  return ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      isSmallWidth ? 10 : 12,
                      horizontalPadding,
                      30,
                    ),
                    children: [
                      Text(
                        l10n.organizeYourTasks,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isSmallWidth ? 12 : 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      SizedBox(height: isSmallWidth ? 14 : 18),
                      ...categories.map(
                        (category) => _buildCategoryCard(
                          context,
                          category,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          textColor: primaryTextColor,
                          chevronColor: chevronColor,
                          isDarkMode: isDarkMode,
                          isSmallWidth: isSmallWidth,
                        ),
                      ),
                      SizedBox(height: isSmallWidth ? 10 : 14),
                      _buildAddCategoryButton(
                        context,
                        isDarkMode,
                        isSmallWidth,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category, {
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color chevronColor,
    required bool isDarkMode,
    required bool isSmallWidth,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            _openCategoryTasks(context, category);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallWidth ? 11 : 14,
              vertical: isSmallWidth ? 11 : 13,
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallWidth ? 40 : 44,
                  height: isSmallWidth ? 40 : 44,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    size: isSmallWidth ? 20 : 21,
                    color: category.color,
                  ),
                ),
                SizedBox(width: isSmallWidth ? 10 : 13),
                Expanded(
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(width: isSmallWidth ? 6 : 10),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!category.isDefault) ...[
                  SizedBox(width: isSmallWidth ? 2 : 4),
                  IconButton(
                    onPressed: () {
                      _confirmDeleteCategory(context, category, isDarkMode);
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: isSmallWidth ? 18 : 19,
                      color: isDarkMode
                          ? const Color(0xFFF87171)
                          : const Color(0xFFEF4444),
                    ),
                    tooltip: 'Delete',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ],
                SizedBox(width: isSmallWidth ? 2 : 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: isSmallWidth ? 18 : 19,
                  color: chevronColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCategoryTasks(BuildContext context, CategoryModel category) {
    final TaskBloc taskBloc = context.read<TaskBloc>();
    final SettingsCubit settingsCubit = context.read<SettingsCubit>();

    final List<TaskModel> categoryTasks = taskBloc.state is TaskLoaded
        ? (taskBloc.state as TaskLoaded).tasks
              .where((task) => task.category == category.name)
              .toList()
        : [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: taskBloc),
              BlocProvider.value(value: settingsCubit),
            ],
            child: CategoryTasksScreen(
              categoryName: category.name,
              tasks: categoryTasks,
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    CategoryModel category,
    bool isDarkMode,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            l10n.deleteCategoryTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            l10n.deleteCategoryMessage(category.name),
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDarkMode
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF64748B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
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
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l10n.delete,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<CategoryCubit>().deleteCategory(category.id);
  }

  Widget _buildAddCategoryButton(
    BuildContext context,
    bool isDarkMode,
    bool isSmallWidth,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      height: isSmallWidth ? 50 : 52,
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
            _showAddCategoryDialog(context, isDarkMode);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: isSmallWidth ? 20 : 21,
                color: Colors.white,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  l10n.addCategory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(
    BuildContext context,
    bool isDarkMode,
  ) async {
    final TextEditingController controller = TextEditingController();

    Color selectedColor = AppColors.needthis;

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;

          return StatefulBuilder(
            builder: (dialogContext, setState) {
              final double screenWidth = MediaQuery.sizeOf(dialogContext).width;

              final bool isSmallWidth = screenWidth < 360;

              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: isSmallWidth ? 16 : 24,
                  vertical: 24,
                ),
                backgroundColor: isDarkMode
                    ? const Color(0xFF1E293B)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Text(
                  l10n.addCategory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallWidth ? 17 : 18,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: l10n.categoryName,
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: isDarkMode
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: isSmallWidth ? 13 : 15,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallWidth ? 15 : 18),
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
                        spacing: isSmallWidth ? 8 : 10,
                        runSpacing: isSmallWidth ? 8 : 10,
                        children:
                            [
                              const Color(0xFF2563EB),
                              const Color(0xFFF97316),
                              const Color(0xFF16A34A),
                              const Color(0xFF8B5CF6),
                              const Color(0xFF14B8A6),
                              const Color(0xFFEF4444),
                              const Color(0xFFEC4899),
                              AppColors.needthis,
                            ].map((color) {
                              final bool selected = selectedColor == color;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                                child: Container(
                                  width: isSmallWidth ? 28 : 30,
                                  height: isSmallWidth ? 28 : 30,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: selected
                                        ? Border.all(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
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
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
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
                      final String name = controller.text.trim();

                      if (name.isEmpty) {
                        return;
                      }

                      await context.read<CategoryCubit>().addCategory(
                        name: name,
                        color: selectedColor,
                        icon: Icons.category_outlined,
                      );

                      if (!dialogContext.mounted) {
                        return;
                      }

                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.needthis,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      l10n.add,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      await WidgetsBinding.instance.endOfFrame;
    } finally {
      controller.dispose();
    }
  }
}
