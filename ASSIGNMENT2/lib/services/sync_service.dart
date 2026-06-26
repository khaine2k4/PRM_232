import '../models/app_user.dart';
import '../models/todo_task.dart';
import 'database_service.dart';
import 'session_service.dart';
import 'sql_server_service.dart';

class SyncResult {
  final bool success;
  final String message;
  final int pushed;
  final int deleted;

  SyncResult(this.success, this.message, {this.pushed = 0, this.deleted = 0});
}

/// Pushes local SQLite changes to the remote SQL Server (one-way, best-effort).
///
/// Local is always the source of truth; the server is a durable mirror so task
/// data survives even if the device/app is gone. Failures never throw to the UI.
class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  final _db = DatabaseService.instance;
  final _server = SqlServerService.instance;
  final _session = SessionService.instance;

  bool _running = false;
  bool get isRunning => _running;

  // ---- SQL literal helpers (mssql_connection sends raw SQL, no params) ----
  String _s(String? v) => v == null ? 'NULL' : "N'${v.replaceAll("'", "''")}'";
  String _dt(DateTime? v) => v == null ? 'NULL' : "'${v.toIso8601String()}'";
  String _b(bool v) => v ? '1' : '0';

  /// Fire-and-forget variant for after-mutation triggers.
  void syncInBackground() {
    syncNow().catchError((_) => SyncResult(false, 'Lỗi đồng bộ'));
  }

  /// Run a full push. Safe to call any time.
  Future<SyncResult> syncNow() async {
    if (_running) return SyncResult(false, 'Đang đồng bộ...');
    _running = true;
    try {
      final ok = await _server.ensureReady();
      if (!ok) {
        return SyncResult(false, 'Không kết nối được SQL Server (offline?)');
      }

      // Mirror accounts first (so tasks reference valid users on the server).
      for (final user in await _db.getAllUsers()) {
        await _server.writeData(_mergeUserSql(user));
      }

      int pushed = 0, deleted = 0;
      for (final task in await _db.getUnsyncedTasks()) {
        if (task.isDeleted) {
          await _server.writeData("DELETE FROM dbo.Tasks WHERE id = ${_s(task.id)};");
          deleted++;
        } else {
          await _server.writeData(_mergeTaskSql(task));
          pushed++;
        }
        await _db.markTaskSynced(task.id);
      }

      await _db.purgeSyncedDeletions();
      await _session.setLastSyncNow();

      return SyncResult(
        true,
        'Đồng bộ thành công',
        pushed: pushed,
        deleted: deleted,
      );
    } catch (e) {
      return SyncResult(false, 'Đồng bộ thất bại: $e');
    } finally {
      _running = false;
    }
  }

  String _mergeUserSql(AppUser u) {
    return '''
MERGE dbo.Users AS T
USING (SELECT ${_s(u.id)} AS id) AS S ON (T.id = S.id)
WHEN MATCHED THEN UPDATE SET
  email = ${_s(u.email)},
  passwordHash = ${_s(u.passwordHash)},
  displayName = ${_s(u.displayName)},
  createdAt = ${_dt(u.createdAt)}
WHEN NOT MATCHED THEN INSERT (id, email, passwordHash, displayName, createdAt)
  VALUES (${_s(u.id)}, ${_s(u.email)}, ${_s(u.passwordHash)}, ${_s(u.displayName)}, ${_dt(u.createdAt)});
''';
  }

  String _mergeTaskSql(TodoTask t) {
    return '''
MERGE dbo.Tasks AS T
USING (SELECT ${_s(t.id)} AS id) AS S ON (T.id = S.id)
WHEN MATCHED THEN UPDATE SET
  userId = ${_s(t.userId)},
  title = ${_s(t.title)},
  description = ${_s(t.description)},
  isCompleted = ${_b(t.isCompleted)},
  priority = ${_s(t.priority.name)},
  category = ${_s(t.category)},
  createdAt = ${_dt(t.createdAt)},
  dueDate = ${_dt(t.dueDate)},
  updatedAt = ${_dt(t.updatedAt)}
WHEN NOT MATCHED THEN INSERT
  (id, userId, title, description, isCompleted, priority, category, createdAt, dueDate, updatedAt)
  VALUES (${_s(t.id)}, ${_s(t.userId)}, ${_s(t.title)}, ${_s(t.description)}, ${_b(t.isCompleted)},
          ${_s(t.priority.name)}, ${_s(t.category)}, ${_dt(t.createdAt)}, ${_dt(t.dueDate)}, ${_dt(t.updatedAt)});
''';
  }
}
