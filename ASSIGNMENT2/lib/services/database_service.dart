import 'package:sqflite/sqflite.dart';

import '../models/app_user.dart';
import '../models/todo_task.dart';
// Selects the right sqflite databaseFactory per platform at compile time:
// native (mobile/desktop) vs. web (WASM). Keeps this file platform-agnostic.
import 'db_factory_io.dart' if (dart.library.html) 'db_factory_web.dart';

/// Local persistence (Assignment requirement: Option A – SQLite).
///
/// Holds two tables, `users` and `tasks`, and exposes full CRUD. Tasks carry
/// `synced` / `isDeleted` flags that the [SyncService] uses to reconcile with
/// the remote SQL Server. SQLite is always the source of truth.
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const String _dbName = 'assignment2_todo.db';
  static const int _dbVersion = 1;

  Database? _db;

  Future<Database> get db async => _db ??= await _open();

  Future<void> init() async {
    // Wire up the correct sqflite backend for the current platform
    // (desktop FFI, web WASM, or the default mobile plugin factory).
    configureDatabaseFactory();
    await db; // open eagerly so first screen is instant
  }

  Future<Database> _open() async {
    final path = await resolveDatabasePath(_dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (d) async => d.execute('PRAGMA foreign_keys = ON'),
      onCreate: (d, _) async {
        await d.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL UNIQUE,
            passwordHash TEXT NOT NULL,
            displayName TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
        await d.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            priority TEXT NOT NULL DEFAULT 'low',
            category TEXT,
            createdAt TEXT NOT NULL,
            dueDate TEXT,
            updatedAt TEXT NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0,
            isDeleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await d.execute('CREATE INDEX idx_tasks_user ON tasks(userId)');
      },
    );
  }

  // ===================== USERS =====================

  Future<void> insertUser(AppUser user) async {
    final d = await db;
    await d.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<AppUser?> getUserByEmail(String email) async {
    final d = await db;
    final rows = await d.query('users',
        where: 'email = ?', whereArgs: [email.toLowerCase().trim()], limit: 1);
    if (rows.isEmpty) return null;
    return AppUser.fromMap(rows.first);
  }

  Future<AppUser?> getUserById(String id) async {
    final d = await db;
    final rows = await d.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return AppUser.fromMap(rows.first);
  }

  Future<List<AppUser>> getAllUsers() async {
    final d = await db;
    final rows = await d.query('users');
    return rows.map(AppUser.fromMap).toList();
  }

  // ===================== TASKS =====================

  /// Insert (Create).
  Future<void> insertTask(TodoTask task) async {
    final d = await db;
    await d.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Read all visible (not soft-deleted) tasks for a user.
  Future<List<TodoTask>> getTasks(String userId) async {
    final d = await db;
    final rows = await d.query(
      'tasks',
      where: 'userId = ? AND isDeleted = 0',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return rows.map(TodoTask.fromMap).toList();
  }

  /// Update an existing task; marks it dirty for the next sync.
  Future<void> updateTask(TodoTask task) async {
    final d = await db;
    task.updatedAt = DateTime.now();
    task.synced = false;
    await d.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  /// Soft-delete: hide locally and queue a server delete on next sync.
  Future<void> softDeleteTask(String id) async {
    final d = await db;
    await d.update(
      'tasks',
      {
        'isDeleted': 1,
        'synced': 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Restore a soft-deleted task (used by the Undo action).
  Future<void> restoreTask(String id) async {
    final d = await db;
    await d.update(
      'tasks',
      {
        'isDeleted': 0,
        'synced': 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Permanently remove every (visible) task for a user. Soft-deletes them so
  /// the removal also propagates to the server on next sync.
  Future<void> clearTasks(String userId) async {
    final d = await db;
    await d.update(
      'tasks',
      {
        'isDeleted': 1,
        'synced': 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'userId = ? AND isDeleted = 0',
      whereArgs: [userId],
    );
  }

  // ---- Sync helpers ----

  /// Tasks that still need to be pushed to the server.
  Future<List<TodoTask>> getUnsyncedTasks() async {
    final d = await db;
    final rows = await d.query('tasks', where: 'synced = 0');
    return rows.map(TodoTask.fromMap).toList();
  }

  Future<void> markTaskSynced(String id) async {
    final d = await db;
    await d.update('tasks', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  /// Hard-delete tombstones that have been confirmed removed on the server.
  Future<void> purgeSyncedDeletions() async {
    final d = await db;
    await d.delete('tasks', where: 'isDeleted = 1 AND synced = 1');
  }
}
