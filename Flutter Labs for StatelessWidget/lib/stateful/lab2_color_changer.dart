import 'dart:math';
import 'package:flutter/material.dart';

class Lab2ColorChanger extends StatefulWidget {
  const Lab2ColorChanger({super.key});

  @override
  State<Lab2ColorChanger> createState() => _Lab2ColorChangerState();
}

class _Lab2ColorChangerState extends State<Lab2ColorChanger> {
  Color _bgColor = const Color(0xFF1E293B);
  String _colorName = 'Default (Dark)';
  final Random _random = Random();

  void _changeColor(Color color, String name) {
    setState(() {
      _bgColor = color;
      _colorName = name;
    });
  }

  void _randomColor() {
    final r = _random.nextInt(256);
    final g = _random.nextInt(256);
    final b = _random.nextInt(256);
    final color = Color.fromRGBO(r, g, b, 1.0);
    final hex =
        '#${r.toRadixString(16).padLeft(2, '0').toUpperCase()}${g.toRadixString(16).padLeft(2, '0').toUpperCase()}${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
    setState(() {
      _bgColor = color;
      _colorName = 'Random $hex';
    });
  }

  // Returns black or white depending on background luminance
  Color get _textColor {
    final luminance = _bgColor.computeLuminance();
    return luminance > 0.4 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: _bgColor,
        child: SafeArea(
          child: Column(
            children: [
              // ── AppBar area ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _textColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back, color: _textColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      child: const Text('Lab 2 – Color Changer'),
                    ),
                  ],
                ),
              ),

              // ── Main content ──
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Color display circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: _bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _textColor.withValues(alpha: 0.3),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.palette_rounded,
                          color: _textColor.withValues(alpha: 0.5),
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Color name
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        child: Text(_colorName),
                      ),
                      const SizedBox(height: 8),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: _textColor.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        child: const Text('Nhấn nút để thay đổi màu sắc'),
                      ),
                      const SizedBox(height: 50),

                      // ── 3 Color buttons ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ColorButton(
                            color: const Color(0xFFEF4444),
                            label: 'Đỏ',
                            icon: Icons.circle,
                            onTap: () => _changeColor(
                                const Color(0xFFDC2626), 'Đỏ (Red)'),
                          ),
                          const SizedBox(width: 16),
                          _ColorButton(
                            color: const Color(0xFF22C55E),
                            label: 'Xanh Lá',
                            icon: Icons.circle,
                            onTap: () => _changeColor(
                                const Color(0xFF16A34A), 'Xanh Lá (Green)'),
                          ),
                          const SizedBox(width: 16),
                          _ColorButton(
                            color: const Color(0xFF3B82F6),
                            label: 'Xanh Dương',
                            icon: Icons.circle,
                            onTap: () => _changeColor(
                                const Color(0xFF2563EB), 'Xanh Dương (Blue)'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Random button ──
                      GestureDetector(
                        onTap: _randomColor,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 16),
                          decoration: BoxDecoration(
                            color: _textColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: _textColor.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shuffle_rounded,
                                  color: _textColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Màu Ngẫu Nhiên',
                                style: TextStyle(
                                  color: _textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
