class TodoTask {
  final String id;
  String title;
  bool isCompleted;
  final DateTime createdAt;

  TodoTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });
}
