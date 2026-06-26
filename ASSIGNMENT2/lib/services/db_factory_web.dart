import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Configures the sqflite [databaseFactory] to use the WebAssembly SQLite
/// build when the app runs in a browser. Data is persisted in IndexedDB.
///
/// Uses the no-web-worker factory: SQLite runs directly on the main isolate
/// instead of a shared worker. It only needs `sqlite3.wasm` (no `sqflite_sw.js`
/// handshake), which is far more reliable across browsers — the shared-worker
/// factory can fail to return an open handle and throw "unsupported result
/// null" on openDatabase.
void configureDatabaseFactory() {
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
}

/// On web there is no filesystem path: the database is keyed by name in
/// IndexedDB, so [getDatabasesPath] is unavailable. Just use the bare name.
Future<String> resolveDatabasePath(String name) async => name;
