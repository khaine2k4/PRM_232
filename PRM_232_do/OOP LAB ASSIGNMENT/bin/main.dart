import 'dart:convert';
import 'dart:io';
import '../lib/models/employee.dart';
import '../lib/models/administrative_employee.dart';
import '../lib/models/sales_employee.dart';
import '../lib/models/manager.dart';
import '../lib/services/employee_manager.dart';
import '../lib/utils/input_helper.dart';

void main() {
  // Set console encoding to UTF-8 to display Vietnamese characters nicely on Windows
  stdout.encoding = utf8;

  final manager = EmployeeManager();
  bool running = true;

  // Print startup welcome banner
  printWelcomeBanner();

  while (running) {
    printMainMenu();
    final choice = InputHelper.readString(
      '👉 Nhập lựa chọn của bạn (0-9 hoặc D để nạp mẫu): ',
      allowEmpty: false,
    ).toUpperCase();

    print('\n------------------------------------------------------------------------');

    switch (choice) {
      case '1':
        handleInputEmployees(manager);
        break;
      case '2':
        handleDisplayEmployees(manager.employees, 'DANH SÁCH NHÂN VIÊN TOÀN CÔNG TY');
        break;
      case '3':
        handleSearchById(manager);
        break;
      case '4':
        handleDeleteById(manager);
        break;
      case '5':
        handleUpdateById(manager);
        break;
      case '6':
        handleSearchByIncomeRange(manager);
        break;
      case '7':
        handleSortByName(manager);
        break;
      case '8':
        handleSortByIncome(manager);
        break;
      case '9':
        handleDisplayTop5(manager);
        break;
      case 'D':
        manager.loadMockData();
        InputHelper.printColor('✓ Đã nạp 6 nhân viên mẫu vào hệ thống thành công!', InputHelper.green, isBold: true);
        handleDisplayEmployees(manager.employees, 'DANH SÁCH NHÂN VIÊN MẪU');
        break;
      case '0':
        running = false;
        InputHelper.printColor('👋 Cảm ơn bạn đã sử dụng chương trình! Tạm biệt.', InputHelper.cyan, isBold: true);
        break;
      default:
        InputHelper.printColor('❌ Lựa chọn không hợp lệ! Vui lòng chọn từ 0 đến 9 hoặc D.', InputHelper.red);
    }
    
    if (running) {
      InputHelper.printColor('\nẤn [ENTER] để quay lại Menu chính...', InputHelper.blue);
      stdin.readLineSync();
    }
  }
}

/// Print startup ASCII art
void printWelcomeBanner() {
  print('');
  InputHelper.printColor('   ███████╗███╗   ███╗██████╗ ██╗      ██████╗ ██╗   ██╗███████╗███████╗', InputHelper.cyan, isBold: true);
  InputHelper.printColor('   ██╔════╝████╗ ████║██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝██╔════╝██╔════╝', InputHelper.cyan, isBold: true);
  InputHelper.printColor('   █████╗  ██╔████╔██║██████╔╝██║     ██║   ██║ ╚████╔╝ █████╗  █████╗  ', InputHelper.cyan, isBold: true);
  InputHelper.printColor('   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██║   ██║  ╚██╔╝  ██╔══╝  ██╔══╝  ', InputHelper.cyan, isBold: true);
  InputHelper.printColor('   ███████╗██║ ╚═╝ ██║██║     ███████╗╚██████╔╝   ██║   ███████╗███████╗', InputHelper.cyan, isBold: true);
  InputHelper.printColor('   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝   ╚══════╝╚══════╝', InputHelper.cyan, isBold: true);
  InputHelper.printColor('          HỆ THỐNG QUẢN LÝ LƯƠNG NHÂN VIÊN - OOP DART LAB', InputHelper.magenta, isBold: true);
  print('========================================================================');
}

