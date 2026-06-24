import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_task.dart';
import '../theme/app_theme.dart';

class TaskDetailSheet extends StatefulWidget {
  final TodoTask? task;

  const TaskDetailSheet({super.key, this.task});

  @override
  State<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late TaskPriority _priority;
  late String _category;
  DateTime? _dueDate;

  final List<String> _categories = [
    '👤 Cá nhân',
    '💼 Công việc',
    '📚 Học tập',
    '❤️ Sức khỏe',
    '🛒 Mua sắm',
    '✨ Khác'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.low;
    _category = widget.task?.category ?? '👤 Cá nhân';
    
    if (!_categories.contains(_category)) {
      final matched = _categories.firstWhere(
        (c) => c.contains(_category) || _category.contains(c.substring(2)),
        orElse: () => _category,
      );
      _category = matched;
    }
    
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(////////
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: const Color(0xFF002D6D),
              surface: const Color(0xFF1D2A3D),
              onSurface: const Color(0xFFEAF1FF),
            ),
            dialogBackgroundColor: const Color(0xFF0B1C30),
          ) : Theme.of(context),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
      );

      setState(() {
        if (pickedTime != null) {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        } else {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final task = TodoTask(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        priority: _priority,
        category: _category,
        dueDate: _dueDate,
      );
      Navigator.pop(context, task);
    }
  }

  Widget _buildPriorityButton(TaskPriority p, String label, Color dotColor, Color activeColor, Color activeBgColor) {
    final isSelected = _priority == p;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = p;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : (isDark ? const Color(0xFF424754) : Colors.grey[300]!),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? activeColor
                    : (isDark ? const Color(0xFFEAF1FF) : const Color(0xFF0F1E31)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.task != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1C30) : const Color(0xFFF3F7FC),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: Border.all(
            color: isDark ? const Color(0xFF424754).withValues(alpha: 0.15) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isEditing ? 'Chỉnh sửa công việc' : 'Thêm công việc mới',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFEAF1FF) : const Color(0xFF0F1E31),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),

                // Title Input
                TextFormField(
                  controller: _titleController,
                  autofocus: false,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Tên công việc...',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên công việc!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Input
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Mô tả thêm (Không bắt buộc)...',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 20),

                // Priority Selector (Bento Box style matching TaskFlow)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF182638) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF424754).withValues(alpha: 0.15) : Colors.grey[200]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Độ ưu tiên (Priority)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFC2C6D6) : Colors.grey[700]!,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPriorityButton(
                        TaskPriority.high,
                        'Cao (High)',
                        AppTheme.priorityHigh,
                        isDark ? const Color(0xFFFFB3AD) : const Color(0xFFB91C1C),
                        isDark ? const Color(0xFF930013).withValues(alpha: 0.2) : const Color(0xFFFFDAD7),
                      ),
                      _buildPriorityButton(
                        TaskPriority.medium,
                        'Trung bình (Medium)',
                        AppTheme.priorityMedium,
                        isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE),
                        isDark ? const Color(0xFF004395).withValues(alpha: 0.2) : const Color(0xFFD8E2FF),
                      ),
                      _buildPriorityButton(
                        TaskPriority.low,
                        'Thấp (Low)',
                        AppTheme.priorityLow,
                        isDark ? const Color(0xFFC2C6D6) : Colors.grey[700]!,
                        isDark ? const Color(0xFF2C3D52).withValues(alpha: 0.2) : Colors.grey[100]!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Category Selector
                Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((c) {
                      final isSelected = _category == c;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _category = c);
                            }
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.transparent,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? (isDark ? const Color(0xFF002D6D) : Colors.white)
                                : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : (isDark ? const Color(0xFF424754) : Colors.grey[300]!),
                            width: isSelected ? 1.8 : 1,
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 22),

                // Due Date Box
                InkWell(
                  onTap: _pickDueDate,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF182638) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF424754).withValues(alpha: 0.15) : Colors.grey[200]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _dueDate != null
                                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: _dueDate != null
                                    ? Theme.of(context).colorScheme.primary
                                    : (isDark ? Colors.white54 : Colors.black54),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày & Giờ hết hạn',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white54 : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _dueDate != null
                                      ? DateFormat('dd/MM/yyyy HH:mm').format(_dueDate!)
                                      : 'Chưa đặt hạn chót',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _dueDate != null ? FontWeight.bold : FontWeight.w500,
                                    color: _dueDate != null
                                        ? (isDark ? Colors.white : const Color(0xFF0F1E31))
                                        : (isDark ? Colors.white24 : Colors.black38),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              setState(() => _dueDate = null);
                            },
                          )
                        else
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Cancel and Submit buttons (Gradient on Submit)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
                                : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: (isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE))
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            isEditing ? 'Cập nhật' : 'Tạo mới',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
