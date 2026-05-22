import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 9: Set Uniqueness Test');
  AnsiHelper.printDesc('Tạo Set<String> chứa tên khóa học và minh chứng phần tử trong Set là duy nhất, không trùng lặp.');

  // Khởi tạo Set<String> chứa một số tên khóa học ban đầu
  final Set<String> courses = {'Flutter', 'Dart OOP', 'Web Development'};

  AnsiHelper.printColor('\n=== SET BAN ĐẦU ===', AnsiHelper.magenta, isBold: true);
  print('📚 Courses = $courses');

  // Thêm một số khóa học mới không bị trùng
  AnsiHelper.printColor('\n👉 Tiến hành thêm khóa học mới "NodeJS":', AnsiHelper.cyan);
  bool addSuccess1 = courses.add('NodeJS');
  print('• Kết quả thêm: ${addSuccess1 ? "Thành công (True)" : "Thất bại (False)"}');
  print('📚 Set hiện tại: $courses');

  // Thử thêm khóa học đã tồn tại trong Set (trùng lặp)
  AnsiHelper.printColor('\n👉 Tiến hành thử thêm trùng lặp khóa học "Flutter":', AnsiHelper.cyan);
  bool addSuccess2 = courses.add('Flutter');
  stdout.write('• Kết quả thêm: ');
  AnsiHelper.printColor(addSuccess2 ? 'Thành công (True)' : 'Thất bại (False)', AnsiHelper.red, isBold: true);
  print('📚 Set sau khi cố tình thêm trùng lặp: $courses');

  // Kết luận lý thuyết về Set
  AnsiHelper.printColor('\n💡 KẾT LUẬN RÚT RA:', AnsiHelper.yellow, isBold: true);
  print(' 1. Set là tập hợp các phần tử không có thứ tự và KHÔNG chứa phần tử trùng lặp.');
  print(' 2. Khi thêm một phần tử đã tồn tại, Set sẽ tự động bỏ qua và trả về kết quả là `false`.');
  print(' 3. Set cực kỳ hữu dụng khi bạn cần lưu trữ một tập hợp phần tử độc nhất (ví dụ: danh sách ID, email,...).');

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 9!', AnsiHelper.green, isBold: true);
}
