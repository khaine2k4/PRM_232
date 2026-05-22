import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 10: Student Score Map');
  AnsiHelper.printDesc('Tạo Map lưu tên học sinh và điểm số, tìm và hiển thị học sinh có điểm cao nhất.');

  // Tạo Map<String, int> chứa thông tin học sinh
  final Map<String, int> studentScores = {
    'Nguyễn Văn An': 85,
    'Lê Thị Bình': 92,
    'Trần Văn Cường': 78,
    'Phạm Thị Dung': 96,
    'Đỗ Hoàng Giang': 89,
  };

  AnsiHelper.printColor('\n=== DANH SÁCH HỌC SINH VÀ ĐIỂM SỐ ===', AnsiHelper.magenta, isBold: true);
  studentScores.forEach((name, score) {
    print('👤 $name: $score điểm');
  });

  // Tìm học sinh có điểm cao nhất
  String highestStudent = '';
  int highestScore = -1; // Khởi tạo điểm thấp nhất để tìm kiếm

  for (final entry in studentScores.entries) {
    if (entry.value > highestScore) {
      highestScore = entry.value;
      highestStudent = entry.key;
    }
  }

  // In kết quả người cao điểm nhất
  AnsiHelper.printColor('\n=== HỌC SINH CÓ ĐIỂM SỐ CAO NHẤT ===', AnsiHelper.magenta, isBold: true);
  print('🥇 Họ và tên: $highestStudent');
  stdout.write('💯 Điểm số   : ');
  AnsiHelper.printColor('$highestScore điểm', AnsiHelper.green, isBold: true);

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 10!', AnsiHelper.green, isBold: true);
}
