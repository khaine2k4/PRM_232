import '../utils/ansi_helper.dart';

/// Hàm đăng ký tài khoản sử dụng Named Parameters (Tham số đặt tên)
/// - [name] là tham số bắt buộc nhờ từ khóa `required`
/// - [age] là tham số tùy chọn có giá trị mặc định bằng `18`
void register({required String name, int age = 18}) {
  print('📝 Đăng ký thành công: Học viên [Họ tên: $name, Tuổi: $age]');
}

void run() {
  AnsiHelper.printHeader('Bài tập 7: Function with Named Parameters');
  AnsiHelper.printDesc('Xây dựng hàm register sử dụng các tham số đặt tên tùy chọn và bắt buộc.');

  AnsiHelper.printColor('\n=== GỌI HÀM VỚI CÁC KIỂU ĐỐI SỐ KHÁC NHAU ===', AnsiHelper.magenta, isBold: true);

  // Kiểu 1: Chỉ truyền tham số bắt buộc 'name', 'age' tự động lấy giá trị mặc định là 18
  print('👉 Cách 1: Chỉ truyền name (register(name: "Nguyễn Văn An"))');
  register(name: 'Nguyễn Văn An');
  print('');

  // Kiểu 2: Truyền cả hai tham số đặt tên
  print('👉 Cách 2: Truyền cả name và age (register(name: "Trần Thị Bình", age: 22))');
  register(name: 'Trần Thị Bình', age: 22);
  print('');

  // Kiểu 3: Truyền tham số nhưng thay đổi thứ tự truyền (đây là ưu điểm lớn của Named Parameters)
  print('👉 Cách 3: Thay đổi thứ tự truyền đối số (register(age: 25, name: "Phạm Văn Cường"))');
  register(age: 25, name: 'Phạm Văn Cường');

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 7!', AnsiHelper.green, isBold: true);
}
