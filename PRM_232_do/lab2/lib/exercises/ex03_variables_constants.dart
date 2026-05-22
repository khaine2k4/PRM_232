import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 3: Variables and Constants');
  AnsiHelper.printDesc('Minh họa cách sử dụng var, dynamic, final, const và giải thích chi tiết.');

  /*
   * 1. 'var' - Suy luận kiểu dữ liệu tự động (Type Inference)
   * Kiểu dữ liệu sẽ được xác định ngay khi gán giá trị lần đầu và KHÔNG THỂ thay đổi kiểu 
   * ở các dòng code tiếp theo (Static Typing).
   */
  var city = 'Hà Nội'; // Dart tự hiểu city là String
  // city = 100; // ❌ Báo lỗi biên dịch vì city đã cố định kiểu String
  city = 'TP. Hồ Chí Minh'; // Hoạt động tốt vì cùng kiểu String

  /*
   * 2. 'dynamic' - Kiểu dữ liệu động (Dynamic Typing)
   * Biến có kiểu dynamic có thể chứa bất kỳ kiểu dữ liệu nào và có thể thay đổi kiểu thoải mái
   * trong suốt thời gian chạy (Runtime).
   */
  dynamic tempValue = 100; // Ban đầu là kiểu int
  print('• dynamic ban đầu (int): $tempValue (Kiểu: ${tempValue.runtimeType})');
  tempValue = 'Một trăm'; // Thay đổi thành String
  print('• dynamic sau đó (String): $tempValue (Kiểu: ${tempValue.runtimeType})');

  /*
   * 3. 'final' - Hằng số gán một lần (Runtime Constant)
   * Giá trị chỉ được gán một lần duy nhất. Có thể gán từ kết quả tính toán tại thời gian chạy (Runtime).
   */
  final DateTime currentRuntimeTime = DateTime.now(); // Lấy thời gian hiện tại lúc chạy app

  /*
   * 4. 'const' - Hằng số biên dịch (Compile-time Constant)
   * Giá trị phải được xác định ngay từ thời điểm biên dịch (Compile-time). Phải là một giá trị hằng.
   */
  const double pi = 3.14159; // Giá trị Pi cố định, biết trước khi chạy chương trình
  // const DateTime invalidConst = DateTime.now(); // ❌ Lỗi: Giá trị DateTime.now() chỉ biết được khi chạy app

  // In kết quả minh họa ra màn hình
  AnsiHelper.printColor('\n=== MINH HỌA KHAI BÁO BIẾN ===', AnsiHelper.magenta, isBold: true);
  print('📍 Biến "var" (city):               $city');
  print('🔄 Biến "dynamic" (tempValue):      $tempValue');
  print('⏳ Hằng số "final" (DateTime):      $currentRuntimeTime');
  print('🧱 Hằng số "const" (pi):            $pi');

  // Giải thích chi tiết bằng console output
  AnsiHelper.printColor('\n📚 GIẢI THÍCH SỰ KHÁC BIỆT:', AnsiHelper.cyan, isBold: true);
  print(' 1. [var]: Tự động suy luận kiểu và khóa kiểu đó lại. An toàn hơn trong lập trình.');
  print(' 2. [dynamic]: Cho phép thay đổi kiểu linh hoạt nhưng dễ gây lỗi Runtime nếu gọi sai phương thức.');
  print(' 3. [final]: Hằng số gán một lần ở thời gian chạy (Runtime constant). Thích hợp lưu trữ kết quả từ API, Database.');
  print(' 4. [const]: Hằng số xác định lúc biên dịch (Compile-time constant). Tiết kiệm bộ nhớ vì được tối ưu sẵn.');

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 3!', AnsiHelper.green, isBold: true);
}
