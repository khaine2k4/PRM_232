import '../utils/ansi_helper.dart';

// Lớp cơ sở Person
class Person {
  String name;
  int age;

  Person({
    required this.name,
    required this.age,
  });

  // Phương thức hiển thị thông tin
  void info() {
    print('👤 Người (Person) - Tên: $name | Tuổi: $age');
  }
}

// Lớp Employee kế thừa từ lớp Person
class Employee extends Person {
  String employeeId;
  double salary;

  // Constructor sử dụng super để gọi constructor của lớp cha
  Employee({
    required super.name,
    required super.age,
    required this.employeeId,
    required this.salary,
  });

  // Ghi đè (Override) phương thức info() để thể hiện tính đa hình (Polymorphism)
  @override
  void info() {
    print('💼 Nhân viên (Employee) - Mã NV: $employeeId | Tên: $name | Tuổi: $age | Lương: ${AnsiHelper.formatCurrency(salary)}');
  }
}

void run() {
  AnsiHelper.printHeader('Bài tập 13: Inheritance Practice');
  AnsiHelper.printDesc('Thực hành tính kế thừa (Inheritance) và đa hình (Polymorphism) qua lớp Person và Employee.');

  AnsiHelper.printColor('\n=== KHỞI TẠO ĐỐI TƯỢNG VÀ GỌI PHƯƠNG THỨC INFO() ===', AnsiHelper.magenta, isBold: true);

  // Tạo đối tượng Person
  final Person p1 = Person(name: 'Phạm Thị Lan', age: 45);
  p1.info(); // Gọi phương thức của Person

  // Tạo đối tượng Employee
  final Employee e1 = Employee(name: 'Nguyễn Văn Nam', age: 28, employeeId: 'NV081', salary: 18500000);
  e1.info(); // Gọi phương thức đã ghi đè (override) của Employee

  // Thể hiện tính đa hình bằng cách dùng danh sách Person chứa cả Employee
  AnsiHelper.printColor('\n=== MINH HỌA TÍNH ĐA HÌNH (POLYMORPHISM) ===', AnsiHelper.cyan, isBold: true);
  final List<Person> people = [
    Person(name: 'Trần Văn Hoàng', age: 50),
    Employee(name: 'Lê Thu Hà', age: 32, employeeId: 'NV099', salary: 22000000),
  ];

  for (final p in people) {
    p.info(); // Tự động gọi đúng phương thức của lớp thực tế của đối tượng tại Runtime
  }

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 13!', AnsiHelper.green, isBold: true);
}
