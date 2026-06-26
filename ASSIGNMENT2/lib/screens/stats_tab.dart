import 'package:flutter/material.dart';

import '../models/todo_task.dart';
import '../theme/app_theme.dart';

class StatsTab extends StatelessWidget {
  final List<TodoTask> tasks;

  const StatsTab({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final ratio = total > 0 ? completed / total : 0.0;

    final highTasks = tasks.where((t) => t.priority == TaskPriority.high).toList();
    final highCompleted = highTasks.where((t) => t.isCompleted).length;
    final highRatio = highTasks.isNotEmpty ? highCompleted / highTasks.length : 0.0;

    final medTasks = tasks.where((t) => t.priority == TaskPriority.medium).toList();
    final medCompleted = medTasks.where((t) => t.isCompleted).length;
    final medRatio = medTasks.isNotEmpty ? medCompleted / medTasks.length : 0.0;

    final lowTasks = tasks.where((t) => t.priority == TaskPriority.low).toList();
    final lowCompleted = lowTasks.where((t) => t.isCompleted).length;
    final lowRatio = lowTasks.isNotEmpty ? lowCompleted / lowTasks.length : 0.0;

    final Map<String, List<TodoTask>> catMap = {};
    for (var t in tasks) {
      catMap.putIfAbsent(t.category, () => []).add(t);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        const SizedBox(height: 12),
        // 1. Overall Circle Progress Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF424754).withValues(alpha: 0.2) : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              const Text('Hiệu suất làm việc',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: ratio,
                      strokeWidth: 10,
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.completed),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(ratio * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Hoàn thành',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Tổng số', '$total', isDark),
                  _buildStatItem('Đã xong', '$completed', isDark),
                  _buildStatItem('Đang chờ', '${total - completed}', isDark),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Priority breakdown
        const Text('Hiệu suất theo độ ưu tiên',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF182638) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildProgressRow('🔴 Cao (High)', highCompleted, highTasks.length, highRatio, AppTheme.priorityHigh, isDark),
              const Divider(height: 24),
              _buildProgressRow('🟡 Trung bình (Medium)', medCompleted, medTasks.length, medRatio, AppTheme.priorityMedium, isDark),
              const Divider(height: 24),
              _buildProgressRow('🔵 Thấp (Low)', lowCompleted, lowTasks.length, lowRatio, AppTheme.priorityLow, isDark),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. Category Breakdown
        if (catMap.isNotEmpty) ...[
          const Text('Phân tích theo danh mục',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF182638) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: catMap.entries.map((entry) {
                final catTasks = entry.value;
                final catCompleted = catTasks.where((t) => t.isCompleted).length;
                final catRatio = catCompleted / catTasks.length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildProgressRow(
                    entry.key,
                    catCompleted,
                    catTasks.length,
                    catRatio,
                    Theme.of(context).colorScheme.primary,
                    isDark,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54)),
      ],
    );
  }

  Widget _buildProgressRow(
    String label,
    int completed,
    int total,
    double ratio,
    Color color,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text('$completed/$total',
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
