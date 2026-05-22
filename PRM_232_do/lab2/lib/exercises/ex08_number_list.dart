import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 8: Number List Processing');
  AnsiHelper.printDesc('Tạo một List gồm 10 số nguyên, duyệt qua list bằng vòng lặp for-in để lọc ra số chẵn và số lẻ.');

  // Tạo List<int> có 10 phần tử ngẫu nhiên/cố định
  final List<int> numbers = [12, 45, 8, 23, 56, 89, 4, 71, 38, 90];

  AnsiHelper.printColor('\n=== DANH SÁCH BAN ĐẦU ===', AnsiHelper.magenta, isBold: true);
  print('📊 numbers = $numbers');

  final List<int> evens = [];
  final List<int> odds = [];

  // Sử dụng vòng lặp for-in theo đúng yêu cầu đề bài
  for (final num in numbers) {
    if (num % 2 == 0) {
      evens.add(num);
    } else {
      odds.add(num);
    }
  }

  // Hiển thị kết quả lọc
  AnsiHelper.printColor('\n=== KẾT QUẢ PHÂN LOẠI (DÙNG VÒNG LẶP FOR-IN) ===', AnsiHelper.magenta, isBold: true);
  
  stdout.write('🟢 Danh sách số chẵn (Even): ');
  AnsiHelper.printColor(evens.toString(), AnsiHelper.green, isBold: true);

  stdout.write('🔵 Danh sách số lẻ (Odd)   : ');
  AnsiHelper.printColor(odds.toString(), AnsiHelper.blue, isBold: true);

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 8!', AnsiHelper.green, isBold: true);
}
