enum TaskPriority { low, medium, high }

/// A single todo item. Belongs to a user ([userId]) and carries sync metadata
/// ([synced], [isDeleted]) so the local SQLite store can be reconciled with the
/// remote SQL Server in a best-effort, offline-friendly way.
class TodoTask {
  final String id;
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;
  TaskPriority priority;
  String category;
  DateTime? dueDate;

  // Ownership + sync bookkeeping
  String userId;
  DateTime updatedAt;
  bool synced; // true once pushed to the SQL Server
  bool isDeleted; // soft-delete tombstone awaiting server removal

  TodoTask({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TaskPriority.low,
    this.category = 'Cá nhân',
    this.dueDate,
    this.userId = '',
    DateTime? updatedAt,
    this.synced = false,
    this.isDeleted = false,
  }) : updatedAt = updatedAt ?? createdAt;

  /// Map for SQLite storage (booleans become 0/1, dates become ISO strings).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority.name,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  factory TodoTask.fromMap(Map<String, dynamic> map) {
    return TodoTask(
      id: map['id'] as String,
      userId: (map['userId'] as String?) ?? '',
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      isCompleted: ((map['isCompleted'] as int?) ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.low,
      ),
      category: (map['category'] as String?) ?? 'Cá nhân',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : DateTime.parse(map['createdAt'] as String),
      synced: ((map['synced'] as int?) ?? 0) == 1,
      isDeleted: ((map['isDeleted'] as int?) ?? 0) == 1,
    );
  }
}
