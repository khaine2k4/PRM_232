import 'package:flutter/material.dart';

import '../models/todo_task.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';
import 'home_tab.dart';
import 'login_screen.dart';
import 'schedule_tab.dart';
import 'settings_tab.dart';
import 'stats_tab.dart';
import 'task_detail_sheet.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _db = DatabaseService.instance;

  final List<TodoTask> _tasks = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  String _userId = '';
  String _userName = 'Bạn';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final session = SessionService.instance;
    _userId = await session.userId() ?? '';
    _userName = await session.userName() ?? 'Bạn';
    _userEmail = await session.userEmail() ?? '';
    final tasks = await _db.getTasks(_userId);
    if (!mounted) return;
    setState(() {
      _tasks
        ..clear()
        ..addAll(tasks);
      _isLoading = false;
    });
  }

  // ---------------- CRUD (SQLite source of truth) ----------------

  Future<void> _showAddTaskSheet() async {
    final result = await showModalBottomSheet<TodoTask>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskDetailSheet(),
    );
    if (result == null) return;

    result.userId = _userId;
    await _db.insertTask(result);
    setState(() => _tasks.add(result));
    SyncService.instance.syncInBackground();
    _showSnackBar('Đã thêm công việc "${result.title}"!');
  }

  Future<void> _showEditTaskSheet(TodoTask task) async {
    final result = await showModalBottomSheet<TodoTask>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(task: task),
    );
    if (result == null) return;

    result.userId = _userId;
    await _db.updateTask(result);
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _tasks[index] = result;
    });
    SyncService.instance.syncInBackground();
    _showSnackBar('Đã cập nhật công việc!');
  }

  Future<void> _toggleTask(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    setState(() => task.isCompleted = !task.isCompleted);
    await _db.updateTask(task);
    SyncService.instance.syncInBackground();
  }

  Future<void> _deleteTask(String id) async {
    final deletedTask = _tasks.firstWhere((t) => t.id == id);
    final index = _tasks.indexOf(deletedTask);
    setState(() => _tasks.removeAt(index));
    await _db.softDeleteTask(id);
    SyncService.instance.syncInBackground();

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${deletedTask.title}"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () async {
            await _db.restoreTask(id);
            setState(() => _tasks.insert(index, deletedTask));
            SyncService.instance.syncInBackground();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _clearAllTasks() async {
    await _db.clearTasks(_userId);
    setState(() => _tasks.clear());
    SyncService.instance.syncInBackground();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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

  // ---------------- Bottom navigation ----------------

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
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
      decoration: AppTheme.backgroundDecoration(isDark),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
                        : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.checklist_rounded, size: 22, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'TaskFlow Pro',
                style: TextStyle(
                  fontSize: 20,
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
                      userName: _userName,
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
                    SettingsTab(
                      userName: _userName,
                      userEmail: _userEmail,
                      onClearAll: _clearAllTasks,
                      onLogout: _logout,
                    ),
                  ],
                ),
              ),
        floatingActionButton: (_selectedTabIndex == 0 || _selectedTabIndex == 1)
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
