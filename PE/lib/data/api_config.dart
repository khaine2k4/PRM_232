import "dart:io" show Platform;
import "package:flutter/foundation.dart" show kIsWeb;

/// Central place for the mock REST API (JSON Server) base URL.
///
/// JSON Server runs on the host machine at port 3000. The reachable host
/// differs per platform:
/// - Android emulator cannot see "localhost"; it must use 10.0.2.2.
/// - iOS simulator, Windows desktop and web can use localhost directly.
class ApiConfig {
  static const int port = 3001;

  static String get baseUrl {
    if (kIsWeb) return "http://localhost:$port";
    if (Platform.isAndroid) return "http://10.0.2.2:$port";
    return "http://localhost:$port";
  }

  static Uri users([String path = ""]) => Uri.parse("$baseUrl/users$path");
  static Uri products([String path = ""]) => Uri.parse("$baseUrl/products$path");
  static Uri orders([String path = ""]) => Uri.parse("$baseUrl/orders$path");
}

