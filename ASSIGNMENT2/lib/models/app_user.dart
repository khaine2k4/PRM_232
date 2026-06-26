/// Represents an authenticated account stored locally (SQLite) and mirrored
/// to the remote SQL Server during sync.
class AppUser {
  final String id;
  final String email;
  final String passwordHash;
  final String displayName;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.displayName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      passwordHash: map['passwordHash'] as String,
      displayName: (map['displayName'] as String?) ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
