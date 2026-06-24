import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

/// Service Layer (Lab 8.4): tập trung toàn bộ lệnh gọi mạng.
/// UI chỉ gọi các phương thức ở đây, không gọi http trực tiếp.
/// http.Client được inject qua constructor để dễ test.
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Lab 8.1 + 8.2: GET danh sách bài viết và parse JSON → List<Post>.
  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');

    final response =
        await _client.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('Lỗi máy chủ (mã ${response.statusCode}).');
    }

    // json.decode trả về List<dynamic> vì endpoint trả về một mảng JSON.
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// (Tuỳ chọn) POST: tạo bài viết mới và trả về Post vừa tạo.
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');

    final response = await _client
        .post(
          uri,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'title': title,
            'body': body,
            'userId': userId,
          }),
        )
        .timeout(const Duration(seconds: 12));

    // JSONPlaceholder trả về 201 Created cho POST thành công.
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Tạo bài viết thất bại (mã ${response.statusCode}).');
    }

    return Post.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  void dispose() => _client.close();
}
