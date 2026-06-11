import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_task.dart';
import '../theme/app_theme.dart';

class HomeTab extends StatefulWidget {
  final List<TodoTask> tasks;
  final bool isLoading;
  final Function(String) onToggle;
  final Function(String) onDelete;
  final Function(TodoTask) onEdit;
  final VoidCallback onAddTask;

  const HomeTab({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onAddTask,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _categoryFilter = 'All';

  final List<String> _categories = [
    '👤 Cá nhân',
    '💼 Công việc',
    '📚 Học tập',
    '❤️ Sức khỏe',
    '🛒 Mua sắm',
    '✨ Khác'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TodoTask> get _filteredTasks {
    List<TodoTask> list = List.from(widget.tasks);

    // Apply Search
    if (_searchQuery.isNotEmpty) {
      list = list.where((t) =>
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply Category Filter
    if (_categoryFilter != 'All') {
      list = list.where((t) => t.category.contains(_categoryFilter.substring(2))).toList();
    }

    // Sort: Incomplete first, then newest
    list.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredTasks;

    final totalTasks = widget.tasks.length;
    final completedTasks = widget.tasks.where((t) => t.isCompleted).length;
    final completionPercentage = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return widget.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              // 1. Search Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.05 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm công việc...',
                    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1D2A3D) : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 2. Category Filter Strip (Horizontal Scroll)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length + 1,
                  itemBuilder: (context, index) {
                    final catName = index == 0 ? 'All' : _categories[index - 1];
                    final isSelected = _categoryFilter == catName;
                    final label = index == 0 ? 'Tất cả' : catName;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _categoryFilter = catName;
                            });
                          }
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: isDark ? const Color(0xFF1D2A3D) : Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected
                              ? (isDark ? const Color(0xFF002D6D) : Colors.white)
                              : (isDark ? const Color(0xFFC2C6D6) : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 3. Header title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Công việc hôm nay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onAddTask,
                    child: Text(
                      'Thêm mới',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Task List Container
              if (filtered.isEmpty)
                _buildEmptyState()
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final task = filtered[index];
                    return _buildTaskCard(task, isDark);
                  },
                ),

              const SizedBox(height: 24),

              // 5. Daily Progress Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF004395) : const Color(0xFFD8E2FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tiến trình hàng ngày',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF001A42),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completionPercentage == 1.0
                          ? 'Tuyệt vời! Hoàn thành!'
                          : 'Sắp hoàn thành mục tiêu!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF001A42),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.1),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: (MediaQuery.of(context).size.width - 72) * completionPercentage,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.completed,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.completed.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đã xong $completedTasks/$totalTasks công việc',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : const Color(0xFF001A42),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            'Hôm nay bạn không có công việc nào!',
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TodoTask task, bool isDark) {
    Color priorityColor;
    String priorityText = '';
    Color badgeBgColor;
    Color badgeTextColor;

    switch (task.priority) {
      case TaskPriority.low:
        priorityColor = AppTheme.priorityLow;
        priorityText = 'Low';
        badgeBgColor = isDark ? const Color(0xFF2C3D52) : Colors.grey[200]!;
        badgeTextColor = isDark ? const Color(0xFFC2C6D6) : Colors.grey[700]!;
        break;
      case TaskPriority.medium:
        priorityColor = AppTheme.priorityMedium;
        priorityText = 'Med';
        badgeBgColor = isDark ? const Color(0xFF004395).withValues(alpha: 0.2) : const Color(0xFFD8E2FF);
        badgeTextColor = isDark ? const Color(0xFFADC6FF) : const Color(0xFF002D6F);
        break;
      case TaskPriority.high:
        priorityColor = AppTheme.priorityHigh;
        priorityText = 'High';
        badgeBgColor = isDark ? const Color(0xFF930013).withValues(alpha: 0.2) : const Color(0xFFFFDAD7);
        badgeTextColor = isDark ? const Color(0xFFFFB3AD) : const Color(0xFF690005);
        break;
    }

    final formattedTime = task.dueDate != null ? DateFormat('hh:mm a').format(task.dueDate!) : 'Hôm nay';

    return Dismissible(/////////////////
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => widget.onDelete(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF182638) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF424754).withValues(alpha: 0.2) : Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Absolute left vertical accent priority bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Custom Checkbox
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: GestureDetector(
                  onTap: () => widget.onToggle(task.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isCompleted ? AppTheme.completed : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted ? AppTheme.completed : (isDark ? const Color(0xFF424754) : Colors.grey[400]!),
                        width: 2,
                      ),
                    ),
                    child: task.isCompleted
                        ? Icon(Icons.check, size: 14, color: isDark ? const Color(0xFF002113) : Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Subtitle Time
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: task.isCompleted
                              ? (isDark ? const Color(0xFF8C919E) : Colors.grey[400])
                              : (isDark ? const Color(0xFFEAF1FF) : const Color(0xFF0F1E31)),
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: isDark ? const Color(0xFF8C919E) : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF8C919E) : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Priority Tag Badge
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: Center(
                  child: InkWell(
                    onTap: () => widget.onEdit(task),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        priorityText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
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
}