/// Print Menu lists
void printMainMenu() {
  print('\n================================== MENU ================================');
  print('  1. 📥 Nhập danh sách nhân viên mới');
  print('  2. 📋 Xuất danh sách nhân viên toàn công ty');
  print('  3. 🔍 Tìm kiếm nhân viên theo Mã số (ID)');
  print('  4. ❌ Xóa nhân viên theo Mã số (ID)');
  print('  5. ✏️ Cập nhật thông tin nhân viên theo Mã số (ID)');
  print('  6. 💰 Tìm kiếm nhân viên theo khoảng Thu nhập');
  print('  7. 🔠 Sắp xếp nhân viên theo Họ và Tên (A-Z)');
  print('  8. 📈 Sắp xếp nhân viên theo Thu nhập tăng dần');
  print('  9. 🏆 Hiển thị Top 5 nhân viên có Thu nhập cao nhất');
  print('  D. 🎲 Nạp dữ liệu mẫu (Mock Data)');
  print('  0. 🚪 Thoát chương trình');
  print('========================================================================');
}

/// Helper to print a clean ASCII table of employees
void handleDisplayEmployees(List<Employee> list, String title) {
  if (list.isEmpty) {
    InputHelper.printColor('⚠️ Danh sách trống! Chưa có nhân viên nào trong hệ thống.', InputHelper.yellow);
    return;
  }

  InputHelper.printColor('\n=== $title ===', InputHelper.magenta, isBold: true);
  
  // Outer frame & headers
  // Widths: ID: 7, Tên: 22, Chức vụ: 12, Lương CB: 13, Phụ trội/Hoa hồng: 26, Thu nhập: 13, Thuế: 11, Thực lĩnh: 13
  const sep = '+---------+------------------------+--------------+---------------+----------------------------+---------------+---------------+---------------+';
  print(sep);
  print('| Mã NV   | Họ và Tên              | Chức vụ      | Lương CB      | Chi tiết phụ trội          | Thu nhập      | Thuế TNCN     | Thực lĩnh     |');
  print(sep);

  for (final e in list) {
    final idCell = e.id.padRight(7).substring(0, 7);
    
    // Handle Vietnamese names correctly (padRight may be slightly misaligned due to multi-byte characters, 
    // but substring will protect boundary. For CLI, standard padding is usually okay).
    final nameCell = e.fullName.padRight(22).substring(0, 22);
    final typeCell = e.employeeType.padRight(12).substring(0, 12);
    
    final baseCell = InputHelper.formatCurrency(e.baseSalary).padLeft(13);
    
    // Details cell based on type
    String details = '';
    if (e is AdministrativeEmployee) {
      details = 'Không có phụ trội';
    } else if (e is SalesEmployee) {
      final revenue = InputHelper.formatCurrency(e.salesRevenue);
      final ratePercent = '${(e.commissionRate * 100).toStringAsFixed(0)}%';
      details = 'DT: $revenue | HH: $ratePercent';
    } else if (e is Manager) {
      final allow = InputHelper.formatCurrency(e.responsibilityAllowance);
      details = 'Phụ cấp: $allow';
    }
    final detailsCell = details.padRight(26).substring(0, 26);
    
    final grossCell = InputHelper.formatCurrency(e.grossIncome).padLeft(13);
    final taxCell = InputHelper.formatCurrency(e.tax).padLeft(11);
    final netCell = InputHelper.formatCurrency(e.netSalary).padLeft(13);

    print('| $idCell | $nameCell | $typeCell | $baseCell | $detailsCell | $grossCell | $taxCell | $netCell |');
  }
  print(sep);
  InputHelper.printColor('Tổng số lượng nhân viên: ${list.length}', InputHelper.cyan);
}

