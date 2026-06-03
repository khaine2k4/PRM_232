import 'package:flutter/material.dart';

class Lab1Counter extends StatefulWidget {
  const Lab1Counter({super.key});

  @override
  State<Lab1Counter> createState() => _Lab1CounterState();
}

class _Lab1CounterState extends State<Lab1Counter> {
  int _count = 0;

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);
  void _reset() => setState(() => _count = 0);

  bool get _isHot => _count > 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Lab 1 – Enhanced Counter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Display card ──
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _isHot
                      ? const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: (_isHot
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF6366F1))
                          .withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isHot ? 72 : 80,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text('$_count'),
                      ),
                      if (_isHot)
                        const Text(
                          '🔥 Nóng!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Warning text
              AnimatedOpacity(
                opacity: _isHot ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    '⚠️  Giá trị lớn hơn 10!',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // ── Buttons row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrement
                  _CounterButton(
                    icon: Icons.remove_rounded,
                    label: '-1',
                    color: const Color(0xFFEF4444),
                    onPressed: _decrement,
                  ),
                  const SizedBox(width: 16),

                  // Reset
                  _CounterButton(
                    icon: Icons.refresh_rounded,
                    label: 'Reset',
                    color: const Color(0xFF64748B),
                    onPressed: _reset,
                    isSmall: true,
                  ),
                  const SizedBox(width: 16),

                  // Increment
                  _CounterButton(
                    icon: Icons.add_rounded,
                    label: '+1',
                    color: const Color(0xFF22C55E),
                    onPressed: _increment,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Quick info
              Text(
                _count == 0
                    ? 'Nhấn + để bắt đầu đếm'
                    : _isHot
                        ? 'Số đã vượt qua 10!'
                        : 'Còn ${11 - _count} bước nữa đến 🔥',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isSmall;

  const _CounterButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isSmall ? 64.0 : 80.0;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isSmall ? 22 : 28),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: isSmall ? 10 : 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
