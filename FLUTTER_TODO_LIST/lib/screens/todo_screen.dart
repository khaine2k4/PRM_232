import 'package:flutter/material.dart';
import '../models/todo_task.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoTask> _tasks = [];
  final _formKey = GlobalKey<FormState>();
  final _taskInputController = TextEditingController();
  final _searchController = TextEditingController();

  String _filter = 'All'; // 'All', 'Completed', 'Incomplete'
  bool _sortByNewest = true;
  String _searchQuery = '';

  @override
  void dispose() {
    _taskInputController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Add Task
  void _addTask() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        final newTask = TodoTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _taskInputController.text.trim(),
          createdAt: DateTime.now(),
        );
        _tasks.add(newTask);
        _taskInputController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm công việc mới thành công!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Toggle Completion
  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
  }

  // Delete Task
  void _deleteTask(String id) {
    final deletedTask = _tasks.firstWhere((t) => t.id == id);
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${deletedTask.title}"'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            setState(() {
              _tasks.add(deletedTask);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Edit Task
  void _showEditDialog(TodoTask task) {
    final editFormKey = GlobalKey<FormState>();
    final editController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
          title: const Text(
            'Chỉnh sửa công việc',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: editFormKey,
            child: TextFormField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung công việc...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tên công việc không được để trống!';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (editFormKey.currentState!.validate()) {
                  setState(() {
                    task.title = editController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã cập nhật công việc!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Get filtered and sorted tasks
  List<TodoTask> get _processedTasks {
    List<TodoTask> filtered = List.from(_tasks);

    // Apply Filter
    if (_filter == 'Completed') {
      filtered = filtered.where((t) => t.isCompleted).toList();
    } else if (_filter == 'Incomplete') {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    }

    // Apply Search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply Sort
    filtered.sort((a, b) {
      if (_sortByNewest) {
        return b.createdAt.compareTo(a.createdAt);
      } else {
        return a.createdAt.compareTo(b.createdAt);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = _tasks.length;
    final completedTasks = _tasks.where((t) => t.isCompleted).length;
    final completionPercentage = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Manager',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - Quản lý công việc hàng ngày',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // 1. Sleek Dashboard stats card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiến độ hoàn thành',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        '$completedTasks/$totalTasks',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completionPercentage,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    totalTasks == 0
                        ? 'Chưa có công việc nào. Hãy thêm công việc!'
                        : completionPercentage == 1.0
                            ? '🎉 Tuyệt vời! Bạn đã hoàn thành tất cả công việc!'
                            : 'Đang hoàn thành ${(completionPercentage * 100).toStringAsFixed(0)}% mục tiêu hôm nay.',
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Add New Task Input & Button Form
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _taskInputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Thêm công việc mới...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF334155)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tên công việc!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline, size: 20),
                        SizedBox(width: 6),
                        Text('Thêm', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Search and Sort Filter Header
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
                      filled: true,
                      fillColor: const Color(0xFF1E293B).withValues(alpha: 0.5),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _sortByNewest ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: const Color(0xFF6366F1),
                      size: 20,
                    ),
                    tooltip: _sortByNewest ? 'Mới nhất trước' : 'Cũ nhất trước',
                    onPressed: () {
                      setState(() {
                        _sortByNewest = !_sortByNewest;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 4. Status Filter Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Incomplete', 'Completed'].map((filterType) {
                  final isSelected = _filter == filterType;
                  String vietnameseLabel = '';
                  if (filterType == 'All') vietnameseLabel = 'Tất cả';
                  if (filterType == 'Incomplete') vietnameseLabel = 'Đang làm';
                  if (filterType == 'Completed') vietnameseLabel = 'Hoàn thành';

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(vietnameseLabel),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _filter = filterType;
                          });
                        }
                      },
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : const Color(0xFF334155),
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // 5. Scrollable Task list
            Expanded(
              child: _processedTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isNotEmpty
                                ? Icons.search_off_rounded
                                : Icons.task_alt_rounded,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Không tìm thấy công việc nào phù hợp!'
                                : _filter == 'Completed'
                                    ? 'Chưa có công việc nào hoàn thành.'
                                    : _filter == 'Incomplete'
                                        ? 'Không có công việc nào cần làm!'
                                        : 'Danh sách công việc trống!',
                            style: const TextStyle(color: Colors.grey, fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _processedTasks.length,
                      itemBuilder: (context, index) {
                        final task = _processedTasks[index];
                        final formattedTime =
                            '${task.createdAt.hour.toString().padLeft(2, '0')}:${task.createdAt.minute.toString().padLeft(2, '0')}';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: task.isCompleted
                                  ? const Color(0xFF334155)
                                  : const Color(0xFF6366F1).withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: IconButton(
                              icon: Icon(
                                task.isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_off_rounded,
                                color: task.isCompleted ? const Color(0xFF10B981) : Colors.grey,
                                size: 28,
                              ),
                              onPressed: () => _toggleTask(task.id),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: task.isCompleted ? Colors.grey[500] : Colors.white,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Text(
                              'Tạo lúc $formattedTime',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                                  onPressed: () => _showEditDialog(task),
                                  tooltip: 'Sửa công việc',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                  onPressed: () => _deleteTask(task.id),
                                  tooltip: 'Xóa công việc',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