/// Requirement 1: Input employee list
void handleInputEmployees(EmployeeManager manager) {
  InputHelper.printColor('--- [1] NHẬP DANH SÁCH NHÂN VIÊN MỚI ---', InputHelper.blue, isBold: true);
  final count = InputHelper.readInt('Nhập số lượng nhân viên muốn thêm: ', min: 1);

  for (int i = 0; i < count; i++) {
    InputHelper.printColor('\nNhập nhân viên thứ ${i + 1}/$count:', InputHelper.cyan);
    
    // Choose employee type
    print('Chọn loại nhân viên:');
    print('  1. Nhân viên Hành chính');
    print('  2. Nhân viên Tiếp thị (Sales)');
    print('  3. Trưởng phòng (Manager)');
    final typeChoice = InputHelper.readInt('👉 Chọn (1-3): ', min: 1, max: 3);

    // Read ID with unique constraint check
    String id = '';
    while (true) {
      id = InputHelper.readString('Mã nhân viên (ID): ').trim();
      if (manager.exists(id)) {
        InputHelper.printColor('❌ Lỗi: Mã nhân viên "$id" đã tồn tại! Vui lòng nhập mã khác.', InputHelper.red);
      } else {
        break;
      }
    }

    final fullName = InputHelper.readString('Họ và tên: ');
    final baseSalary = InputHelper.readDouble('Lương cơ bản (VND): ', min: 0);

    Employee employee;
    switch (typeChoice) {
      case 1:
        employee = AdministrativeEmployee(id: id, fullName: fullName, baseSalary: baseSalary);
        break;
      case 2:
        final salesRevenue = InputHelper.readDouble('Doanh số bán hàng (VND): ', min: 0);
        final commissionRate = InputHelper.readDouble('Tỷ lệ hoa hồng (Ví dụ: 0.1 cho 10%): ', min: 0.0, max: 1.0);
        employee = SalesEmployee(
          id: id,
          fullName: fullName,
          baseSalary: baseSalary,
          salesRevenue: salesRevenue,
          commissionRate: commissionRate,
        );
        break;
      case 3:
        final allowance = InputHelper.readDouble('Phụ cấp trách nhiệm (VND): ', min: 0);
        employee = Manager(
          id: id,
          fullName: fullName,
          baseSalary: baseSalary,
          responsibilityAllowance: allowance,
        );
        break;
      default:
        return;
    }

    manager.addEmployee(employee);
    InputHelper.printColor('✓ Đã thêm nhân viên ${employee.fullName} (${employee.id}) thành công!', InputHelper.green);
  }
}

/// Requirement 3: Search employee by ID
void handleSearchById(EmployeeManager manager) {
  InputHelper.printColor('--- [3] TÌM KIẾM NHÂN VIÊN THEO MÃ SỐ ---', InputHelper.blue, isBold: true);
  final id = InputHelper.readString('Nhập Mã nhân viên (ID) cần tìm: ');
  final emp = manager.findById(id);

  if (emp == null) {
    InputHelper.printColor('❌ Không tìm thấy nhân viên nào có Mã số: "$id"', InputHelper.red);
    return;
  }

  printIndividualCard(emp);
}

/// Print nice details of single employee
void printIndividualCard(Employee emp) {
  InputHelper.printColor('\n+---------------------------------------------------+', InputHelper.cyan);
  InputHelper.printColor('|          THÔNG TIN CHI TIẾT NHÂN VIÊN             |', InputHelper.cyan, isBold: true);
  InputHelper.printColor('+---------------------------------------------------+', InputHelper.cyan);
  print('| Mã nhân viên:     ${emp.id.padRight(31)} |');
  print('| Họ và Tên:        ${emp.fullName.padRight(31)} |');
  print('| Chức vụ:          ${emp.employeeType.padRight(31)} |');
  print('| Lương cơ bản:     ${InputHelper.formatCurrency(emp.baseSalary).padRight(31)} |');
  
  if (emp is SalesEmployee) {
    print('| Doanh số:         ${InputHelper.formatCurrency(emp.salesRevenue).padRight(31)} |');
    print('| Tỷ lệ hoa hồng:   ${'${(emp.commissionRate * 100).toStringAsFixed(1)}%'.padRight(31)} |');
  } else if (emp is Manager) {
    print('| Phụ cấp chức vụ:  ${InputHelper.formatCurrency(emp.responsibilityAllowance).padRight(31)} |');
  }
  
  InputHelper.printColor('+---------------------------------------------------+', InputHelper.cyan);
  print('| Tổng thu nhập:    ${InputHelper.formatCurrency(emp.grossIncome).padRight(31)} |');
  print('| Thuế TNCN khấu trừ:${InputHelper.formatCurrency(emp.tax).padRight(31)} |');
  InputHelper.printColor('| Thực lĩnh (NET):  ${InputHelper.formatCurrency(emp.netSalary).padRight(31)} |', InputHelper.green, isBold: true);
  InputHelper.printColor('+---------------------------------------------------+', InputHelper.cyan);
}

