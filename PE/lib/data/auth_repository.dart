import "dart:convert";
import "package:http/http.dart" as http;

import "../models/user.dart";
import "../utils/crypto_utils.dart";
import "api_config.dart";

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

/// Talks to the /users collection of the mock REST API.
class AuthRepository {
  final http.Client _client;
  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Returns the user matching [email] or null if none exists.
  Future<AppUser?> _findByEmail(String email) async {
    final uri = ApiConfig.users("?email=${Uri.encodeQueryComponent(email)}");
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw AuthException("Server error (${res.statusCode}).");
    }
    final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) return null;
    return AppUser.fromJson(list.first);
  }

  /// Registers a new account. Throws [AuthException] if the email is taken.
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final existing = await _findByEmail(normalized);
    if (existing != null) {
      throw AuthException("This email is already registered.");
    }
    final user = AppUser(
      fullName: fullName.trim(),
      email: normalized,
      password: hashPassword(password),
    );
    final res = await _client.post(
      ApiConfig.users(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw AuthException("Could not create account (${res.statusCode}).");
    }
    return AppUser.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Validates credentials against stored data.
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final user = await _findByEmail(normalized);
    if (user == null) {
      throw AuthException("No account found for this email.");
    }
    if (user.password != hashPassword(password)) {
      throw AuthException("Incorrect password.");
    }
    return user;
  }
}
