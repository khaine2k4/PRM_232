import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_task.dart';
import '../theme/app_theme.dart';

class ScheduleTab extends StatefulWidget {
  final List<TodoTask> tasks;
  final Function(TodoTask) onEdit;
  final Function(String) onToggle;

  const ScheduleTab({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDays();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    // Find Monday of the current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<TodoTask> _getTasksForDate(DateTime date) {
    return widget.tasks.where((task) {
      if (task.dueDate == null) return false;
      return _isSameDay(task.dueDate!, date);
    }).toList();
  }

  List<TodoTask> _getTasksForHour(DateTime date, int hour) {
    final dayTasks = _getTasksForDate(date);
    return dayTasks.where((t) => t.dueDate!.hour == hour).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 1. Weekly Date Strip
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _weekDays.map((day) {
              final isSelected = _isSameDay(day, _selectedDate);
              final isToday = _isSameDay(day, DateTime.now());
              
              String dayName = '';
              switch (day.weekday) {
                case 1: dayName = 'Mon'; break;
                case 2: dayName = 'Tue'; break;
                case 3: dayName = 'Wed'; break;
                case 4: dayName = 'Thu'; break;
                case 5: dayName = 'Fri'; break;
                case 6: dayName = 'Sat'; break;
                case 7: dayName = 'Sun'; break;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Container(
                  width: 46,
                  height: 68,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : (isToday ? (isDark ? const Color(0xFF1E2B3C) : Colors.grey[100]) : Colors.transparent),
                    borderRadius: BorderRadius.circular(14),
                    border: isToday
                        ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), width: 1.5)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : (isDark ? Colors.white60 : Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : (isDark ? Colors.white : const Color(0xFF0F1E31)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // 2. Timeline List
        Expanded(
          child: ListView.builder(
            itemCount: 10, // 08:00 to 17:00
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final hour = 8 + index;
              final timeStr = '${hour.toString().padLeft(2, '0')}:00';
              final hourTasks = _getTasksForHour(_selectedDate, hour);
              
              // Check if we should draw the current time line indicator
              final showCurrentTimeIndicator = _isSameDay(_selectedDate, DateTime.now()) &&
                  DateTime.now().hour == hour;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Time label
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.topCenter,
                      child: Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    
                    // Timeline axis line
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        const VerticalDivider(
                          width: 16,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        if (showCurrentTimeIndicator)
                          Positioned(
                            top: (DateTime.now().minute / 60.0) * 60.0, // map min to height
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Tasks in this hour slot
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 16.0, bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showCurrentTimeIndicator)
                              // Time line indicator extension
                              Divider(
                                height: 1,
                                thickness: 1.5,
                                color: Colors.redAccent.withValues(alpha: 0.6),
                              ),
                            
                            const SizedBox(height: 8),
                            
                            if (hourTasks.isEmpty)
                              // Empty placeholder
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark ? const Color(0xFF424754).withValues(alpha: 0.1) : Colors.grey[200]!,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...hourTasks.map((task) => _buildScheduleBlock(task, isDark)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleBlock(TodoTask task, bool isDark) {
    Color priorityColor;
    Color blockBgColor;
    Color blockTextColor;

    switch (task.priority) {
      case TaskPriority.low:
        priorityColor = AppTheme.priorityLow;
        blockBgColor = isDark ? const Color(0xFF1E2B3C) : Colors.grey[100]!;
        blockTextColor = isDark ? Colors.white70 : Colors.black87;
        break;
      case TaskPriority.medium:
        priorityColor = AppTheme.priorityMedium;
        blockBgColor = isDark ? const Color(0xFF004395).withValues(alpha: 0.2) : const Color(0xFFD8E2FF).withValues(alpha: 0.4);
        blockTextColor = isDark ? const Color(0xFFADC6FF) : const Color(0xFF002D6F);
        break;
      case TaskPriority.high:
        priorityColor = AppTheme.priorityHigh;
        blockBgColor = isDark ? const Color(0xFF930013).withValues(alpha: 0.2) : const Color(0xFFFFDAD7).withValues(alpha: 0.4);
        blockTextColor = isDark ? const Color(0xFFFFB3AD) : const Color(0xFF690005);
        break;
    }

    final timeFormatted = task.dueDate != null ? DateFormat('hh:mm a').format(task.dueDate!) : '';

    return GestureDetector(
      onTap: () => widget.onEdit(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF182638) : Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          border: Border(
            left: BorderSide(color: priorityColor, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeFormatted,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: priorityColor,
                  ),
                ),
                // Tiny complete indicator
                GestureDetector(
                  onTap: () => widget.onToggle(task.id),
                  child: Icon(
                    task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                    size: 16,
                    color: task.isCompleted ? AppTheme.completed : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: task.isCompleted
                    ? Colors.grey
                    : (isDark ? const Color(0xFFEAF1FF) : const Color(0xFF0F1E31)),
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (task.category.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: blockBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: blockTextColor,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
