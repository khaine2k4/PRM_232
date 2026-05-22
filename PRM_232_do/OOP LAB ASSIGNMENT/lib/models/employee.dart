abstract class Employee {
  final String id;
  String fullName;
  double baseSalary;

  Employee({
    required this.id,
    required this.fullName,
    required this.baseSalary,
  });

  /// Abstract getter to calculate gross income based on employee type rules.
  double get grossIncome;

  /// Personal income tax is calculated based on total gross income:
  /// - Below 9,000,000: 0%
  /// - From 9,000,000 to 15,000,000: 10%
  /// - Above 15,000,000: 12%
  double get tax {
    final income = grossIncome;
    if (income < 9000000) {
      return 0.0;
    } else if (income <= 15000000) {
      return income * 0.10;
    } else {
      return income * 0.12;
    }
  }

  /// Net salary (Income after tax)
  double get netSalary => grossIncome - tax;

  /// String representation of employee type (e.g., Administrative, Sales, Manager)
  String get employeeType;
}
