import 'package:flutter/material.dart';

import '../models/city.dart';
import '../services/weather_service.dart';
import 'weather_detail_screen.dart';

/// Màn hình chính: người dùng nhập tên thành phố để tìm, chọn 1 thành phố
/// rồi xem chi tiết thời tiết + gợi ý.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _service = WeatherService();
  final TextEditingController _controller = TextEditingController();

  // null = chưa tìm lần nào (hiển thị màn hình chào).
  Future<List<City>>? _future;
  String _lastQuery = '';

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _lastQuery = query;
      _future = _service.searchCities(query);
    });
  }

  @override
  void dispose() {
    _service.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Companion'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Form tìm kiếm ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Nhập tên thành phố (vd: Hanoi, Tokyo)...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // --- Kết quả ---
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    // Chưa tìm lần nào → màn hình chào.
    if (_future == null) {
      return const _MessageState(
        icon: Icons.travel_explore_rounded,
        message: 'Tìm một thành phố để xem thời tiết\nvà gợi ý cho ngày hôm nay.',
      );
    }

    return FutureBuilder<List<City>>(
      future: _future,
      builder: (context, snapshot) {
        // LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ERROR + Retry
        if (snapshot.hasError) {
          return _MessageState(
            icon: Icons.error_outline_rounded,
            message: '${snapshot.error}',
            onRetry: _search,
          );
        }

        final cities = snapshot.data ?? [];

        // EMPTY
        if (cities.isEmpty) {
          return _MessageState(
            icon: Icons.location_off_rounded,
            message: 'Không tìm thấy thành phố "$_lastQuery".\nThử nhập tên khác (không dấu) xem sao.',
          );
        }

        // DATA
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cities.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final city = cities[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_city_rounded),
                title: Text(
                  city.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(city.displayName),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeatherDetailScreen(city: city),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

/// Khối thông báo dùng chung cho trạng thái chào / rỗng / lỗi.
class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;
  const _MessageState({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
