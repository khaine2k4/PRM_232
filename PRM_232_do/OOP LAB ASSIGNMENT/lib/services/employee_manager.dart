import '../models/employee.dart';
import '../models/administrative_employee.dart';
import '../models/sales_employee.dart';
import '../models/manager.dart';

class EmployeeManager {
  final List<Employee> _employees = [];

  /// Returns an unmodifiable view of the employee list.
  List<Employee> get employees => List.unmodifiable(_employees);

  /// Check if an employee ID already exists (case-insensitive).
  bool exists(String id) {
    return _employees.any((e) => e.id.trim().toLowerCase() == id.trim().toLowerCase());
  }

  /// Add a new employee to the list.
  void addEmployee(Employee employee) {
    _employees.add(employee);
  }

  /// Find an employee by ID (case-insensitive). Returns null if not found.
  Employee? findById(String id) {
    try {
      return _employees.firstWhere(
        (e) => e.id.trim().toLowerCase() == id.trim().toLowerCase()
      );
    } catch (_) {
      return null;
    }
  }

  /// Delete an employee by ID (case-insensitive). Returns true if deleted, false if not found.
  bool deleteById(String id) {
    final originalLength = _employees.length;
    _employees.removeWhere(
      (e) => e.id.trim().toLowerCase() == id.trim().toLowerCase()
    );
    return _employees.length < originalLength;
  }

  /// Search employees whose gross income lies within the range [minIncome, maxIncome].
  List<Employee> findByIncomeRange(double minIncome, double maxIncome) {
    return _employees
        .where((e) => e.grossIncome >= minIncome && e.grossIncome <= maxIncome)
        .toList();
  }

  /// Sort employees in place by their full name (alphabetical, case-insensitive).
  void sortByFullName({bool ascending = true}) {
    _employees.sort((a, b) {
      final comp = a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
      return ascending ? comp : -comp;
    });
  }

  /// Sort employees in place by their total income (grossIncome).
  void sortByIncome({bool ascending = true}) {
    _employees.sort((a, b) {
      final comp = a.grossIncome.compareTo(b.grossIncome);
      return ascending ? comp : -comp;
    });
  }

  /// Get a list of the top 5 employees with the highest total gross income.
  List<Employee> getTop5HighestIncome() {
    final sorted = List<Employee>.from(_employees);
    sorted.sort((a, b) => b.grossIncome.compareTo(a.grossIncome));
    return sorted.take(5).toList();
  }

  /// Populate system with high-quality mock data for testing and demonstration.
  void loadMockData() {
    if (_employees.isNotEmpty) return;
    _employees.addAll([
      AdministrativeEmployee(
        id: 'HC01',
        fullName: 'Nguyễn Văn An',
        baseSalary: 8500000,
      ),
      AdministrativeEmployee(
        id: 'HC02',
        fullName: 'Lê Thị Bình',
        baseSalary: 12000000,
      ),
      SalesEmployee(
        id: 'TT01',
        fullName: 'Trần Văn Cường',
        baseSalary: 6000000,
        salesRevenue: 50000000,
        commissionRate: 0.10,
      ), // Gross = 6M + (50M * 0.1) = 11M
      SalesEmployee(
        id: 'TT02',
        fullName: 'Phạm Thị Dung',
        baseSalary: 7000000,
        salesRevenue: 100000000,
        commissionRate: 0.12,
      ), // Gross = 7M + (100M * 0.12) = 19M
      Manager(
        id: 'TP01',
        fullName: 'Đỗ Hoàng Giang',
        baseSalary: 15000000,
        responsibilityAllowance: 5000000,
      ), // Gross = 15M + 5M = 20M
      Manager(
        id: 'TP02',
        fullName: 'Ngô Quốc Khánh',
        baseSalary: 10000000,
        responsibilityAllowance: 3000000,
      ), // Gross = 10M + 3M = 13M
    ]);
  }
}
