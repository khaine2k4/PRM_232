import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';

class SettingsTab extends StatefulWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onClearAll;
  final VoidCallback onLogout;

  const SettingsTab({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onClearAll,
    required this.onLogout,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _syncing = false;
  DateTime? _lastSync;

  @override
  void initState() {
    super.initState();
    _loadLastSync();
  }

  Future<void> _loadLastSync() async {
    final ts = await SessionService.instance.lastSyncAt();
    if (mounted) setState(() => _lastSync = ts);
  }

  Future<void> _syncNow() async {
    setState(() => _syncing = true);
    final result = await SyncService.instance.syncNow();
    await _loadLastSync();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.success
            ? '${result.message} (đẩy ${result.pushed}, xóa ${result.deleted})'
            : result.message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Xác nhận xóa'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa toàn bộ danh sách công việc không? Thao tác này không thể hoàn tác.'),
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
                widget.onClearAll();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa toàn bộ công việc!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Xóa tất cả'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Đăng xuất'),
          content: const Text(
              'Bạn sẽ cần đăng nhập lại ở lần mở ứng dụng tiếp theo. Dữ liệu công việc vẫn được lưu trữ.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onLogout();
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  String get _initials {
    final name = widget.userName.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        const SizedBox(height: 12),
        // 1. Account Card (real signed-in user)
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
                        : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.userEmail,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Data & Sync
        const Text('Dữ liệu & Đồng bộ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.cloud_sync_rounded, color: Theme.of(context).colorScheme.primary),
                title: const Text('Đồng bộ lên SQL Server'),
                subtitle: Text(
                  _lastSync != null
                      ? 'Lần cuối: ${DateFormat('dd/MM/yyyy HH:mm').format(_lastSync!)}'
                      : 'Chưa đồng bộ lần nào',
                ),
                trailing: _syncing
                    ? const SizedBox(
                        width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                    : TextButton(
                        onPressed: _syncNow,
                        child: const Text('Đồng bộ', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. App settings
        const Text('Thiết lập ứng dụng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Chế độ giao diện'),
                subtitle: Text(isDark ? 'Giao diện Tối (Dark)' : 'Giao diện Sáng (Light)'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) => MyApp.setDarkMode(val),
                ),
              ),
              const Divider(height: 1),
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

        // 4. Logout
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),
            title: Text(
              'Đăng xuất',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () => _showLogoutConfirmation(context),
          ),
        ),
        const SizedBox(height: 20),

        // 5. About
        const Text('Thông tin ứng dụng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    'TaskFlow Pro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('v2.0.0', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Ứng dụng quản lý công việc có đăng nhập & lưu trữ bền vững. '
                'Dữ liệu được lưu cục bộ bằng SQLite và đồng bộ lên SQL Server.',
                style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
