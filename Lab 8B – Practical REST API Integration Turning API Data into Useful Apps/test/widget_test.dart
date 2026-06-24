// Smoke test cơ bản cho Weather Companion.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_companion/main.dart';

void main() {
  testWidgets('App khởi động và hiển thị màn hình chính', (tester) async {
    await tester.pumpWidget(const WeatherCompanionApp());

    // Tiêu đề màn hình chính xuất hiện.
    expect(find.text('Weather Companion'), findsOneWidget);
    // Có ô tìm kiếm thành phố.
    expect(find.byType(TextField), findsOneWidget);
  });
}
