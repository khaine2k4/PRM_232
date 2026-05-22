import 'dart:io';

class InputHelper {
  // ANSI colors
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String bold = '\x1B[1m';

  /// Print a colored message
  static void printColor(String message, String color, {bool isBold = false}) {
    final prefix = isBold ? '$bold$color' : color;
    print('$prefix$message$reset');
  }

  /// Read a non-empty string from user input
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
        printColor('⚠️ Giá trị phải thuộc danh sách: ${options.join(", ")}. Vui lòng nhập lại!', yellow);
        continue;
      }

      return input;
    }
  }

  /// Read a valid double from user input with range checking
  static double readDouble(String prompt, {double? min, double? max}) {
    while (true) {
      stdout.write('$prompt');
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) {
        printColor('⚠️ Giá trị số không được trống!', yellow);
        continue;
      }

      final value = double.tryParse(input);
      if (value == null) {
        printColor('⚠️ Sai định dạng số thực. Vui lòng nhập lại!', red);
        continue;
      }

      if (min != null && value < min) {
        printColor('⚠️ Giá trị phải từ $min trở lên. Vui lòng nhập lại!', yellow);
        continue;
      }

      if (max != null && value > max) {
        printColor('⚠️ Giá trị không được vượt quá $max. Vui lòng nhập lại!', yellow);
        continue;
      }

      return value;
    }
  }

  /// Read a valid integer from user input with range checking
  static int readInt(String prompt, {int? min, int? max}) {
    while (true) {
      stdout.write('$prompt');
      final input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) {
        printColor('⚠️ Giá trị số nguyên không được trống!', yellow);
        continue;
      }

      final value = int.tryParse(input);
      if (value == null) {
        printColor('⚠️ Sai định dạng số nguyên. Vui lòng nhập lại!', red);
        continue;
      }

      if (min != null && value < min) {
        printColor('⚠️ Giá trị phải lớn hơn hoặc bằng $min!', yellow);
        continue;
      }

      if (max != null && value > max) {
        printColor('⚠️ Giá trị phải nhỏ hơn hoặc bằng $max!', yellow);
        continue;
      }

      return value;
    }
  }

  /// Read a confirmation prompt (Y/N or C/K in Vietnamese)
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
      printColor('⚠️ Chỉ chấp nhận C (Có/Yes) hoặc K (Không/No).', yellow);
    }
  }

  /// Formats currency to standard Vietnamese Dong (VND) display style (e.g. 15.000.000 đ)
  static String formatCurrency(double amount) {
    // Format simple thousands separator for VND
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