/// Requirement 4: Delete employee by ID
void handleDeleteById(EmployeeManager manager) {
  InputHelper.printColor('--- [4] XÓA NHÂN VIÊN THEO MÃ SỐ ---', InputHelper.blue, isBold: true);
  final id = InputHelper.readString('Nhập Mã nhân viên (ID) cần xóa: ');
  final emp = manager.findById(id);

  if (emp == null) {
    InputHelper.printColor('❌ Không tìm thấy nhân viên nào có Mã số: "$id" để xóa.', InputHelper.red);
    return;
  }

  printIndividualCard(emp);
  
  final confirm = InputHelper.readConfirm('⚠️ Bạn có chắc chắn muốn xóa nhân viên này khỏi hệ thống?');
  if (confirm) {
    final success = manager.deleteById(id);
    if (success) {
      InputHelper.printColor('✓ Đã xóa nhân viên "$id" ra khỏi cơ sở dữ liệu!', InputHelper.green, isBold: true);
    } else {
      InputHelper.printColor('❌ Lỗi bất ngờ xảy ra, không thể xóa!', InputHelper.red);
    }
  } else {
    InputHelper.printColor('↩ Thao tác xóa đã được hủy.', InputHelper.yellow);
  }
}

/// Requirement 5: Update employee details
void handleUpdateById(EmployeeManager manager) {
  InputHelper.printColor('--- [5] CẬP NHẬT THÔNG TIN NHÂN VIÊN ---', InputHelper.blue, isBold: true);
  final id = InputHelper.readString('Nhập Mã nhân viên (ID) cần cập nhật: ');
  final emp = manager.findById(id);

  if (emp == null) {
    InputHelper.printColor('❌ Không tìm thấy nhân viên nào có Mã số: "$id" để cập nhật.', InputHelper.red);
    return;
  }

  printIndividualCard(emp);
  InputHelper.printColor('Nhập thông tin mới (Ấn ENTER để giữ nguyên giá trị cũ):', InputHelper.cyan);
  
  // 1. Update Name
  final newNameInput = InputHelper.readString('Họ và tên mới [Hiện tại: ${emp.fullName}]: ', allowEmpty: true);
  if (newNameInput.isNotEmpty) {
    emp.fullName = newNameInput;
  }

  // 2. Update Base Salary
  stdout.write('Lương cơ bản mới [Hiện tại: ${InputHelper.formatCurrency(emp.baseSalary)}]: ');
  final baseSalaryStr = stdin.readLineSync()?.trim();
  if (baseSalaryStr != null && baseSalaryStr.isNotEmpty) {
    final val = double.tryParse(baseSalaryStr);
    if (val != null && val >= 0) {
      emp.baseSalary = val;
    } else {
      InputHelper.printColor('⚠️ Giá trị không hợp lệ. Giữ nguyên lương cũ.', InputHelper.yellow);
    }
  }

  // 3. Update Type specific properties
  if (emp is SalesEmployee) {
    // Sales Revenue
    stdout.write('Doanh số bán hàng mới [Hiện tại: ${InputHelper.formatCurrency(emp.salesRevenue)}]: ');
    final revenueStr = stdin.readLineSync()?.trim();
    if (revenueStr != null && revenueStr.isNotEmpty) {
      final val = double.tryParse(revenueStr);
      if (val != null && val >= 0) {
        emp.salesRevenue = val;
      } else {
        InputHelper.printColor('⚠️ Giá trị không hợp lệ. Giữ nguyên doanh số cũ.', InputHelper.yellow);
      }
    }

    // Commission Rate
    stdout.write('Tỷ lệ hoa hồng mới (Ví dụ: 0.12) [Hiện tại: ${emp.commissionRate}]: ');
    final rateStr = stdin.readLineSync()?.trim();
    if (rateStr != null && rateStr.isNotEmpty) {
      final val = double.tryParse(rateStr);
      if (val != null && val >= 0.0 && val <= 1.0) {
        emp.commissionRate = val;
      } else {
        InputHelper.printColor('⚠️ Giá trị không hợp lệ (phải từ 0 đến 1). Giữ nguyên tỷ lệ cũ.', InputHelper.yellow);
      }
    }
  } else if (emp is Manager) {
    // Allowance
    stdout.write('Phụ cấp trách nhiệm mới [Hiện tại: ${InputHelper.formatCurrency(emp.responsibilityAllowance)}]: ');
    final allowanceStr = stdin.readLineSync()?.trim();
    if (allowanceStr != null && allowanceStr.isNotEmpty) {
      final val = double.tryParse(allowanceStr);
      if (val != null && val >= 0) {
        emp.responsibilityAllowance = val;
      } else {
        InputHelper.printColor('⚠️ Giá trị không hợp lệ. Giữ nguyên phụ cấp cũ.', InputHelper.yellow);
      }
    }
  }

  InputHelper.printColor('✓ Đã cập nhật thông tin nhân viên thành công!', InputHelper.green, isBold: true);
  printIndividualCard(emp);
}

