import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/tasks/data/model/task_model.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_event.dart';

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

  final List<TaskCategory> _categories = [
    const TaskCategory(name: 'Design', color: Color(0xFF2563EB)),
    const TaskCategory(name: 'Meeting', color: Color(0xFFF97316)),
    const TaskCategory(name: 'Development', color: Color(0xFF16A34A)),
    const TaskCategory(name: 'Work', color: Color(0xFF8B5CF6)),
  ];

  String _selectedCategory = 'Design';

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

      // Add existing category if it doesn't exist.
      if (!_categories.any((category) => category.name == task.category)) {
        _categories.add(
          TaskCategory(
            name: task.category,
            color: _categoryColor(task.category),
          ),
        );
      }
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

    // Allow the old date when editing.
    final DateTime firstDate = selectedDate.isBefore(today)
        ? selectedDate
        : today;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
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
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
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

  String _formatDate() {
    if (_selectedDate == null) {
      return 'Select date';
    }

    final DateTime date = _selectedDate!;

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime() {
    if (_selectedTime == null) {
      return 'Select time';
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
    final String title = _titleController.text.trim();

    final String description = _descriptionController.text.trim();

    // ----------------------------------------------------------
    // TITLE VALIDATION
    // ----------------------------------------------------------

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );

      return;
    }

    // ----------------------------------------------------------
    // DATE VALIDATION
    // ----------------------------------------------------------

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));

      return;
    }

    // ----------------------------------------------------------
    // TIME VALIDATION
    // ----------------------------------------------------------

    if (_selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a time')));

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

      // Completed stays completed.
      if (oldTask.isCompleted) {
        newStatus = TaskStatus.completed;
      }
      // New scheduled time has already passed.
      else if (!scheduledAt.isAfter(now)) {
        newStatus = TaskStatus.overdue;
      }
      // Future task.
      else {
        newStatus = TaskStatus.pending;
      }

      final TaskModel updatedTask = oldTask.copyWith(
        title: title,
        description: description,
        category: _selectedCategory,
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
      category: _selectedCategory,
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
    ).showSnackBar(const SnackBar(content: Text('Task created successfully')));

    Navigator.pop(context);
  }

  // ============================================================
  // CATEGORY COLOR
  // ============================================================

  Color _categoryColor(String category) {
    switch (category) {
      case 'Design':
        return const Color(0xFF2563EB);

      case 'Meeting':
        return const Color(0xFFF97316);

      case 'Development':
        return const Color(0xFF16A34A);

      case 'Work':
        return const Color(0xFF8B5CF6);

      case 'Health':
        return const Color(0xFF14B8A6);

      default:
        return AppColors.needthis;
    }
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<void> _showAddCategoryDialog() async {
    final TaskCategory? result = await showDialog<TaskCategory>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return const _AddCategoryDialog();
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _categories.add(result);
      _selectedCategory = result.name;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.isEditing;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
        ),

        title: Text(
          isEditing ? 'Edit Task' : 'Create Task',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TITLE
              // ==================================================
              _buildLabel('Task Title'),

              const SizedBox(height: 9),

              _buildTextField(
                controller: _titleController,
                hint: 'Enter task title',
              ),

              const SizedBox(height: 21),

              // ==================================================
              // DESCRIPTION
              // ==================================================
              _buildLabel('Description'),

              const SizedBox(height: 9),

              _buildTextField(
                controller: _descriptionController,
                hint: 'Add task description (optional)',
                maxLines: 4,
              ),

              const SizedBox(height: 21),

              // ==================================================
              // CATEGORY
              // ==================================================
              _buildLabel('Category'),

              const SizedBox(height: 11),

              Wrap(
                spacing: 9,
                runSpacing: 9,

                children: [
                  ..._categories.map(
                    (category) => _buildCategoryChip(category),
                  ),

                  _buildAddCategoryChip(),
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // DATE
              // ==================================================
              _buildLabel('Date'),

              const SizedBox(height: 9),

              _buildSelectField(
                icon: Icons.calendar_today_outlined,
                text: _formatDate(),
                selected: _selectedDate != null,
                onTap: _selectDate,
              ),

              const SizedBox(height: 21),

              // ==================================================
              // TIME
              // ==================================================
              _buildLabel('Time'),

              const SizedBox(height: 9),

              _buildSelectField(
                icon: Icons.access_time_outlined,
                text: _formatTime(),
                selected: _selectedTime != null,
                onTap: _selectTime,
              ),

              const SizedBox(height: 34),

              // ==================================================
              // SAVE BUTTON
              // ==================================================
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
                    isEditing ? 'Save Changes' : 'Create Task',

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
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF94A3B8),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.7),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.7),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.needthis, width: 1),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CHIP
  // ============================================================

  Widget _buildCategoryChip(TaskCategory category) {
    final bool selected = _selectedCategory == category.name;

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

  Widget _buildAddCategoryChip() {
    return GestureDetector(
      onTap: _showAddCategoryDialog,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(9),

          border: Border.all(color: const Color(0xFFD6DCE5), width: 0.8),
        ),

        child: const Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.add_rounded, size: 15, color: Color(0xFF64748B)),

            SizedBox(width: 4),

            Text(
              'Add',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
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
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        height: 50,

        padding: const EdgeInsets.symmetric(horizontal: 15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.7),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.needthis : const Color(0xFF94A3B8),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                text,

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,

                  color: selected
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TASK CATEGORY
// ============================================================

class TaskCategory {
  final String name;
  final Color color;

  const TaskCategory({required this.name, required this.color});
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

    final TaskCategory category = TaskCategory(
      name: name,
      color: _selectedColor,
    );

    Navigator.of(context).pop(category);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      title: const Text(
        'Add Category',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Category name',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 9),

          TextField(
            controller: _controller,

            style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),

            decoration: InputDecoration(
              hintText: 'Enter category name',

              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),

              filled: true,
              fillColor: const Color(0xFFF8FAFC),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(color: AppColors.needthis),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Choose color',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
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
                        ? Border.all(color: const Color(0xFF0F172A), width: 2)
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

          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF64748B),
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

          child: const Text(
            'Add',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
