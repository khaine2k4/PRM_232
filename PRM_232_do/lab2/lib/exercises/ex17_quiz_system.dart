import 'dart:async';
import 'dart:io';
import '../utils/ansi_helper.dart';

/// Lớp đại diện cho câu hỏi trắc nghiệm
class Question {
  final String questionText;
  final List<String> options;
  final String correctOption; // "A", "B", "C", "D"
  final String explanation;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOption,
    required this.explanation,
  });

  /// Kiểm tra xem câu trả lời của người dùng có đúng hay không
  bool isCorrect(String answer) {
    return answer.trim().toUpperCase() == correctOption.toUpperCase();
  }
}

/// Danh sách câu hỏi mẫu hấp dẫn về lập trình Dart và OOP
final List<Question> quizQuestions = [
  Question(
    questionText: 'Trong Dart, từ khóa nào được sử dụng để định nghĩa một lớp trừu tượng (abstract class)?',
    options: ['A. interface', 'B. abstract', 'C. virtual', 'D. class abstract'],
    correctOption: 'B',
    explanation: 'Từ khóa "abstract" được viết trước từ khóa "class" để định nghĩa một abstract class.',
  ),
  Question(
    questionText: 'Tính kế thừa (Inheritance) trong Dart sử dụng từ khóa nào sau đây?',
    options: ['A. implements', 'B. extends', 'C. inherits', 'D. with'],
    correctOption: 'B',
    explanation: 'Dart sử dụng từ khóa "extends" để kế thừa một lớp cơ sở, "implements" cho interface và "with" cho mixin.',
  ),
  Question(
    questionText: 'Điểm khác biệt chính giữa "final" và "const" trong Dart là gì?',
    options: [
      'A. const là hằng số biên dịch, final là hằng số thời gian chạy.',
      'B. final là hằng số biên dịch, const là hằng số thời gian chạy.',
      'C. Cả hai giống hệt nhau không có điểm gì khác.',
      'D. const chỉ dùng được cho biến kiểu chuỗi.'
    ],
    correctOption: 'A',
    explanation: 'const bắt buộc biết giá trị tại compile-time, trong khi final có thể nhận giá trị gán 1 lần tại runtime (ví dụ: DateTime.now()).',
  ),
  Question(
    questionText: 'Lớp nào là lớp cha của tất cả các kiểu dữ liệu và đối tượng trong Dart?',
    options: ['A. Var', 'B. Class', 'C. Object', 'D. Dynamic'],
    correctOption: 'C',
    explanation: 'Mọi lớp trong Dart (ngoại trừ Null nếu xét Null Safety sâu) đều kế thừa trực tiếp hoặc gián tiếp từ lớp Object.',
  ),
];

