import 'employee.dart';

class SalesEmployee extends Employee {
  double salesRevenue;
  double commissionRate;

  SalesEmployee({
    required super.id,
    required super.fullName,
    required super.baseSalary,
    required this.salesRevenue,
    required this.commissionRate,
  });

  @override
  double get grossIncome => baseSalary + (salesRevenue * commissionRate);

  @override
  String get employeeType => 'Tiếp thị';
}
