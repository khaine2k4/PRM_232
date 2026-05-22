import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 2: Simple Calculator');
  AnsiHelper.printDesc('Khai báo hai số nguyên a, b và thực hiện các phép toán cơ bản.');

  // Cho phép người dùng nhập dữ liệu hoặc sử dụng mặc định
  AnsiHelper.printColor('Nhập dữ liệu đầu vào (hoặc nhấn Enter để lấy mặc định a = 15, b = 4):', AnsiHelper.cyan);
  
  int a = 15;
  int b = 4;

  final inputA = AnsiHelper.readString('Nhập số nguyên a: ', allowEmpty: true);
  if (inputA.isNotEmpty) {
    a = int.tryParse(inputA) ?? 15;
  }
  
  final inputB = AnsiHelper.readString('Nhập số nguyên b: ', allowEmpty: true);
  if (inputB.isNotEmpty) {
    b = int.tryParse(inputB) ?? 4;
  }

  // Thực hiện các phép toán
  int sum = a + b;
  int diff = a - b;
  int product = a * b;
  double quotient = a / b;
  int remainder = a % b;

  // In kết quả
  AnsiHelper.printColor('\n=== KẾT QUẢ PHÉP TOÁN (a = $a, b = $b) ===', AnsiHelper.magenta, isBold: true);
  print('➕ Phép cộng (a + b)      : $a + $b = $sum');
  print('➖ Phép trừ (a - b)       : $a - $b = $diff');
  print('✖️ Phép nhân (a * b)      : $a * $b = $product');
  print('➗ Phép chia (a / b)      : $a / $b = ${quotient.toStringAsFixed(2)}');
  print('⚖️ Phép chia lấy dư (a % b): $a % $b = $remainder');

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 2!', AnsiHelper.green, isBold: true);
}
