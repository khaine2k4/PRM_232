import 'dart:convert';
import 'dart:io';
import '../lib/utils/ansi_helper.dart';
import '../lib/exercises/ex01_extended_hello.dart' as ex01;
import '../lib/exercises/ex02_simple_calculator.dart' as ex02;
import '../lib/exercises/ex03_variables_constants.dart' as ex03;
import '../lib/exercises/ex04_grade_classification.dart' as ex04;
import '../lib/exercises/ex05_task_schedule.dart' as ex05;
import '../lib/exercises/ex06_salary_calc.dart' as ex06;
import '../lib/exercises/ex07_named_params.dart' as ex07;
import '../lib/exercises/ex08_number_list.dart' as ex08;
import '../lib/exercises/ex09_set_uniqueness.dart' as ex09;
import '../lib/exercises/ex10_student_map.dart' as ex10;
import '../lib/exercises/ex11_student_class.dart' as ex11;
import '../lib/exercises/ex12_product_class.dart' as ex12;
import '../lib/exercises/ex13_inheritance.dart' as ex13;
import '../lib/exercises/ex14_future_loading.dart' as ex14;
import '../lib/exercises/ex15_stream_counter.dart' as ex15;
import '../lib/exercises/ex16_cart_system.dart' as ex16;
import '../lib/exercises/ex17_quiz_system.dart' as ex17;

Future<void> main() async {
  // Set console encoding to UTF-8 to display Vietnamese characters nicely on Windows
  stdout.encoding = utf8;

  bool running = true;

  while (running) {
    AnsiHelper.clearScreen();
    printWelcomeBanner();
    printMainMenu();

    final choice = AnsiHelper.readInt('👉 Nhập số bài tập bạn muốn chạy (0-17): ', min: 0, max: 17);

    AnsiHelper.clearScreen();

    switch (choice) {
      case 1:
        ex01.run();
        break;
      case 2:
        ex02.run();
        break;
      case 3:
        ex03.run();
        break;
      case 4:
        ex04.run();
        break;
      case 5:
        ex05.run();
        break;
      case 6:
        ex06.run();
        break;
      case 7:
        ex07.run();
        break;
      case 8:
        ex08.run();
        break;
      case 9:
        ex09.run();
        break;
      case 10:
        ex10.run();
        break;
      case 11:
        ex11.run();
        break;
      case 12:
        ex12.run();
        break;
      case 13:
        ex13.run();
        break;
      case 14:
        await ex14.run();
        break;
      case 15:
        await ex15.run();
        break;
      case 16:
        await ex16.run();
        break;
      case 17:
        await ex17.run();
        break;
      case 0:
        running = false;
        AnsiHelper.printColor('\n👋 Cảm ơn thầy cô và các bạn đã theo dõi! Tạm biệt.', AnsiHelper.cyan, isBold: true);
        break;
      default:
        AnsiHelper.printColor('❌ Lựa chọn không hợp lệ!', AnsiHelper.red);
    }

    if (running) {
      AnsiHelper.printColor('\nẤn [ENTER] để quay lại Menu chính...', AnsiHelper.blue);
      stdin.readLineSync();
    }
  }
}

/// In tiêu đề mở đầu bằng chữ ASCII nghệ thuật
void printWelcomeBanner() {
  print('');
  AnsiHelper.printColor('   ██████╗  █████╗ ██████╗ ████████╗    ██╗      █████╗ ██████╗ ██████╗ ', AnsiHelper.magenta, isBold: true);
  AnsiHelper.printColor('   ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝    ██║     ██╔══██╗██╔══██╗╚════██╗', AnsiHelper.magenta, isBold: true);
  AnsiHelper.printColor('   ██║  ██║███████║██████╔╝   ██║       ██║     ███████║██████╔╝ █████╔╝', AnsiHelper.magenta, isBold: true);
  AnsiHelper.printColor('   ██║  ██║██╔══██║██╔══██╗   ██║       ██║     ██╔══██║██╔══██╗██╔═══╝ ', AnsiHelper.magenta, isBold: true);
  AnsiHelper.printColor('   ██████╔╝██║  ██║██║  ██║   ██║       ███████╗██║  ██║██████╔╝███████╗', AnsiHelper.magenta, isBold: true);
  AnsiHelper.printColor('   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝', AnsiHelper.magenta, isBold: true);
  AnsiHelper.printColor('            17 BÀI TẬP DART CƠ BẢN ĐẾN NÂNG CAO - PRM232 LAB 2', AnsiHelper.cyan, isBold: true);
  print('========================================================================');
}

/// In danh sách menu 17 bài tập gọn gàng
void printMainMenu() {
  print('\n------------------------------- THƯ MỤC LỰA CHỌN -----------------------');
  
  // Sử dụng cấu trúc cột đôi để menu gọn hơn
  print('  [ CƠ BẢN & CÚ PHÁP ]                      [ HÀM & THAM SỐ ]');
  print('   1. Extended Hello Dart                    6. Salary Calculation Function');
  print('   2. Simple Calculator                      7. Function with Named Parameters');
  print('   3. Variables and Constants');
  print('');
  print('  [ CẤU TRÚC ĐIỀU KHIỂN ]                   [ COLLECTIONS ]');
  print('   4. Student Grade Classification           8. Number List Processing');
  print('   5. Task Schedule by Day                   9. Set Uniqueness Test');
  print('                                            10. Student Score Map');
  print('');
  print('  [ HƯỚNG ĐỐI TƯỢNG (OOP) ]                 [ BẤT ĐỒNG BỘ (ASYNC) ]');
  print('  11. Student Class                         14. Future Data Loading');
  print('  12. Product Class                         15. Stream Counter');
  print('  13. Inheritance Practice');
  print('');
  print('  [ DỰ ÁN MINI CAPSTONE PROJECTS ]');
  print('  16. 🛒 Mini Project – Cart System (Hệ thống Giỏ hàng)');
  print('  17. 📝 Mini Project – Quiz System (Hệ thống Thi trắc nghiệm)');
  print('');
  print('   0. 🚪 Thoát chương trình');
  print('========================================================================');
}
