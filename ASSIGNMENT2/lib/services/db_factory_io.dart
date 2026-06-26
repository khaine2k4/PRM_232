import 'dart:io' show Platform;

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Configures the sqflite [databaseFactory] for native platforms.
///
/// * Android / iOS use the default plugin factory (registered automatically by
///   importing `package:sqflite/sqflite.dart`), so nothing to do.
/// * Desktop (Windows / macOS / Linux) needs the FFI implementation.
void configureDatabaseFactory() {
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

/// Resolves the on-disk path for the database file on native platforms.
Future<String> resolveDatabasePath(String name) async {
  final dir = await getDatabasesPath();
  return p.join(dir, name);
}
