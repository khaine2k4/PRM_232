enum TaskPriority { low, medium, high }

class TodoTask {
  final String id;
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;
  TaskPriority priority;
  String category;
  DateTime? dueDate;

  TodoTask({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TaskPriority.low,
    this.category = 'Cá nhân',
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority.name,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory TodoTask.fromMap(Map<String, dynamic> map) {
    return TodoTask(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      isCompleted: (map['isCompleted'] as bool?) ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.low,
      ),
      category: (map['category'] as String?) ?? 'Cá nhân',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
    );
  }
}