/// Requirement 6: Search by income range
void handleSearchByIncomeRange(EmployeeManager manager) {
  InputHelper.printColor('--- [6] TÌM KIẾM NHÂN VIÊN THEO KHOẢNG THU NHẬP ---', InputHelper.blue, isBold: true);
  final min = InputHelper.readDouble('Nhập thu nhập tối thiểu (Min gross income): ', min: 0);
  final max = InputHelper.readDouble('Nhập thu nhập tối đa (Max gross income): ', min: min);

  final filtered = manager.findByIncomeRange(min, max);
  handleDisplayEmployees(
    filtered, 
    'DANH SÁCH NHÂN VIÊN CÓ THU NHẬP TỪ ${InputHelper.formatCurrency(min)} ĐẾN ${InputHelper.formatCurrency(max)}'
  );
}

/// Requirement 7: Sort by full name
void handleSortByName(EmployeeManager manager) {
  InputHelper.printColor('--- [7] SẮP XẾP NHÂN VIÊN THEO HỌ VÀ TÊN ---', InputHelper.blue, isBold: true);
  print('Chọn chiều sắp xếp:');
  print('  1. Tăng dần (A-Z)');
  print('  2. Giảm dần (Z-A)');
  final dir = InputHelper.readInt('👉 Chọn (1-2): ', min: 1, max: 2);
  
  final isAsc = dir == 1;
  manager.sortByFullName(ascending: isAsc);
  
  InputHelper.printColor('✓ Đã sắp xếp danh sách nhân viên theo Họ tên!', InputHelper.green);
  handleDisplayEmployees(
    manager.employees, 
    isAsc ? 'DANH SÁCH NHÂN VIÊN SẮP XẾP THEO TÊN (A -> Z)' : 'DANH SÁCH NHÂN VIÊN SẮP XẾP THEO TÊN (Z -> A)'
  );
}

/// Requirement 8: Sort by total income
void handleSortByIncome(EmployeeManager manager) {
  InputHelper.printColor('--- [8] SẮP XẾP NHÂN VIÊN THEO TỔNG THU NHẬP ---', InputHelper.blue, isBold: true);
  print('Chọn chiều sắp xếp:');
  print('  1. Thu nhập tăng dần');
  print('  2. Thu nhập giảm dần');
  final dir = InputHelper.readInt('👉 Chọn (1-2): ', min: 1, max: 2);

  final isAsc = dir == 1;
  manager.sortByIncome(ascending: isAsc);

  InputHelper.printColor('✓ Đã sắp xếp danh sách nhân viên theo tổng thu nhập!', InputHelper.green);
  handleDisplayEmployees(
    manager.employees,
    isAsc ? 'DANH SÁCH NHÂN VIÊN SẮP XẾP THEO THU NHẬP TĂNG DẦN' : 'DANH SÁCH NHÂN VIÊN SẮP XẾP THEO THU NHẬP GIẢM DẦN'
  );
}

/// Requirement 9: Top 5 Highest income
void handleDisplayTop5(EmployeeManager manager) {
  InputHelper.printColor('--- [9] TOP 5 NHÂN VIÊN CÓ THU NHẬP CAO NHẤT ---', InputHelper.blue, isBold: true);
  final top5 = manager.getTop5HighestIncome();
  handleDisplayEmployees(top5, 'DANH SÁCH TOP 5 NHÂN VIÊN THU NHẬP CAO NHẤT');
}
