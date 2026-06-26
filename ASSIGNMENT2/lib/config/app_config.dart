/// Central configuration for the app.
///
/// NOTE: Embedding raw database credentials in a client app is insecure and is
/// done here only because this is a course assignment. In production these
/// would live behind a backend API. SQLite remains the source of truth so the
/// app works fully even when the SQL Server is unreachable.
class AppConfig {
  AppConfig._();

  // ---- Remote SQL Server (best-effort sync target) ----
  static const String sqlServerIp = '100.123.181.94';
  static const String sqlServerPort = '1433';
  static const String sqlServerDatabase = 'Assignment2Todo';
  static const String sqlServerUser = 'sa';
  static const String sqlServerPassword = 'Khaidz12345';
  static const int sqlServerTimeoutSeconds = 12;

  /// Master DB used once to create [sqlServerDatabase] if it does not exist.
  static const String sqlServerBootstrapDatabase = 'master';
}
