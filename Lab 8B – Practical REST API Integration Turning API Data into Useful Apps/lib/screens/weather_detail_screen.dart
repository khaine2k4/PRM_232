import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

/// Màn hình chi tiết: gọi service lấy thời tiết của 1 thành phố và hiển thị
/// kèm các gợi ý "hướng quyết định" (mang ô? hợp ra ngoài? mặc gì?).
class WeatherDetailScreen extends StatefulWidget {
  final City city;
  const WeatherDetailScreen({super.key, required this.city});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  final WeatherService _service = WeatherService();
  late Future<Weather> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.fetchWeatherForCity(widget.city);
  }

  void _retry() {
    setState(_load); // tạo lại Future → FutureBuilder chạy lại
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.city.displayName)),
      body: FutureBuilder<Weather>(
        future: _future,
        builder: (context, snapshot) {
          // 1) TRẠNG THÁI LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _CenteredState(
              icon: null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải dữ liệu thời tiết...'),
                ],
              ),
            );
          }

          // 2) TRẠNG THÁI LỖI + nút Thử lại
          if (snapshot.hasError) {
            return _CenteredState(
              icon: Icons.cloud_off_rounded,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // 3) DỮ LIỆU RỖNG / BẤT NGỜ
          if (!snapshot.hasData) {
            return const _CenteredState(
              icon: Icons.inbox_rounded,
              child: Text('Không có dữ liệu để hiển thị.'),
            );
          }

          // 4) HIỂN THỊ DỮ LIỆU
          return RefreshIndicator(
            onRefresh: () async => _retry(),
            child: _WeatherContent(city: widget.city, weather: snapshot.data!),
          );
        },
      ),
    );
  }
}

/// Khối giữa màn hình dùng chung cho loading/error/empty.
class _CenteredState extends StatelessWidget {
  final IconData? icon;
  final Widget child;
  const _CenteredState({required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Nội dung khi đã có dữ liệu thời tiết.
class _WeatherContent extends StatelessWidget {
  final City city;
  final Weather weather;
  const _WeatherContent({required this.city, required this.weather});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final updated = DateFormat('HH:mm, dd/MM/yyyy').format(weather.time);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // --- Thẻ tổng quan ---
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(weather.icon, size: 84, color: scheme.primary),
                const SizedBox(height: 8),
                Text(
                  '${weather.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  weather.description,
                  style: TextStyle(fontSize: 20, color: scheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cảm giác như ${weather.feelsLike.round()}°C',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --- Hàng chỉ số chi tiết ---
        Row(
          children: [
            _MetricTile(
              icon: Icons.water_drop_rounded,
              label: 'Độ ẩm',
              value: '${weather.humidity}%',
            ),
            _MetricTile(
              icon: Icons.air_rounded,
              label: 'Gió',
              value: '${weather.windSpeed.round()} km/h',
            ),
            _MetricTile(
              icon: Icons.umbrella_rounded,
              label: 'Lượng mưa',
              value: '${weather.precipitation} mm',
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- Phần GỢI Ý hướng quyết định (purpose-driven) ---
        Text(
          'Gợi ý cho bạn',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _AdviceCard(
          icon: Icons.umbrella_rounded,
          color: weather.needsUmbrella ? Colors.indigo : Colors.green,
          title: 'Mang ô?',
          message: weather.umbrellaAdvice,
        ),
        _AdviceCard(
          icon: Icons.directions_walk_rounded,
          color: Colors.teal,
          title: 'Hoạt động ngoài trời',
          message: weather.activityAdvice,
        ),
        _AdviceCard(
          icon: Icons.checkroom_rounded,
          color: Colors.deepPurple,
          title: 'Trang phục',
          message: weather.clothingAdvice,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Cập nhật lúc $updated',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  const _AdviceCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
      ),
    );
  }
}
