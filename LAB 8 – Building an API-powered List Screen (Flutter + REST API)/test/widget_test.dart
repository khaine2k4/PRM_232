import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:lab8_networking/main.dart';
import 'package:lab8_networking/services/api_service.dart';

void main() {
  testWidgets('App khởi động và hiển thị màn hình danh sách', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(); // 1 frame để FutureBuilder dựng UI

    // Tiêu đề màn hình và nút tạo mới xuất hiện.
    expect(find.text('Posts (REST API)'), findsOneWidget);
    expect(find.text('Tạo mới'), findsOneWidget);
  });

  test('ApiService.fetchPosts parse JSON → List<Post>', () async {
    // MockClient trả về JSON giả → không cần mạng thật.
    final mock = MockClient((request) async {
      return http.Response(
        '[{"userId":1,"id":1,"title":"Hello","body":"World"}]',
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = ApiService(client: mock);
    final posts = await service.fetchPosts();

    expect(posts.length, 1);
    expect(posts.first.id, 1);
    expect(posts.first.title, 'Hello');
  });
}
