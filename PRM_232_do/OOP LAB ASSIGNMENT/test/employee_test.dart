import 'package:test/test.dart';
import '../lib/models/administrative_employee.dart';
import '../lib/models/sales_employee.dart';
import '../lib/models/manager.dart';
import '../lib/services/employee_manager.dart';

void main() {
  group('Employee calculations', () {
    test('AdministrativeEmployee income and tax calculation', () {
      final emp = AdministrativeEmployee(id: 'HC01', fullName: 'Nguyễn Văn An', baseSalary: 8500000);
      expect(emp.grossIncome, 8500000);
      expect(emp.tax, 0); // Below 9M is 0% tax
      expect(emp.netSalary, 8500000);
    });

    test('SalesEmployee income and tax calculation', () {
      // Base: 6M, Sales: 50M, rate: 0.10 => gross = 6M + 5M = 11M
      final emp = SalesEmployee(
        id: 'TT01',
        fullName: 'Trần Văn Cường',
        baseSalary: 6000000,
        salesRevenue: 50000000,
        commissionRate: 0.10,
      );
      expect(emp.grossIncome, 11000000);
      // Between 9M and 15M => 10% tax rate
      expect(emp.tax, 11000000 * 0.10);
      expect(emp.netSalary, 11000000 * 0.90);
    });

    test('Manager income and tax calculation', () {
      // Base: 15M, Allowance: 5M => gross = 20M
      final emp = Manager(
        id: 'TP01',
        fullName: 'Đỗ Hoàng Giang',
        baseSalary: 15000000,
        responsibilityAllowance: 5000000,
      );
      expect(emp.grossIncome, 20000000);
      // Above 15M => 12% tax rate
      expect(emp.tax, 20000000 * 0.12);
      expect(emp.netSalary, 20000000 * 0.88);
    });
  });

  group('EmployeeManager logic', () {
    late EmployeeManager manager;

    setUp(() {
      manager = EmployeeManager();
      manager.loadMockData();
    });

    test('Exists and findById work correctly', () {
      expect(manager.exists('hc01'), isTrue);
      expect(manager.exists('hc01   '), isTrue);
      expect(manager.exists('INVALID'), isFalse);
      
      final emp = manager.findById('tt01');
      expect(emp, isNotNull);
      expect(emp!.fullName, 'Trần Văn Cường');
    });

    test('Delete by ID works correctly', () {
      expect(manager.deleteById('hc01'), isTrue);
      expect(manager.exists('hc01'), isFalse);
      expect(manager.deleteById('hc01'), isFalse); // already deleted
    });

    test('Search by income range works', () {
      // Income levels:
      // HC01: 8.5M
      // HC02: 12M
      // TT01: 11M
      // TT02: 19M
      // TP01: 20M
      // TP02: 13M
      final list = manager.findByIncomeRange(10000000, 15000000); // 10M to 15M
      expect(list.length, 3); // HC02 (12M), TT01 (11M), TP02 (13M)
    });

    test('Sort by name works', () {
      manager.sortByFullName(ascending: true);
      expect(manager.employees.first.fullName, 'Lê Thị Bình');
      expect(manager.employees.last.fullName, 'Trần Văn Cường');
    });

    test('Sort by income works', () {
      manager.sortByIncome(ascending: true);
      expect(manager.employees.first.grossIncome, 8500000);
      expect(manager.employees.last.grossIncome, 20000000);
    });

    test('Get top 5 highest income works', () {
      final top5 = manager.getTop5HighestIncome();
      expect(top5.length, 5);
      expect(top5[0].id, 'TP01'); // 20M
      expect(top5[1].id, 'TT02'); // 19M
      expect(top5[2].id, 'TP02'); // 13M
      expect(top5[3].id, 'HC02'); // 12M
      expect(top5[4].id, 'TT01'); // 11M
    });
  });
}
