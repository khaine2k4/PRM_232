import 'package:flutter/material.dart';
import 'stateless/lab1_profile_card.dart';
import 'stateless/lab2_business_card.dart';
import 'stateless/lab3_product_display.dart';
import 'stateful/lab1_counter.dart';
import 'stateful/lab2_color_changer.dart';
import 'stateful/lab3_student_form.dart';
import 'stateful/lab4_coffee_shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs – PRM232',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model for each lab card
// ─────────────────────────────────────────────────────────────────────────────
class LabItem {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;
  final Widget page;

  const LabItem({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    required this.page,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Page
// ─────────────────────────────────────────────────────────────────────────────
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statelessLabs = [
      LabItem(
        title: 'Personal Profile Card',
        subtitle: 'Hiển thị thẻ hồ sơ cá nhân',
        emoji: '🪪',
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        page: const Lab1ProfileCard(),
      ),
      LabItem(
        title: 'Business Card App',
        subtitle: 'Danh thiếp công ty chuyên nghiệp',
        emoji: '💼',
        gradient: const [Color(0xFF1E3A5F), Color(0xFF2563EB)],
        page: const Lab2BusinessCard(),
      ),
      LabItem(
        title: 'Product Display Screen',
        subtitle: 'Màn hình hiển thị sản phẩm',
        emoji: '🛍️',
        gradient: const [Color(0xFF92400E), Color(0xFFD97706)],
        page: const Lab3ProductDisplay(),
      ),
    ];

    final statefulLabs = [
      LabItem(
        title: 'Enhanced Counter App',
        subtitle: 'Bộ đếm +/- với setState()',
        emoji: '🔢',
        gradient: const [Color(0xFF065F46), Color(0xFF059669)],
        page: const Lab1Counter(),
      ),
      LabItem(
        title: 'Background Color Changer',
        subtitle: 'Đổi màu nền theo nút bấm',
        emoji: '🎨',
        gradient: const [Color(0xFF7C3AED), Color(0xFFEC4899)],
        page: const Lab2ColorChanger(),
      ),
      LabItem(
        title: 'Student Information Form',
        subtitle: 'Form nhập và hiển thị SV',
        emoji: '🎓',
        gradient: const [Color(0xFF0F4C75), Color(0xFF1B6CA8)],
        page: const Lab3StudentForm(),
      ),
      LabItem(
        title: 'Coffee Shop Ordering',
        subtitle: 'Đặt đồ uống + tính tiền real-time',
        emoji: '☕',
        gradient: const [Color(0xFF3D1A00), Color(0xFFD97706)],
        page: const Lab4CoffeeShop(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF0F172A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            '📚 PRM232 – Flutter Labs',
                            style: TextStyle(
                              color: Color(0xFF818CF8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Flutter\nLaboratory',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '7 bài lab • StatelessWidget & StatefulWidget',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Stateless Section ──
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'StatelessWidget Labs',
              count: statelessLabs.length,
              color: const Color(0xFF6366F1),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _LabCard(
                  item: statelessLabs[i],
                  labNumber: i + 1,
                  section: 'Stateless',
                ),
                childCount: statelessLabs.length,
              ),
            ),
          ),

          // ── Stateful Section ──
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'StatefulWidget Labs',
              count: statefulLabs.length,
              color: const Color(0xFF22C55E),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _LabCard(
                  item: statefulLabs[i],
                  labNumber: i + 1,
                  section: 'Stateful',
                ),
                childCount: statefulLabs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count labs',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Lab Card
// ─────────────────────────────────────────────────────────────────────────────
class _LabCard extends StatelessWidget {
  final LabItem item;
  final int labNumber;
  final String section;

  const _LabCard({
    required this.item,
    required this.labNumber,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.page),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF334155),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Gradient number badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: item.gradient),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: item.gradient.last.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lab $labNumber',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF64748B),
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
