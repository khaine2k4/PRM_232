import 'dart:io';
import '../utils/ansi_helper.dart';

/// Hàm bất đồng bộ giả lập việc tải dữ liệu từ server/database
/// Trì hoãn 2 giây sau đó trả về danh sách 5 số nguyên
Future<List<int>> loadData() async {
  // Trì hoãn 2 giây bất đồng bộ
  await Future.delayed(Duration(seconds: 2));
  return [10, 20, 30, 40, 50];
}

/// Hàm run() chính phải dùng từ khóa 'async' để có thể gọi 'await' bên trong
Future<void> run() async {
  AnsiHelper.printHeader('Bài tập 14: Future Data Loading');
  AnsiHelper.printDesc('Lập trình bất đồng bộ: Sử dụng Future.delayed và await để giả lập tải dữ liệu từ máy chủ.');

  AnsiHelper.printColor('\n=== BẮT ĐẦU TẢI DỮ LIỆU BẤT ĐỒNG BỘ ===', AnsiHelper.magenta, isBold: true);
  
  // Hiển thị trạng thái đang tải
  stdout.write('⏳ Đang tải dữ liệu, vui lòng đợi 2 giây... ');
  
  final stopwatch = Stopwatch()..start();
  
  // Gọi hàm loadData() và đợi kết quả trả về bằng từ khóa await
  final List<int> result = await loadData();
  
  stopwatch.stop();

  AnsiHelper.printColor('✓ ĐÃ XONG!', AnsiHelper.green, isBold: true);
  
  // In kết quả nhận được
  print('\n📊 Dữ liệu nhận về: $result');
  print('⏱️ Thời gian thực tế đã chờ: ${stopwatch.elapsed.inMilliseconds / 1000} giây');

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 14!', AnsiHelper.green, isBold: true);
}
