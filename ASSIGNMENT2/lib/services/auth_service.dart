import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/app_user.dart';
import 'database_service.dart';
import 'session_service.dart';

/// Thrown for any auth failure with a user-facing Vietnamese message.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

/// Handles registration, login and the persisted session. Credentials are
/// stored locally in SQLite with SHA-256 hashed passwords.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _db = DatabaseService.instance;
  final _session = SessionService.instance;

  static const String _salt = 'assignment2_todo::v1';

  String _hash(String password) {
    return sha256.convert(utf8.encode('$_salt$password')).toString();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$').hasMatch(email);
  }

  /// Create a new account, then sign in. Returns the created user.
  Future<AppUser> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cleanEmail = email.toLowerCase().trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      throw AuthException('Vui lòng nhập đầy đủ thông tin!');
    }
    if (!_isValidEmail(cleanEmail)) {
      throw AuthException('Email không hợp lệ!');
    }
    if (password.length < 4) {
      throw AuthException('Mật khẩu phải có ít nhất 4 ký tự!');
    }
    if (await _db.getUserByEmail(cleanEmail) != null) {
      throw AuthException('Email này đã được đăng ký!');
    }

    final name = (displayName == null || displayName.trim().isEmpty)
        ? cleanEmail.split('@').first
        : displayName.trim();

    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: cleanEmail,
      passwordHash: _hash(password),
      displayName: name,
      createdAt: DateTime.now(),
    );

    await _db.insertUser(user);
    await _persistSession(user);
    return user;
  }

  /// Verify credentials against the local store and start a session.
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.toLowerCase().trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      throw AuthException('Vui lòng nhập đầy đủ thông tin!');
    }

    final user = await _db.getUserByEmail(cleanEmail);
    if (user == null) {
      throw AuthException('Tài khoản không tồn tại. Hãy đăng ký trước!');
    }
    if (user.passwordHash != _hash(password)) {
      throw AuthException('Mật khẩu không đúng!');
    }

    await _persistSession(user);
    return user;
  }

  Future<void> _persistSession(AppUser user) async {
    await _session.saveSession(
      userId: user.id,
      email: user.email,
      name: user.displayName,
    );
  }

  /// Clear the login session (logout). Tasks remain stored locally.
  Future<void> logout() async {
    await _session.clearSession();
  }

  /// The currently signed-in user, or null.
  Future<AppUser?> currentUser() async {
    final id = await _session.userId();
    if (id == null) return null;
    return _db.getUserById(id);
  }
}
