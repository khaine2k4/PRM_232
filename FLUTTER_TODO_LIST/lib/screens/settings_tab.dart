import 'package:flutter/material.dart';
import '../main.dart';

class SettingsTab extends StatelessWidget {
  final VoidCallback onClearAll;

  const SettingsTab({super.key, required this.onClearAll});

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa toàn bộ danh sách công việc không? Thao tác này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                onClearAll();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa toàn bộ công việc!'), behavior: SnackBarBehavior.floating),
                );
              },
              child: const Text('Xóa tất cả'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        const SizedBox(height: 12),
        // 1. Mock Profile Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF424754).withValues(alpha: 0.2) : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBUDqsctwB1zox_3lRhFnlVtlA78eYv8uG0apw14l0Liba8h3rN9Q3mH4yCkpqXasqbRUhYN-mx_BKGBvx6lkfh3Uz40Rdss3sYr6RNrAOaMeGg4Les_PPb5P7Hi0rceX3Em28LU_chWJ_oZk5kYFtj3XI7yJDewE6PKq2fBf2G5W_SF-oYKJWRcOv3UoAuW5pJf4N8zkAj9TTFb6Vfn-BHOVQF_zaoJ596OaG9dcSxwd5Q96ntytRx8dHmEzVdrcoUTqcvvTUxics',
                    ),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Khải Nguyễn',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sinh viên công nghệ • TaskFlow',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Settings Items
        const Text(
          'Thiết lập ứng dụng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Theme Toggle
              ListTile(
                leading: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Chế độ giao diện'),
                subtitle: Text(isDark ? 'Giao diện Tối (Dark)' : 'Giao diện Sáng (Light)'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) {
                    MyApp.themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              const Divider(height: 1),
              // Clear all
              ListTile(
                leading: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                title: const Text('Xóa sạch dữ liệu', style: TextStyle(color: Colors.redAccent)),
                subtitle: const Text('Xóa bỏ toàn bộ công việc đã lưu trữ'),
                onTap: () => _showClearConfirmation(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. About
        const Text(
          'Thông tin ứng dụng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'TaskFlow',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('v1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'TaskFlow là một ứng dụng quản lý công việc và nâng cao năng suất cá nhân, hỗ trợ lập lịch trình và thống kê dữ liệu trực quan theo phong cách Material Design 3.',
                style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
