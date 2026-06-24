/// Model cho một bài viết từ API JSONPlaceholder (/posts).
/// JSON mẫu: { "userId": 1, "id": 1, "title": "...", "body": "..." }
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// Chuyển một Map JSON → đối tượng Post (Lab 8.2).
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }

  /// Chuyển ngược Post → Map để gửi đi (dùng cho POST request).
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}
