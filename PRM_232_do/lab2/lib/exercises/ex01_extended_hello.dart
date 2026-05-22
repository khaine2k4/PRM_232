import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 1: Extended Hello Dart');
  AnsiHelper.printDesc('Khai báo các biến thông tin học sinh và định dạng đầu ra dùng String Interpolation.');

  // Khai báo các biến với các kiểu dữ liệu cơ bản
  String studentName = 'Nguyễn Lâm Bảo';
  int age = 21;
  double gpa = 3.82;

  // In thông tin sử dụng String Interpolation
  AnsiHelper.printColor('\n=== THÔNG TIN HỌC SINH ===', AnsiHelper.magenta, isBold: true);
  print('👤 Họ và tên: $studentName');
  print('📅 Tuổi:       $age tuổi');
  print('🏆 GPA:        $gpa / 4.0');
  
  // Minh họa string interpolation phức tạp hơn
  print('💬 Tóm tắt: Học sinh $studentName ($age tuổi) có kết quả học tập đạt GPA $gpa.');
  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 1!', AnsiHelper.green, isBold: true);
}
