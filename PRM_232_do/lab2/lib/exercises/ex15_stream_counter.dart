import 'dart:async';
import '../utils/ansi_helper.dart';

/// Hàm tạo ra một Stream bất đồng bộ phát ra các số từ 1 đến 5 sau mỗi giây
Stream<int> countStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Phát dữ liệu vào Stream
  }
}

Future<void> run() async {
  AnsiHelper.printHeader('Bài tập 15: Stream Counter');
  AnsiHelper.printDesc('Lập trình bất đồng bộ: Phát ra chuỗi số từ 1 đến 5 sau mỗi giây và dùng StreamSubscription lắng nghe.');

  AnsiHelper.printColor('\n=== BẮT ĐẦU ĐĂNG KÝ LẮNG NGHE STREAM ===', AnsiHelper.magenta, isBold: true);
  
  // Lấy đối tượng Stream
  final stream = countStream();

  // Khởi tạo một Completer để đồng bộ hàm run() đợi cho đến khi Stream hoàn thành xong
  final completer = Completer<void>();

  // Đăng ký lắng nghe (Subscribe) bằng hàm listen()
  late StreamSubscription<int> subscription;
  
  subscription = stream.listen(
    (number) {
      AnsiHelper.printColor('🔔 Stream phát ra giá trị: $number', AnsiHelper.cyan, isBold: true);
    },
    onError: (err) {
      print('❌ Có lỗi xảy ra: $err');
      subscription.cancel(); // Hủy đăng ký khi gặp lỗi
      completer.complete();
    },
    onDone: () {
      AnsiHelper.printColor('🏁 Stream đã phát hết dữ liệu (Done)!', AnsiHelper.green);
      
      // Hủy đăng ký lắng nghe sau khi hoàn thành (Subscription Clean-up)
      print('🧹 Đang dọn dẹp và hủy (cancel) Stream subscription...');
      subscription.cancel();
      
      completer.complete();
    },
    cancelOnError: true,
  );

  // Đợi cho đến khi Stream hoàn tất
  await completer.future;

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 15!', AnsiHelper.green, isBold: true);
}
