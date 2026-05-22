import 'employee.dart';

class Manager extends Employee {
  double responsibilityAllowance;

  Manager({
    required super.id,
    required super.fullName,
    required super.baseSalary,
    required this.responsibilityAllowance,
  });

  @override
  double get grossIncome => baseSalary + responsibilityAllowance;

  @override
  String get employeeType => 'Trưởng phòng';
}
