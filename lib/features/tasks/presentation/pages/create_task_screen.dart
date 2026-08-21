import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/category/cubit/category_cubit.dart';
import 'package:task_flow/features/category/cubit/category_state.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_flow/features/settings/presnetation/cubit/settings_cubit.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class CreateTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const CreateTaskScreen({super.key, this.task});

  bool get isEditing => task != null;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    final TaskModel? task = widget.task;

    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;

      _selectedCategory = task.category;

      _selectedDate = DateTime(
        task.scheduledAt.year,
        task.scheduledAt.month,
        task.scheduledAt.day,
      );

      _selectedTime = TimeOfDay(
        hour: task.scheduledAt.hour,
        minute: task.scheduledAt.minute,
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  // ============================================================
  // DATE
  // ============================================================

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();

    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime selectedDate = _selectedDate != null
        ? DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
          )
        : today;

    final DateTime firstDate = selectedDate.isBefore(today)
        ? selectedDate
        : today;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5, now.month, now.day),
      builder: (context, child) {
        final bool isDark = context.read<SettingsCubit>().state.darkModeEnabled;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.needthis,
                    onPrimary: Colors.white,
                    surface: const Color(0xFF1E293B),
                    onSurface: Colors.white,
                  )
                : ColorScheme.light(
                    primary: AppColors.needthis,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: const Color(0xFF0F172A),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // ============================================================
  // TIME
  // ============================================================

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        final bool isDark = context.read<SettingsCubit>().state.darkModeEnabled;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.needthis,
                    onPrimary: Colors.white,
                    surface: const Color(0xFF1E293B),
                    onSurface: Colors.white,
                  )
                : ColorScheme.light(
                    primary: AppColors.needthis,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: const Color(0xFF0F172A),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || pickedTime == null) {
      return;
    }

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(AppLocalizations l10n) {
    if (_selectedDate == null) {
      return l10n.selectDate;
    }

    final DateTime date = _selectedDate!;

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(AppLocalizations l10n) {
    if (_selectedTime == null) {
      return l10n.selectTime;
    }

    return _selectedTime!.format(context);
  }

  // ============================================================
  // BUILD SCHEDULED AT
  // ============================================================

  DateTime _buildScheduledAt() {
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  // ============================================================
  // SAVE TASK
  // ============================================================

  void _saveTask() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final String title = _titleController.text.trim();

    final String description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.taskTitleRequired)));

      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.categoryRequired)));

      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dateRequired)));

      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.timeRequired)));

      return;
    }

    final DateTime scheduledAt = _buildScheduledAt();

    final TaskBloc taskBloc = context.read<TaskBloc>();

    // ==========================================================
    // EDIT
    // ==========================================================

    if (widget.isEditing) {
      final TaskModel oldTask = widget.task!;

      final DateTime now = DateTime.now();

      TaskStatus newStatus = oldTask.status;

      if (oldTask.isCompleted) {
        newStatus = TaskStatus.completed;
      } else if (!scheduledAt.isAfter(now)) {
        newStatus = TaskStatus.overdue;
      } else {
        newStatus = TaskStatus.pending;
      }

      final TaskModel updatedTask = oldTask.copyWith(
        title: title,
        description: description,
        category: _selectedCategory!,
        status: newStatus,
        scheduledAt: scheduledAt,
      );

      taskBloc.add(UpdateTask(updatedTask));

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      return;
    }

    // ==========================================================
    // CREATE
    // ==========================================================

    final DateTime now = DateTime.now();

    final TaskModel newTask = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: _selectedCategory!,
      status: scheduledAt.isBefore(now)
          ? TaskStatus.overdue
          : TaskStatus.pending,
      createdAt: now,
      scheduledAt: scheduledAt,
    );

    taskBloc.add(AddTask(newTask));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.taskCreatedSuccessfully)));

    Navigator.pop(context);
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<void> _showAddCategoryDialog() async {
    final CategoryModel? result = await showDialog<CategoryModel>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return const _AddCategoryDialog();
      },
    );

    if (!mounted || result == null) {
      return;
    }

    await context.read<CategoryCubit>().addCategory(
      name: result.name,
      color: result.color,
      icon: result.icon,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedCategory = result.name;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final bool isEditing = widget.isEditing;

    final settingsState = context.watch<SettingsCubit>().state;

    final bool isDark = settingsState.darkModeEnabled;

    final Color backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final Color primaryTextColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = const Color(0xFF94A3B8);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: primaryTextColor,
          ),
        ),

        title: Text(
          isEditing ? l10n.editTaskTitle : l10n.createTaskTitle,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
          ),
        ),
      ),

      // ==========================================================
      // CATEGORY CUBIT
      // ==========================================================
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          final List<CategoryModel> categories = categoryState.categories;

          final String? selectedCategory =
              _selectedCategory ??
              (categories.isNotEmpty ? categories.first.name : null);

          return SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildLabel(l10n.taskTitleLabel, isDark: isDark),

                  const SizedBox(height: 9),

                  _buildTextField(
                    controller: _titleController,
                    hint: l10n.taskTitleHint,
                    isDark: isDark,
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    borderColor: borderColor,
                    secondaryTextColor: secondaryTextColor,
                  ),

                  const SizedBox(height: 21),

                  _buildLabel(l10n.descriptionLabel, isDark: isDark),

                  const SizedBox(height: 9),

                  _buildTextField(
                    controller: _descriptionController,
                    hint: l10n.descriptionHint,
                    maxLines: 4,
                    isDark: isDark,
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    borderColor: borderColor,
                    secondaryTextColor: secondaryTextColor,
                  ),

                  const SizedBox(height: 21),

                  _buildLabel(l10n.categoryLabel, isDark: isDark),

                  const SizedBox(height: 11),

                  if (categories.isNotEmpty)
                    Wrap(
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        ...categories.map(
                          (category) => _buildCategoryChip(
                            category,
                            selectedCategory: selectedCategory,
                          ),
                        ),
                        _buildAddCategoryChip(
                          isDark: isDark,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          l10n: l10n,
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Text(
                          l10n.noCategoriesYet,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),

                        const SizedBox(width: 10),

                        _buildAddCategoryChip(
                          isDark: isDark,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          l10n: l10n,
                        ),
                      ],
                    ),

                  const SizedBox(height: 22),

                  _buildLabel(l10n.dateLabel, isDark: isDark),

                  const SizedBox(height: 9),

                  _buildSelectField(
                    icon: Icons.calendar_today_outlined,
                    text: _formatDate(l10n),
                    selected: _selectedDate != null,
                    onTap: _selectDate,
                    isDark: isDark,
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    borderColor: borderColor,
                    secondaryTextColor: secondaryTextColor,
                  ),

                  const SizedBox(height: 21),

                  _buildLabel(l10n.timeLabel, isDark: isDark),

                  const SizedBox(height: 9),

                  _buildSelectField(
                    icon: Icons.access_time_outlined,
                    text: _formatTime(l10n),
                    selected: _selectedTime != null,
                    onTap: _selectTime,
                    isDark: isDark,
                    cardColor: cardColor,
                    primaryTextColor: primaryTextColor,
                    borderColor: borderColor,
                    secondaryTextColor: secondaryTextColor,
                  ),

                  const SizedBox(height: 34),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      onPressed: _saveTask,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.needthis,
                        foregroundColor: Colors.white,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(
                        isEditing ? l10n.saveChanges : l10n.createTask,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text, {required bool isDark}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required Color cardColor,
    required Color primaryTextColor,
    required Color borderColor,
    required Color secondaryTextColor,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: secondaryTextColor,
        ),

        filled: true,
        fillColor: cardColor,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 0.7),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 0.7),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.needthis, width: 1),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CHIP
  // ============================================================

  Widget _buildCategoryChip(
    CategoryModel category, {
    required String? selectedCategory,
  }) {
    final bool selected = selectedCategory == category.name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category.name;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        curve: Curves.easeOut,

        padding: EdgeInsets.symmetric(
          horizontal: selected ? 15 : 13,
          vertical: selected ? 10 : 8,
        ),

        decoration: BoxDecoration(
          color: category.color.withValues(alpha: 0.10),

          borderRadius: BorderRadius.circular(selected ? 10 : 9),

          border: Border.all(
            color: selected
                ? category.color.withValues(alpha: 0.40)
                : category.color.withValues(alpha: 0.08),
            width: selected ? 1.1 : 0.8,
          ),
        ),

        child: Text(
          category.name,

          style: TextStyle(
            fontSize: selected ? 13 : 12,
            fontWeight: FontWeight.w700,
            color: category.color,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADD CATEGORY CHIP
  // ============================================================

  Widget _buildAddCategoryChip({
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color secondaryTextColor,
    required AppLocalizations l10n,
  }) {
    return GestureDetector(
      onTap: _showAddCategoryDialog,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius: BorderRadius.circular(9),

          border: Border.all(
            color: isDark ? const Color(0xFF475569) : const Color(0xFFD6DCE5),
            width: 0.8,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.add_rounded, size: 15, color: secondaryTextColor),

            const SizedBox(width: 4),

            Text(
              l10n.addCategory,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SELECT FIELD
  // ============================================================

  Widget _buildSelectField({
    required IconData icon,
    required String text,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardColor,
    required Color primaryTextColor,
    required Color borderColor,
    required Color secondaryTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        height: 50,

        padding: const EdgeInsets.symmetric(horizontal: 15),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: borderColor, width: 0.7),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.needthis : secondaryTextColor,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                text,

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? primaryTextColor : secondaryTextColor,
                ),
              ),
            ),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADD CATEGORY DIALOG
// ============================================================

class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog();

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  Color _selectedColor = AppColors.needthis;

  static const List<Color> _colors = [
    Color(0xFF2563EB),
    Color(0xFFF97316),
    Color(0xFF16A34A),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF0EA5E9),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCategory() {
    final String name = _controller.text.trim();

    if (name.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    final CategoryModel category = CategoryModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      color: _selectedColor,
      icon: Icons.category_outlined,
      isDefault: false,
    );

    Navigator.of(context).pop(category);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final bool isDark = context.watch<SettingsCubit>().state.darkModeEnabled;

    final Color dialogBackground = isDark
        ? const Color(0xFF1E293B)
        : Colors.white;

    final Color primaryTextColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A);

    final Color secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final Color fieldBackground = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return AlertDialog(
      backgroundColor: dialogBackground,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      title: Text(
        l10n.addCategoryTitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
        ),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            l10n.categoryNameLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryTextColor,
            ),
          ),

          const SizedBox(height: 9),

          TextField(
            controller: _controller,

            style: TextStyle(fontSize: 13, color: primaryTextColor),

            decoration: InputDecoration(
              hintText: l10n.categoryNameHint,

              hintStyle: TextStyle(fontSize: 12, color: secondaryTextColor),

              filled: true,
              fillColor: fieldBackground,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(color: borderColor),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(color: borderColor),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: AppColors.needthis),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            l10n.chooseColor,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryTextColor,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,

            children: _colors.map((color) {
              final bool selected = _selectedColor == color;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),

                  width: 32,
                  height: 32,

                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,

                    border: selected
                        ? Border.all(color: primaryTextColor, width: 2)
                        : null,
                  ),

                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();

            Navigator.of(context).pop();
          },

          child: Text(
            l10n.cancel,
            style: TextStyle(
              color: secondaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: _addCategory,

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.needthis,
            foregroundColor: Colors.white,
            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          child: Text(
            l10n.addCategory,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
