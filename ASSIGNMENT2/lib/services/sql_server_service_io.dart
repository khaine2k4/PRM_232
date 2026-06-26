import 'package:mssql_connection/mssql_connection.dart';

import '../config/app_config.dart';

/// Thin wrapper around [MssqlConnection] that connects to the user's SQL Server,
/// bootstraps the `Assignment2Todo` database + tables, and runs raw SQL.
///
/// Every method is best-effort: any failure (server offline, no network,
/// unsupported platform) is swallowed by the caller so the app keeps working
/// against local SQLite.
class SqlServerService {
  SqlServerService._();
  static final SqlServerService instance = SqlServerService._();

  final MssqlConnection _conn = MssqlConnection.getInstance();
  bool _ready = false;

  bool get isReady => _ready;

  /// Connect and make sure the database + schema exist. Returns false on any
  /// problem instead of throwing.
  Future<bool> ensureReady() async {
    if (_ready && _conn.isConnected) return true;
    try {
      // 1) Connect to master to create the database if missing.
      final masterOk = await _conn.connect(
        ip: AppConfig.sqlServerIp,
        port: AppConfig.sqlServerPort,
        databaseName: AppConfig.sqlServerBootstrapDatabase,
        username: AppConfig.sqlServerUser,
        password: AppConfig.sqlServerPassword,
        timeoutInSeconds: AppConfig.sqlServerTimeoutSeconds,
      );
      if (!masterOk) return false;

      await _conn.writeData(
        "IF DB_ID('${AppConfig.sqlServerDatabase}') IS NULL "
        "CREATE DATABASE [${AppConfig.sqlServerDatabase}];",
      );
      await _conn.disconnect();

      // 2) Reconnect directly to the app database and ensure tables exist.
      final dbOk = await _conn.connect(
        ip: AppConfig.sqlServerIp,
        port: AppConfig.sqlServerPort,
        databaseName: AppConfig.sqlServerDatabase,
        username: AppConfig.sqlServerUser,
        password: AppConfig.sqlServerPassword,
        timeoutInSeconds: AppConfig.sqlServerTimeoutSeconds,
      );
      if (!dbOk) return false;

      await _conn.writeData(_schemaSql);
      _ready = true;
      return true;
    } catch (_) {
      _ready = false;
      return false;
    }
  }

  Future<void> writeData(String sql) => _conn.writeData(sql);

  Future<String> getData(String sql) => _conn.getData(sql);

  Future<void> close() async {
    try {
      await _conn.disconnect();
    } catch (_) {}
    _ready = false;
  }

  static const String _schemaSql = '''
IF OBJECT_ID('dbo.Users', 'U') IS NULL
CREATE TABLE dbo.Users (
  id NVARCHAR(64) NOT NULL PRIMARY KEY,
  email NVARCHAR(256) NOT NULL UNIQUE,
  passwordHash NVARCHAR(256) NOT NULL,
  displayName NVARCHAR(256) NULL,
  createdAt DATETIME2 NOT NULL
);
IF OBJECT_ID('dbo.Tasks', 'U') IS NULL
CREATE TABLE dbo.Tasks (
  id NVARCHAR(64) NOT NULL PRIMARY KEY,
  userId NVARCHAR(64) NOT NULL,
  title NVARCHAR(512) NOT NULL,
  description NVARCHAR(MAX) NULL,
  isCompleted BIT NOT NULL DEFAULT 0,
  priority NVARCHAR(16) NOT NULL DEFAULT 'low',
  category NVARCHAR(128) NULL,
  createdAt DATETIME2 NOT NULL,
  dueDate DATETIME2 NULL,
  updatedAt DATETIME2 NOT NULL
);
''';
}
