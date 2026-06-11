import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_task.dart';

class StorageService {
  static const String _keyTasks = 'todo_tasks';

  // Load tasks from SharedPreferences
  static Future<List<TodoTask>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString(_keyTasks);
      if (tasksJson == null) return [];

      final List<dynamic> decoded = jsonDecode(tasksJson) as List<dynamic>;
      return decoded
          .map((item) => TodoTask.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save tasks to SharedPreferences
  static Future<void> saveTasks(List<TodoTask> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(
        tasks.map((task) => task.toMap()).toList(),
      );
      await prefs.setString(_keyTasks, encoded);
    } catch (e) {
      // Silent error handling
    }
  }
}
