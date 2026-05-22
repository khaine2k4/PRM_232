import '../utils/ansi_helper.dart';

class Student {
  String name;
  int age;
  double gpa;

  // Constructor
  Student({
    required this.name,
    required this.age,
    required this.gpa,
  });

  // Override toString để hiển thị định dạng thông tin đẹp mắt khi in đối tượng
  @override
  String toString() {
    return 'Student[Tên: $name, Tuổi: $age, GPA: $gpa]';
  }
}

void run() {
  AnsiHelper.printHeader('Bài tập 11: Student Class');
  AnsiHelper.printDesc('Định nghĩa lớp Student, khởi tạo 5 học sinh, lưu vào List và in danh sách.');

  // Khởi tạo 5 đối tượng Student
  final s1 = Student(name: 'Nguyễn Văn An', age: 20, gpa: 3.5);
  final s2 = Student(name: 'Lê Thị Bình', age: 21, gpa: 3.9);
  final s3 = Student(name: 'Trần Văn Cường', age: 19, gpa: 2.8);
  final s4 = Student(name: 'Phạm Thị Dung', age: 22, gpa: 3.75);
  final s5 = Student(name: 'Đỗ Hoàng Giang', age: 20, gpa: 3.2);

  // Lưu trữ vào List<Student>
  final List<Student> students = [s1, s2, s3, s4, s5];

  // In danh sách ra màn hình
  AnsiHelper.printColor('\n=== DANH SÁCH HỌC SINH (OOP CLASS IN LIST) ===', AnsiHelper.magenta, isBold: true);
  for (int i = 0; i < students.length; i++) {
    print('  ${i + 1}. ${students[i]}');
  }

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 11!', AnsiHelper.green, isBold: true);
}
