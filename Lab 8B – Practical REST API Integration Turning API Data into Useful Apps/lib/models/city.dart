/// Một thành phố trả về từ Open-Meteo Geocoding API.
/// Dùng để lấy toạ độ (lat/lon) phục vụ gọi API thời tiết.
class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1; // tỉnh / bang

  const City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  /// Chuỗi hiển thị đầy đủ, ví dụ: "Hà Nội, Vietnam".
  String get displayName {
    final parts = <String>[
      name,
      if (admin1 != null && admin1!.isNotEmpty && admin1 != name) admin1!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
    );
  }
}
