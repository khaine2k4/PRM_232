import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../data/auth_repository.dart";
import "../models/user.dart";

class AuthProvider extends ChangeNotifier {
  static const _kRemember = "remember_me";
  static const _kEmail = "saved_email";
  static const _kLoggedInEmail = "logged_in_email";
  static const _kLoggedInName = "logged_in_name";
  static const _kLoggedInRole = "logged_in_role";

  final AuthRepository _repo;
  AuthProvider({AuthRepository? repo}) : _repo = repo ?? AuthRepository();

  AppUser? _current;
  bool _loading = false;
  bool _rememberMe = false;
  String _savedEmail = "";

  AppUser? get currentUser => _current;
  bool get isLoggedIn => _current != null;
  bool get isAdmin => _current?.isAdmin ?? false;
  bool get loading => _loading;
  bool get rememberMe => _rememberMe;
  String get savedEmail => _savedEmail;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  /// Restore a previous session on app start (Remember Me).
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool(_kRemember) ?? false;
    _savedEmail = prefs.getString(_kEmail) ?? "";
    final email = prefs.getString(_kLoggedInEmail);
    final name = prefs.getString(_kLoggedInName);
    final role = prefs.getString(_kLoggedInRole) ?? "customer";
    if (_rememberMe && email != null && name != null) {
      _current = AppUser(fullName: name, email: email, password: "", role: role);
    }
    notifyListeners();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _repo.register(
        fullName: fullName,
        email: email,
        password: password,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    _setLoading(true);
    try {
      final user = await _repo.login(email: email, password: password);
      _current = user;
      _rememberMe = remember;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kRemember, remember);
      if (remember) {
        await prefs.setString(_kEmail, user.email);
        await prefs.setString(_kLoggedInEmail, user.email);
        await prefs.setString(_kLoggedInName, user.fullName);
        await prefs.setString(_kLoggedInRole, user.role);
      } else {
        await prefs.remove(_kEmail);
        await prefs.remove(_kLoggedInEmail);
        await prefs.remove(_kLoggedInName);
        await prefs.remove(_kLoggedInRole);
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _current = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedInEmail);
    await prefs.remove(_kLoggedInName);
    await prefs.remove(_kLoggedInRole);
    // Keep saved email for convenience only if Remember Me stays on.
    if (!_rememberMe) {
      await prefs.remove(_kEmail);
    }
    notifyListeners();
  }
}
