import '../utils/ansi_helper.dart';

/// Hàm tính tổng lương sử dụng cú pháp Arrow Syntax (=>) cực kỳ ngắn gọn
double calcSalary(double hours, double rate) => hours * rate;

void run() {
  AnsiHelper.printHeader('Bài tập 6: Salary Calculation Function');
  AnsiHelper.printDesc('Xây dựng hàm calcSalary dùng cú pháp mũi tên (Arrow syntax) để tính toán lương theo giờ.');

  // Cho phép nhập số giờ và đơn giá
  AnsiHelper.printColor('Nhập thông tin tính lương (hoặc Enter để lấy mặc định 45 giờ, 150.000 đ/giờ):', AnsiHelper.cyan);
  
  double hours = 45.0;
  double rate = 150000.0;

  final inputHours = AnsiHelper.readString('Nhập số giờ làm việc: ', allowEmpty: true);
  if (inputHours.isNotEmpty) {
    hours = double.tryParse(inputHours) ?? 45.0;
  }

  final inputRate = AnsiHelper.readString('Nhập đơn giá mỗi giờ (VND): ', allowEmpty: true);
  if (inputRate.isNotEmpty) {
    rate = double.tryParse(inputRate) ?? 150000.0;
  }

  // Gọi hàm tính lương
  double totalSalary = calcSalary(hours, rate);

  // Hiển thị kết quả định dạng tiền tệ đẹp mắt
  AnsiHelper.printColor('\n=== BẢNG TÍNH LƯƠNG NHÂN VIÊN ===', AnsiHelper.magenta, isBold: true);
  print('⏱️ Số giờ làm việc : $hours giờ');
  print('💰 Đơn giá mỗi giờ : ${AnsiHelper.formatCurrency(rate)} / giờ');
  stdout.write('💵 Tổng lương nhận  : ');
  AnsiHelper.printColor(AnsiHelper.formatCurrency(totalSalary), AnsiHelper.green, isBold: true);

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 6!', AnsiHelper.green, isBold: true);
}
