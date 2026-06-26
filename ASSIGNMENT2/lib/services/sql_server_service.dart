// Platform switch for SqlServerService.
//
// Native builds (mobile/desktop) get the real `mssql_connection`-backed
// implementation; web builds get a no-op stub, because the plugin and raw
// TCP connections are unavailable in the browser. Callers import this file and
// use `SqlServerService.instance` exactly the same way on every platform.
export 'sql_server_service_io.dart'
    if (dart.library.html) 'sql_server_service_web.dart';
