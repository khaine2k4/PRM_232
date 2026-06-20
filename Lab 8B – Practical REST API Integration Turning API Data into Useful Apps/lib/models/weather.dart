import 'package:flutter/material.dart';

/// Dữ liệu thời tiết hiện tại cho một thành phố, parse từ Open-Meteo Forecast API.
class Weather {
  final double temperature; // °C
  final double feelsLike; // apparent temperature, °C
  final int humidity; // %
  final double windSpeed; // km/h
  final double precipitation; // mm
  final int weatherCode; // WMO weather code
  final bool isDay;
  final DateTime time;

  const Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Open-Meteo trả dữ liệu trong khoá "current".
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      precipitation: (current['precipitation'] as num?)?.toDouble() ?? 0,
      weatherCode: (current['weather_code'] as num).toInt(),
      isDay: (current['is_day'] as num).toInt() == 1,
      time: DateTime.parse(current['time'] as String),
    );
  }

  /// Mô tả tiếng Việt theo bảng mã thời tiết WMO.
  String get description {
    switch (weatherCode) {
      case 0:
        return 'Trời quang';
      case 1:
        return 'Ít mây';
      case 2:
        return 'Có mây';
      case 3:
        return 'Nhiều mây';
      case 45:
      case 48:
        return 'Sương mù';
      case 51:
      case 53:
      case 55:
        return 'Mưa phùn';
      case 56:
      case 57:
        return 'Mưa phùn lạnh';
      case 61:
        return 'Mưa nhỏ';
      case 63:
        return 'Mưa vừa';
      case 65:
        return 'Mưa to';
      case 66:
      case 67:
        return 'Mưa lạnh';
      case 71:
      case 73:
      case 75:
        return 'Tuyết rơi';
      case 77:
        return 'Hạt tuyết';
      case 80:
      case 81:
      case 82:
        return 'Mưa rào';
      case 85:
      case 86:
        return 'Mưa tuyết rào';
      case 95:
        return 'Giông bão';
      case 96:
      case 99:
        return 'Giông kèm mưa đá';
      default:
        return 'Không xác định';
    }
  }

  /// Icon Material tương ứng với điều kiện thời tiết.
  IconData get icon {
    if (weatherCode == 0) {
      return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }
    if (weatherCode == 1 || weatherCode == 2) {
      return isDay ? Icons.wb_cloudy_rounded : Icons.nights_stay_rounded;
    }
    if (weatherCode == 3) return Icons.cloud_rounded;
    if (weatherCode == 45 || weatherCode == 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 67) return Icons.grain_rounded;
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit_rounded;
    if (weatherCode >= 80 && weatherCode <= 82) return Icons.umbrella_rounded;
    if (weatherCode >= 85 && weatherCode <= 86) return Icons.ac_unit_rounded;
    if (weatherCode >= 95) return Icons.thunderstorm_rounded;
    return Icons.help_outline_rounded;
  }

  // ---- Các thuộc tính "hướng quyết định" (purpose-driven) ----

  /// Trời có mưa không (theo mã thời tiết)?
  bool get isRainy =>
      (weatherCode >= 51 && weatherCode <= 67) ||
      (weatherCode >= 80 && weatherCode <= 99);

  /// Có nên mang ô không?
  bool get needsUmbrella => isRainy || precipitation > 0;

  /// Lời khuyên về việc mang ô.
  String get umbrellaAdvice =>
      needsUmbrella ? 'Nhớ mang ô đi nhé! ☔' : 'Không cần mang ô. 👍';

  /// Lời khuyên hoạt động ngoài trời dựa trên nhiệt độ & thời tiết.
  String get activityAdvice {
    if (isRainy) return 'Trời mưa — nên ở trong nhà hoặc mang áo mưa.';
    if (temperature >= 35) return 'Quá nóng cho hoạt động ngoài trời, hãy giữ mát.';
    if (temperature >= 28) return 'Hơi nóng — vận động nhẹ và uống đủ nước.';
    if (temperature >= 18) return 'Thời tiết đẹp, rất hợp đi dạo hoặc tập thể thao! 🚶';
    if (temperature >= 10) return 'Hơi lạnh — mặc ấm khi ra ngoài.';
    return 'Rất lạnh — hạn chế ra ngoài, mặc thật ấm. 🧥';
  }

  /// Gợi ý trang phục ngắn gọn.
  String get clothingAdvice {
    if (temperature >= 30) return 'Mặc đồ thoáng mát';
    if (temperature >= 20) return 'Áo mỏng là đủ';
    if (temperature >= 12) return 'Nên mặc thêm áo khoác';
    return 'Mặc nhiều lớp & giữ ấm';
  }
}
