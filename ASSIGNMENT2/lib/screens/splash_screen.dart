import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Branded loading screen shown while services initialize.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: AppTheme.backgroundDecoration(isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
                        : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE))
                          .withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.checklist_rounded, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                'TaskFlow Pro',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Quản lý công việc thông minh',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 36),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
