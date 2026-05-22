import 'dart:io';
import '../utils/ansi_helper.dart';

/// Lớp đại diện cho sản phẩm
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() {
    return '[$id] $name - ${AnsiHelper.formatCurrency(price)}';
  }
}

/// Lớp đại diện cho mặt hàng trong giỏ hàng (bao gồm sản phẩm và số lượng)
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalValue => product.price * quantity;
}

/// Lớp quản lý giỏ hàng
class CartSystem {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  /// Thêm sản phẩm vào giỏ hàng
  void addProduct(Product product, int quantity) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    for (final item in _items) {
      if (item.product.id == product.id) {
        item.quantity += quantity;
        return;
      }
    }
    // Chưa có thì thêm mới
    _items.add(CartItem(product: product, quantity: quantity));
  }

  /// Xóa sản phẩm khỏi giỏ hàng bằng ID
  bool removeProduct(String id) {
    final originalLength = _items.length;
    _items.removeWhere((item) => item.product.id.toLowerCase() == id.trim().toLowerCase());
    return _items.length < originalLength;
  }

  /// Tính tổng tiền của giỏ hàng
  double calculateTotal() {
    double total = 0;
    for (final item in _items) {
      total += item.totalValue;
    }
    return total;
  }

  /// Làm trống giỏ hàng
  void clear() {
    _items.clear();
  }
}

/// Danh sách sản phẩm có sẵn tại cửa hàng mẫu
final List<Product> shopProducts = [
  Product(id: 'P01', name: 'Điện thoại iPhone 15 Pro Max', price: 29990000),
  Product(id: 'P02', name: 'Laptop MacBook Air M3', price: 27490000),
  Product(id: 'P03', name: 'Tai nghe Apple AirPods Pro 2', price: 5690000),
  Product(id: 'P04', name: 'Đồng hồ Apple Watch Ultra 2', price: 21990000),
  Product(id: 'P05', name: 'Củ sạc nhanh 20W Type-C', price: 490000),
];

