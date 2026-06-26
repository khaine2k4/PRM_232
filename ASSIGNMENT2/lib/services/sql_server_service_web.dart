/// Web stub for [SqlServerService].
///
/// Browsers cannot open a raw TCP/TDS connection to SQL Server, and the
/// `mssql_connection` plugin has no web implementation, so on web we expose the
/// same API but make every call a harmless no-op. The app keeps running fully
/// against local SQLite (WASM); cloud sync is simply disabled.
class SqlServerService {
  SqlServerService._();
  static final SqlServerService instance = SqlServerService._();

  bool get isReady => false;

  /// Always false on web: there is no reachable SQL Server.
  Future<bool> ensureReady() async => false;

  Future<void> writeData(String sql) async {}

  Future<String> getData(String sql) async => '';

  Future<void> close() async {}
}
