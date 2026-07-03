import "dart:convert";
import "package:crypto/crypto.dart";

/// Hash a plaintext password with SHA-256 before it is stored / compared.
String hashPassword(String plain) {
  final bytes = utf8.encode(plain);
  return sha256.convert(bytes).toString();
}
