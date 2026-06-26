// Browser-only test: verifies the web SQLite (WASM) backend actually opens and
// performs full CRUD. Run with:  flutter test --platform chrome test/web_db_test.dart
//
// This directly exercises DatabaseService, which is the layer that previously
// failed on web ("getDatabasesPath is null", "unsupported result null",
// "WebAssembly Import env") before the sqflite web factory + matching wasm fix.
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:assignment2_todo/models/app_user.dart';
import 'package:assignment2_todo/models/todo_task.dart';
import 'package:assignment2_todo/services/database_service.dart';

void main() {
  final db = DatabaseService.instance;

  test('web SQLite opens and performs user + task CRUD', () async {
    // Open the database (this is what threw the earlier web errors).
    await db.init();

    final userId = 'u_${DateTime.now().microsecondsSinceEpoch}';
    final email = 'auto_$userId@test.com';

    // CREATE + READ user.
    await db.insertUser(AppUser(
      id: userId,
      email: email,
      passwordHash: 'hash',
      displayName: 'Auto Test',
      createdAt: DateTime.now(),
    ));
    final fetchedUser = await db.getUserByEmail(email);
    expect(fetchedUser, isNotNull);
    expect(fetchedUser!.id, userId);

    // CREATE task.
    final taskId = 't_${DateTime.now().microsecondsSinceEpoch}';
    await db.insertTask(TodoTask(
      id: taskId,
      title: 'Task gốc',
      userId: userId,
      createdAt: DateTime.now(),
      priority: TaskPriority.high,
    ));

    // READ tasks.
    var tasks = await db.getTasks(userId);
    expect(tasks.length, 1);
    expect(tasks.first.title, 'Task gốc');
    expect(tasks.first.priority, TaskPriority.high);

    // UPDATE task.
    final t = tasks.first;
    t.title = 'Task đã sửa';
    t.isCompleted = true;
    await db.updateTask(t);
    tasks = await db.getTasks(userId);
    expect(tasks.first.title, 'Task đã sửa');
    expect(tasks.first.isCompleted, isTrue);

    // SOFT-DELETE then restore.
    await db.softDeleteTask(taskId);
    expect((await db.getTasks(userId)), isEmpty);
    await db.restoreTask(taskId);
    expect((await db.getTasks(userId)).length, 1);
  });
}
