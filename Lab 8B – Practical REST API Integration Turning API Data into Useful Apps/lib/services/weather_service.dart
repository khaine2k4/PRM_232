import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/city.dart';
import '../models/weather.dart';

/// Ngoại lệ tuỳ biến để UI hiển thị thông báo lỗi thân thiện.
class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}

/// Service Layer: tập trung toàn bộ lệnh gọi REST API tới Open-Meteo.
/// Màn hình/Widget chỉ gọi các hàm ở đây, KHÔNG gọi http trực tiếp.
///
/// API dùng (miễn phí, không cần API key):
///  - Geocoding: https://geocoding-api.open-meteo.com/v1/search
///  - Forecast : https://api.open-meteo.com/v1/forecast
class WeatherService {
  static const String _geoBase = 'https://geocoding-api.open-meteo.com/v1';
  static const String _forecastBase = 'https://api.open-meteo.com/v1';

  final http.Client _client;
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Tìm danh sách thành phố theo tên (GET request → parse JSON → List<City>).
  Future<List<City>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(
      '$_geoBase/search?name=${Uri.encodeQueryComponent(trimmed)}'
      '&count=8&language=vi&format=json',
    );

    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) {
        throw WeatherException('Lỗi máy chủ tìm kiếm (mã ${res.statusCode}).');
      }

      final body = json.decode(res.body) as Map<String, dynamic>;
      final results = body['results'] as List<dynamic>?; // có thể null nếu không tìm thấy
      if (results == null || results.isEmpty) return [];

      return results
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList();
    } on WeatherException {
      rethrow;
    } on FormatException {
      throw WeatherException('Dữ liệu trả về không hợp lệ.');
    } catch (_) {
      throw WeatherException(
        'Không thể kết nối mạng. Vui lòng kiểm tra Internet và thử lại.',
      );
    }
  }

  /// Lấy thời tiết hiện tại cho một thành phố (GET request → parse JSON → Weather).
  Future<Weather> fetchWeatherForCity(City city) async {
    final uri = Uri.parse(
      '$_forecastBase/forecast?latitude=${city.latitude}'
      '&longitude=${city.longitude}'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,'
      'is_day,precipitation,weather_code,wind_speed_10m'
      '&timezone=auto',
    );

    try {
      final res = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) {
        throw WeatherException('Lỗi máy chủ thời tiết (mã ${res.statusCode}).');
      }

      final body = json.decode(res.body) as Map<String, dynamic>;
      if (body['current'] == null) {
        throw WeatherException('Không có dữ liệu thời tiết cho địa điểm này.');
      }

      return Weather.fromJson(body);
    } on WeatherException {
      rethrow;
    } on FormatException {
      throw WeatherException('Dữ liệu thời tiết không hợp lệ.');
    } catch (_) {
      throw WeatherException(
        'Không thể kết nối mạng. Vui lòng kiểm tra Internet và thử lại.',
      );
    }
  }

  void dispose() => _client.close();
}
