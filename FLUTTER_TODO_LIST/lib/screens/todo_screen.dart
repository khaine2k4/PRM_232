import 'package:flutter/material.dart';
import '../main.dart';
import '../models/todo_task.dart';
import '../services/storage_service.dart';
import 'home_tab.dart';
import 'schedule_tab.dart';
import 'stats_tab.dart';
import 'settings_tab.dart';
import 'task_detail_sheet.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoTask> _tasks = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await StorageService.loadTasks();
    setState(() {
      _tasks.addAll(tasks);
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  void _showAddTaskSheet() async {
    final result = await showModalBottomSheet<TodoTask>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskDetailSheet(),
    );

    if (result != null) {
      setState(() {
        _tasks.add(result);
      });
      _saveTasks();
      _showSnackBar('Đã thêm công việc "${result.title}"!');
    }
  }

  void _showEditTaskSheet(TodoTask task) async {
    final result = await showModalBottomSheet<TodoTask>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(task: task),
    );

    if (result != null) {
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = result;
        }
      });
      _saveTasks();
      _showSnackBar('Đã cập nhật công việc!');
    }
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  void _deleteTask(String id) {
    final deletedTask = _tasks.firstWhere((t) => t.id == id);
    final index = _tasks.indexOf(deletedTask);
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${deletedTask.title}"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            setState(() {
              _tasks.insert(index, deletedTask);
            });
            _saveTasks();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearAllTasks() {
    setState(() {
      _tasks.clear();
    });
    _saveTasks();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF005236) : const Color(0xFFE2F3EC))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isDark ? const Color(0xFF6CF8BB) : const Color(0xFF003824))
                  : (isDark ? const Color(0xFFC2C6D6) : Colors.black54),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF6CF8BB) : const Color(0xFF003824),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // Dynamic Rich Gradient Background matching TaskFlow Navy theme
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0B1C30), const Color(0xFF050E1A), const Color(0xFF102035)]
              : [const Color(0xFFF3F7FC), const Color(0xFFE6EEF8), const Color(0xFFEDF2F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF424754) : Colors.grey[300]!,
                    width: 1.5,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBUDqsctwB1zox_3lRhFnlVtlA78eYv8uG0apw14l0Liba8h3rN9Q3mH4yCkpqXasqbRUhYN-mx_BKGBvx6lkfh3Uz40Rdss3sYr6RNrAOaMeGg4Les_PPb5P7Hi0rceX3Em28LU_chWJ_oZk5kYFtj3XI7yJDewE6PKq2fBf2G5W_SF-oYKJWRcOv3UoAuW5pJf4N8zkAj9TTFb6Vfn-BHOVQF_zaoJ596OaG9dcSxwd5Q96ntytRx8dHmEzVdrcoUTqcvvTUxics',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'TaskFlow',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _showSnackBar('Không có thông báo mới!'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: [
                    HomeTab(
                      tasks: _tasks,
                      isLoading: _isLoading,
                      onToggle: _toggleTask,
                      onDelete: _deleteTask,
                      onEdit: _showEditTaskSheet,
                      onAddTask: _showAddTaskSheet,
                    ),
                    ScheduleTab(
                      tasks: _tasks,
                      onEdit: _showEditTaskSheet,
                      onToggle: _toggleTask,
                    ),
                    StatsTab(tasks: _tasks),
                    SettingsTab(onClearAll: _clearAllTasks),
                  ],
                ),
              ),
        // Floating Action Button - only visible on Home and Schedule tabs
        floatingActionButton: (_selectedTabIndex == 0 || _selectedTabIndex == 1)//////////
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
                        : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE))
                          .withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: _showAddTaskSheet,
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                ),
              )
            : null,
        bottomNavigationBar: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1C30) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF424754).withValues(alpha: 0.15) : Colors.grey[200]!,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.calendar_month_rounded, 'Schedule'),
              _buildNavItem(2, Icons.analytics_rounded, 'Stats'),
              _buildNavItem(3, Icons.settings_rounded, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
