class AppUser {
  final String? id;
  final String fullName;
  final String email;
  final String password; // stored as SHA-256 hash
  final String role; // "admin" or "customer"

  const AppUser({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.role = "customer",
  });

  bool get isAdmin => role == "admin";

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json["id"]?.toString(),
        fullName: (json["fullName"] ?? "") as String,
        email: (json["email"] ?? "") as String,
        password: (json["password"] ?? "") as String,
        role: (json["role"] ?? "customer") as String,
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "password": password,
        "role": role,
      };

  AppUser copyWith(
          {String? id,
          String? fullName,
          String? email,
          String? password,
          String? role}) =>
      AppUser(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
      );
}