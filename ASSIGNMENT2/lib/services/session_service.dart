import 'package:shared_preferences/shared_preferences.dart';

/// Persists the login session and lightweight preferences using
/// SharedPreferences, so the user stays logged in across app launches.
class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  static const String _kIsLoggedIn = 'is_logged_in';
  static const String _kUserId = 'session_user_id';
  static const String _kUserEmail = 'session_user_email';
  static const String _kUserName = 'session_user_name';
  static const String _kThemeMode = 'theme_mode'; // 'dark' | 'light'
  static const String _kLastSync = 'last_sync_at';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _p async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---- Login session ----
  Future<bool> isLoggedIn() async => (await _p).getBool(_kIsLoggedIn) ?? false;

  Future<String?> userId() async => (await _p).getString(_kUserId);
  Future<String?> userEmail() async => (await _p).getString(_kUserEmail);
  Future<String?> userName() async => (await _p).getString(_kUserName);

  Future<void> saveSession({
    required String userId,
    required String email,
    required String name,
  }) async {
    final p = await _p;
    await p.setBool(_kIsLoggedIn, true);
    await p.setString(_kUserId, userId);
    await p.setString(_kUserEmail, email);
    await p.setString(_kUserName, name);
  }

  Future<void> clearSession() async {
    final p = await _p;
    await p.remove(_kIsLoggedIn);
    await p.remove(_kUserId);
    await p.remove(_kUserEmail);
    await p.remove(_kUserName);
  }

  // ---- Theme (fixes Assignment 1: choice is now remembered) ----
  Future<bool> isDarkMode() async {
    final mode = (await _p).getString(_kThemeMode);
    return mode == null ? true : mode == 'dark'; // default: dark
  }

  Future<void> setDarkMode(bool dark) async {
    await (await _p).setString(_kThemeMode, dark ? 'dark' : 'light');
  }

  // ---- Sync bookkeeping ----
  Future<DateTime?> lastSyncAt() async {
    final iso = (await _p).getString(_kLastSync);
    return iso == null ? null : DateTime.tryParse(iso);
  }

  Future<void> setLastSyncNow() async {
    await (await _p).setString(_kLastSync, DateTime.now().toIso8601String());
  }
}