/// Tạo một Stream bất đồng bộ đếm ngược thời gian chuẩn bị (Ready, Set, Go!)
Stream<int> countdownPrepStream(int seconds) async* {
  for (int i = seconds; i > 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

Future<void> run() async {
  AnsiHelper.clearScreen();
  AnsiHelper.printHeader('Bài tập 17: Mini Project – Quiz System');
  AnsiHelper.printDesc('Hệ thống thi trắc nghiệm: Kết hợp OOP, List câu hỏi, switch-case lựa chọn và Stream đếm ngược thời gian.');

  AnsiHelper.printColor('\n🚦 CHUẨN BỊ BẮT ĐẦU PHẦN THI TRẮC NGHIỆM ĐẠI CƯƠNG DART/OOP!', AnsiHelper.magenta, isBold: true);
  print('Hệ thống đang chuẩn bị đề thi...');
  
  // Sử dụng Stream đếm ngược để tạo hiệu ứng đếm ngược thời gian chuẩn bị (Ready Countdown)
  final prepCompleter = Completer<void>();
  final prepStream = countdownPrepStream(3);
  
  late StreamSubscription<int> prepSubscription;
  prepSubscription = prepStream.listen(
    (tick) {
      String word = '';
      switch (tick) {
        case 3:
          word = 'READY (3)...';
          break;
        case 2:
          word = 'SET (2)...';
          break;
        case 1:
          word = 'GO (1) 🔥!!!';
          break;
      }
      AnsiHelper.printColor('⏳ $word', AnsiHelper.yellow, isBold: true);
    },
    onDone: () {
      prepSubscription.cancel();
      prepCompleter.complete();
    }
  );

  await prepCompleter.future;

  AnsiHelper.printColor('\n=== BẮT ĐẦU LÀM BÀI QUIZ ===', AnsiHelper.green, isBold: true);
  print('Bộ đề gồm ${quizQuestions.length} câu hỏi. Mỗi câu trả lời đúng được cộng 2.5 điểm (Thang điểm 10.0).');
  print('------------------------------------------------------------------------');

  int correctAnswersCount = 0;

  for (int i = 0; i < quizQuestions.length; i++) {
    final q = quizQuestions[i];
    AnsiHelper.printColor('\nCâu hỏi ${i + 1}/${quizQuestions.length}:', AnsiHelper.cyan, isBold: true);
    print(q.questionText);
    
    // Hiển thị các lựa chọn
    for (final option in q.options) {
      print('  $option');
    }

    // Yêu cầu người dùng trả lời
    String answer = '';
    while (true) {
      answer = AnsiHelper.readString('\n👉 Đáp án của bạn chọn (A, B, C, D): ').toUpperCase();
      if (answer == 'A' || answer == 'B' || answer == 'C' || answer == 'D') {
        break;
      }
      AnsiHelper.printColor('⚠️ Câu trả lời không hợp lệ! Vui lòng chỉ chọn A, B, C hoặc D.', AnsiHelper.yellow);
    }

    // Kiểm tra kết quả sử dụng switch-case để tạo thông điệp khích lệ
    bool isCorrect = q.isCorrect(answer);
    if (isCorrect) {
      correctAnswersCount++;
      switch (answer) {
        case 'A':
        case 'B':
        case 'C':
        case 'D':
          AnsiHelper.printColor('✅ ĐÚNG RỒI! Đáp án chính xác là $answer.', AnsiHelper.green, isBold: true);
          break;
      }
    } else {
      AnsiHelper.printColor('❌ SAI MẤT RỒI! Bạn chọn $answer, đáp án đúng là ${q.correctOption}.', AnsiHelper.red, isBold: true);
    }

    // In lời giải thích chi tiết
    print('💡 Giải thích: ${q.explanation}');
    print('------------------------------------------------------------------------');
  }

  // Tính toán kết quả tổng kết
  double totalScore = (correctAnswersCount / quizQuestions.length) * 10;
  
  AnsiHelper.printColor('\n🏆 TỔNG KẾT KẾT QUẢ THI QUIZ', AnsiHelper.magenta, isBold: true);
  print('• Số câu trả lời đúng: $correctAnswersCount / ${quizQuestions.length} câu');
  
  stdout.write('• Điểm số cuối cùng  : ');
  if (totalScore >= 8.0) {
    AnsiHelper.printColor('${totalScore.toStringAsFixed(1)} / 10.0 (Xuất sắc! 🌟)', AnsiHelper.green, isBold: true);
  } else if (totalScore >= 6.5) {
    AnsiHelper.printColor('${totalScore.toStringAsFixed(1)} / 10.0 (Khá! 👍)', AnsiHelper.blue, isBold: true);
  } else if (totalScore >= 5.0) {
    AnsiHelper.printColor('${totalScore.toStringAsFixed(1)} / 10.0 (Đạt! 📖)', AnsiHelper.yellow, isBold: true);
  } else {
    AnsiHelper.printColor('${totalScore.toStringAsFixed(1)} / 10.0 (Chưa đạt! 😢)', AnsiHelper.red, isBold: true);
  }

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 17!', AnsiHelper.green, isBold: true);
}
