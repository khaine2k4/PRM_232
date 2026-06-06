import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/main.dart';

void main() {
  testWidgets('Movie App smoke test', (WidgetTester tester) async {
    // Khởi chạy ứng dụng MovieApp và render frame đầu tiên.
    await tester.pumpWidget(const MovieApp());

    // Xác minh ứng dụng hiển thị tiêu đề "Movies" trên màn hình HomeScreen.
    expect(find.text('Movies'), findsOneWidget);
  });
}
