import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 4: Student Grade Classification');
  AnsiHelper.printDesc('Sử dụng cấu trúc rẽ nhánh if/else để phân loại kết quả học tập dựa trên điểm số.');

  // Cho phép nhập điểm từ bàn phím với kiểm tra ràng buộc từ 0 đến 100
  AnsiHelper.printColor('Nhập điểm số để phân loại (hoặc Enter để lấy mặc định score = 78):', AnsiHelper.cyan);
  
  double score = 78.0;
  final input = AnsiHelper.readString('Nhập điểm (0.0 - 100.0): ', allowEmpty: true);
  if (input.isNotEmpty) {
    score = double.tryParse(input) ?? 78.0;
    if (score < 0 || score > 100) {
      AnsiHelper.printColor('⚠️ Điểm không hợp lệ! Đã chuyển về điểm mặc định: 78.0', AnsiHelper.yellow);
      score = 78.0;
    }
  }

  // Phân loại điểm số theo yêu cầu đề bài
  String classification;
  String colorCode;

  if (score < 50) {
    classification = 'Fail (Yếu/Kém)';
    colorCode = AnsiHelper.red;
  } else if (score <= 65) {
    classification = 'Average (Trung bình)';
    colorCode = AnsiHelper.yellow;
  } else if (score <= 80) {
    classification = 'Good (Khá)';
    colorCode = AnsiHelper.blue;
  } else {
    classification = 'Excellent (Xuất sắc)';
    colorCode = AnsiHelper.green;
  }

  // Hiển thị kết quả phân loại
  AnsiHelper.printColor('\n=== KẾT QUẢ PHÂN LOẠI ===', AnsiHelper.magenta, isBold: true);
  print('📊 Điểm số đạt được: $score');
  stdout.write('🏆 Phân loại học lực: ');
  AnsiHelper.printColor(classification, colorCode, isBold: true);

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 4!', AnsiHelper.green, isBold: true);
}
