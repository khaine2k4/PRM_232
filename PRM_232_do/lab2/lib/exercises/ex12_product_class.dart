import '../utils/ansi_helper.dart';

class Product {
  String id;
  String name;
  double price;
  int quantity;

  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Phương thức tính tổng giá trị của mặt hàng này
  double total() {
    return price * quantity;
  }

  // Override toString để hiển thị sản phẩm đẹp mắt
  @override
  String toString() {
    return 'Mã SP: $id | Tên: $name | Đơn giá: ${AnsiHelper.formatCurrency(price)} | SL: $quantity | Thành tiền: ${AnsiHelper.formatCurrency(total())}';
  }
}

void run() {
  AnsiHelper.printHeader('Bài tập 12: Product Class');
  AnsiHelper.printDesc('Định nghĩa lớp Product gồm các thuộc tính và phương thức total() để tính tổng giá trị mặt hàng.');

  // Tạo một sản phẩm mẫu
  final product = Product(
    id: 'SP001',
    name: 'Laptop ASUS ROG Strix',
    price: 32500000.0,
    quantity: 3,
  );

  // Hiển thị thông tin sản phẩm và kết quả tính tổng tiền
  AnsiHelper.printColor('\n=== CHI TIẾT SẢN PHẨM KHỞI TẠO ===', AnsiHelper.magenta, isBold: true);
  print('🆔 Mã sản phẩm : ${product.id}');
  print('📦 Tên sản phẩm: ${product.name}');
  print('💰 Đơn giá     : ${AnsiHelper.formatCurrency(product.price)}');
  print('🔢 Số lượng    : ${product.quantity} cái');
  print('------------------------------------------------------------------------');
  stdout.write('💵 Tổng giá trị: ');
  AnsiHelper.printColor(AnsiHelper.formatCurrency(product.total()), AnsiHelper.green, isBold: true);

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 12!', AnsiHelper.green, isBold: true);
}
