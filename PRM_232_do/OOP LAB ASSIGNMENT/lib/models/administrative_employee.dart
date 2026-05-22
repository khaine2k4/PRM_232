import 'employee.dart';

class AdministrativeEmployee extends Employee {
  AdministrativeEmployee({
    required super.id,
    required super.fullName,
    required super.baseSalary,
  });

  @override
  double get grossIncome => baseSalary;

  @override
  String get employeeType => 'Hành chính';
}