Future<void> run() async {
  final cart = CartSystem();
  bool inCartMenu = true;

  // Nạp sẵn một số sản phẩm vào giỏ hàng ban đầu để hiển thị demo theo mẫu
  cart.addProduct(shopProducts[4], 3); // 3 Củ sạc = 1,470,000 đ
  cart.addProduct(shopProducts[2], 1); // 1 AirPods = 5,690,000 đ

  while (inCartMenu) {
    AnsiHelper.clearScreen();
    AnsiHelper.printHeader('Bài tập 16: Mini Project – Cart System');
    AnsiHelper.printDesc('Tích hợp đầy đủ kiến thức về OOP, List, null-safety, async/await Future delay để tạo hệ thống giỏ hàng.');

    print('\n============================== CỬA HÀNG MẪU ============================');
    for (final p in shopProducts) {
      print('  • $p');
    }
    print('========================================================================');

    // Hiển thị giỏ hàng hiện tại
    print('\n🛒 GIỎ HÀNG CỦA BẠN:');
    if (cart.items.isEmpty) {
      AnsiHelper.printColor('  (Giỏ hàng trống)', AnsiHelper.yellow);
    } else {
      const sep = '+-------+-------------------------------+----------+-----------------+';
      print(sep);
      print('| Mã SP | Tên sản phẩm                  | Số lượng | Thành tiền      |');
      print(sep);
      for (final item in cart.items) {
        final idCell = item.product.id.padRight(5);
        final nameCell = item.product.name.padRight(29).substring(0, 29);
        final qtyCell = item.quantity.toString().padLeft(8);
        final totalCell = AnsiHelper.formatCurrency(item.totalValue).padLeft(15);
        print('| $idCell | $nameCell | $qtyCell | $totalCell |');
      }
      print(sep);
      
      stdout.write('💵 Tổng tiền giỏ hàng (Cart Total): ');
      AnsiHelper.printColor(AnsiHelper.formatCurrency(cart.calculateTotal()), AnsiHelper.green, isBold: true);
    }

    // Menu thao tác
    print('\n⭐ CÁC THAO TÁC HỖ TRỢ:');
    print('  1. 📥 Thêm sản phẩm vào giỏ hàng');
    print('  2. ❌ Xóa sản phẩm khỏi giỏ hàng');
    print('  3. 💳 Thanh toán (Simulate async checkout)');
    print('  0. ↩ Quay lại Menu chính');
    print('------------------------------------------------------------------------');
    
    final choice = AnsiHelper.readString('👉 Nhập lựa chọn của bạn (0-3): ');

    switch (choice) {
      case '1':
        print('\n--- THÊM SẢN PHẨM VÀO GIỎ HÀNG ---');
        final id = AnsiHelper.readString('Nhập mã sản phẩm muốn thêm (P01 - P05): ').toUpperCase();
        
        // Tìm sản phẩm bằng Null Safety
        Product? selectedProduct;
        for (final p in shopProducts) {
          if (p.id == id) {
            selectedProduct = p;
            break;
          }
        }

        if (selectedProduct == null) {
          AnsiHelper.printColor('❌ Mã sản phẩm không tồn tại!', AnsiHelper.red);
        } else {
          final qty = AnsiHelper.readInt('Nhập số lượng muốn mua: ', min: 1);
          cart.addProduct(selectedProduct, qty);
          AnsiHelper.printColor('✓ Đã thêm ${selectedProduct.name} (SL: $qty) vào giỏ hàng!', AnsiHelper.green);
        }
        break;

      case '2':
        print('\n--- XÓA SẢN PHẨM KHỎI GIỎ HÀNG ---');
        if (cart.items.isEmpty) {
          AnsiHelper.printColor('⚠️ Giỏ hàng đang trống, không có gì để xóa!', AnsiHelper.yellow);
        } else {
          final idToDelete = AnsiHelper.readString('Nhập mã sản phẩm cần xóa: ');
          final success = cart.removeProduct(idToDelete);
          if (success) {
            AnsiHelper.printColor('✓ Đã xóa sản phẩm "$idToDelete" khỏi giỏ hàng thành công!', AnsiHelper.green);
          } else {
            AnsiHelper.printColor('❌ Không tìm thấy mã sản phẩm "$idToDelete" trong giỏ hàng!', AnsiHelper.red);
          }
        }
        break;

      case '3':
        print('\n--- TIẾN HÀNH THANH TOÁN ---');
        if (cart.items.isEmpty) {
          AnsiHelper.printColor('⚠️ Giỏ hàng trống! Hãy thêm sản phẩm trước khi thanh toán.', AnsiHelper.yellow);
        } else {
          final totalAmount = cart.calculateTotal();
          AnsiHelper.printColor('Tổng tiền cần thanh toán: ${AnsiHelper.formatCurrency(totalAmount)}', AnsiHelper.cyan, isBold: true);
          
          final confirm = AnsiHelper.readConfirm('Xác nhận thanh toán hóa đơn này?');
          if (confirm) {
            // Giả lập xử lý thanh toán bất đồng bộ gửi yêu cầu lên server
            stdout.write('⏳ Đang xử lý giao dịch qua cổng thanh toán, vui lòng đợi... ');
            await Future.delayed(Duration(seconds: 2)); // Trì hoãn 2 giây giả lập
            
            AnsiHelper.printColor('✓ THÀNH CÔNG!', AnsiHelper.green, isBold: true);
            AnsiHelper.printColor('\n🎉 GIAO DỊCH THÀNH CÔNG! CẢM ƠN BẠN ĐÃ MUA SẮM!', AnsiHelper.magenta, isBold: true);
            print('------------------------------------------------------------------------');
            print('🧾 HÓA ĐƠN THANH TOÁN:');
            print('• Mã hóa đơn: BILL-${DateTime.now().millisecondsSinceEpoch}');
            print('• Tổng thanh toán: ${AnsiHelper.formatCurrency(totalAmount)}');
            print('• Trạng thái: Đã hoàn tất thực lĩnh');
            print('------------------------------------------------------------------------');
            
            cart.clear(); // Làm sạch giỏ hàng sau thanh toán
          } else {
            AnsiHelper.printColor('↩ Giao dịch thanh toán đã bị hủy bỏ.', AnsiHelper.yellow);
          }
        }
        break;

      case '0':
        inCartMenu = false;
        break;

      default:
        AnsiHelper.printColor('❌ Lựa chọn không hợp lệ! Vui lòng chọn lại.', AnsiHelper.red);
    }

    if (inCartMenu) {
      AnsiHelper.printColor('\nẤn [ENTER] để tiếp tục trong Giỏ hàng...', AnsiHelper.blue);
      stdin.readLineSync();
    }
  }
}
