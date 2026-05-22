import 'dart:io';

class AnsiHelper {
  // ANSI Color codes
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String bold = '\x1B[1m';

  /// Clear the console screen
  static void clearScreen() {
    if (Platform.isWindows) {
      stdout.write('\x1B[2J\x1B[0;0H');
    } else {
      stdout.write('\x1B[2J\x1B[3J\x1B[H');
    }
  }

  /// Print a colored message to stdout
  static void printColor(String message, String color, {bool isBold = false}) {
    final prefix = isBold ? '$bold$color' : color;
    print('$prefix$message$reset');
  }

  /// Print a beautifully formatted section header
  static void printHeader(String title) {
    print('');
    printColor('========================================================================', cyan, isBold: true);
    printColor('   🚀 $title', magenta, isBold: true);
    printColor('========================================================================', cyan, isBold: true);
  }

  /// Print a beautifully formatted exercise description
  static void printDesc(String desc) {
    printColor('📝 Yêu cầu: $desc', yellow);
    printColor('------------------------------------------------------------------------', yellow);
  }

  /// Read a string from console. Ensures non-empty if allowEmpty is false.
  static String readString(String prompt, {bool allowEmpty = false, List<String>? options}) {
    while (true) {
      stdout.write('$prompt');
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) {
        if (allowEmpty) return '';
        printColor('⚠️ Giá trị nhập vào không được trống. Vui lòng nhập lại!', yellow);
        continue;
      }

      if (options != null && !options.contains(input)) {
        printColor('⚠️ Giá trị phải thuộc: ${options.join(", ")}. Vui lòng nhập lại!', yellow);
        continue;
      }

      return input;
    }
  }

  /// Read a double from console with validation and optional range limits
  static double readDouble(String prompt, {double? min, double? max}) {
    while (true) {
      stdout.write('$prompt');
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) {
        printColor('⚠️ Giá trị không được để trống!', yellow);
        continue;
      }

      final value = double.tryParse(input);
      if (value == null) {
        printColor('⚠️ Định dạng số thực không hợp lệ. Vui lòng nhập lại!', red);
        continue;
      }

      if (min != null && value < min) {
        printColor('⚠️ Giá trị phải từ $min trở lên. Vui lòng nhập lại!', yellow);
        continue;
      }

      if (max != null && value > max) {
        printColor('⚠️ Giá trị không được lớn hơn $max. Vui lòng nhập lại!', yellow);
        continue;
      }

      return value;
    }
  }

  /// Read an integer from console with validation and optional range limits
  static int readInt(String prompt, {int? min, int? max}) {
    while (true) {
      stdout.write('$prompt');
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) {
        printColor('⚠️ Giá trị không được để trống!', yellow);
        continue;
      }

      final value = int.tryParse(input);
      if (value == null) {
        printColor('⚠️ Định dạng số nguyên không hợp lệ. Vui lòng nhập lại!', red);
        continue;
      }

      if (min != null && value < min) {
        printColor('⚠️ Giá trị phải từ $min trở lên. Vui lòng nhập lại!', yellow);
        continue;
      }

      if (max != null && value > max) {
        printColor('⚠️ Giá trị không được lớn hơn $max. Vui lòng nhập lại!', yellow);
        continue;
      }

      return value;
    }
  }

  /// Read confirmation from user
  static bool readConfirm(String prompt) {
    while (true) {
      stdout.write('$prompt (C/K hoặc Y/N): ');
      final input = stdin.readLineSync()?.trim().toLowerCase();
      if (input == 'c' || input == 'y' || input == 'yes') {
        return true;
      }
      if (input == 'k' || input == 'n' || input == 'no') {
        return false;
      }
      printColor('⚠️ Chỉ chấp nhận C (Có) hoặc K (Không).', yellow);
    }
  }

  /// Format double amount into VND format (e.g., 1.250.000 đ)
  static String formatCurrency(double amount) {
    final buffer = StringBuffer();
    final str = amount.round().toString();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i > 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return '${buffer.toString().split('').reversed.join('')} đ';
  }
}
