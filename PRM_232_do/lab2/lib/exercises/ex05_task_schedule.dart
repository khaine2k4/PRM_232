import '../utils/ansi_helper.dart';

void run() {
  AnsiHelper.printHeader('Bài tập 5: Task Schedule by Day');
  AnsiHelper.printDesc('Sử dụng cấu trúc switch-case để đưa ra hoạt động dự kiến cho từng thứ trong tuần.');

  // Cho phép người dùng nhập viết tắt các thứ trong tuần
  AnsiHelper.printColor('Nhập thứ viết tắt (Mon, Tue, Wed, Thu, Fri, Sat, Sun) hoặc Enter để lấy mặc định "Wed":', AnsiHelper.cyan);
  
  List<String> validDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String day = 'Wed';

  final input = AnsiHelper.readString('Nhập thứ (Ví dụ: Mon, Tue): ', allowEmpty: true);
  if (input.isNotEmpty) {
    // Chuẩn hóa chữ viết hoa chữ cái đầu
    String normalized = input.trim();
    if (normalized.length >= 3) {
      normalized = normalized.substring(0, 3).toLowerCase();
      normalized = '${normalized[0].toUpperCase()}${normalized.substring(1)}';
    }
    
    if (validDays.contains(normalized)) {
      day = normalized;
    } else {
      AnsiHelper.printColor('⚠️ Ngày không hợp lệ! Sử dụng ngày mặc định: "Wed"', AnsiHelper.yellow);
      day = 'Wed';
    }
  }

  // Sử dụng switch-case để lên lịch
  String activity;
  String fullDayName;

  switch (day) {
    case 'Mon':
      fullDayName = 'Thứ Hai (Monday)';
      activity = '🖥️ Họp đầu tuần cùng team lúc 9h sáng và lập kế hoạch công việc tuần mới.';
      break;
    case 'Tue':
      fullDayName = 'Thứ Ba (Tuesday)';
      activity = '💻 Tập trung code các tính năng cốt lõi cho dự án PRM232.';
      break;
    case 'Wed':
      fullDayName = 'Thứ Tư (Wednesday)';
      activity = '🧪 Review code cùng đồng nghiệp và tiến hành viết Unit Test cho hệ thống.';
      break;
    case 'Thu':
      fullDayName = 'Thứ Năm (Thursday)';
      activity = '📚 Dành 2 tiếng buổi tối tự học nâng cao kiến thức về Stream & Bất đồng bộ trong Dart.';
      break;
    case 'Fri':
      fullDayName = 'Thứ Sáu (Friday)';
      activity = '🚀 Hoàn thiện các công việc còn tồn đọng, viết báo cáo tuần và deploy bản demo.';
      break;
    case 'Sat':
      fullDayName = 'Thứ Bảy (Saturday)';
      activity = '⚽ Nghỉ ngơi giải trí, đi đá bóng cùng bạn bè và dành thời gian cho gia đình.';
      break;
    case 'Sun':
      fullDayName = 'Chủ Nhật (Sunday)';
      activity = '☕ Uống cà phê sáng, lên kế hoạch cá nhân và ngủ sớm để nạp năng lượng.';
      break;
    default:
      fullDayName = 'Không xác định';
      activity = '🤷 Không có hoạt động nào được lên lịch cho ngày này.';
  }

  // In kết quả
  AnsiHelper.printColor('\n=== LỊCH BIỂU HOẠT ĐỘNG ===', AnsiHelper.magenta, isBold: true);
  print('📅 Ngày chọn: $fullDayName ($day)');
  AnsiHelper.printColor('🎯 Hoạt động dự kiến:', AnsiHelper.cyan, isBold: true);
  print('  $activity');

  AnsiHelper.printColor('\n✓ Hoàn thành bài tập 5!', AnsiHelper.green, isBold: true);
}
