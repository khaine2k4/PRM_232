import 'package:flutter/material.dart';
import 'exercises/ex1_submit.dart';
import 'exercises/ex2_simple_list.dart';
import 'exercises/ex3_getting_started.dart';
import 'exercises/ex4_group_list.dart';
import 'exercises/ex5_login.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F9),
      body: CustomScrollView(
        slivers: [
          // Header with visual gradient
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Lab 4 Layouts Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], // Deep premium blue gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: 20,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.white, size: 16),
                                      SizedBox(width: 6),
                                      Text(
                                        'DE180636',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Nguyễn Quang Khải',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Flutter Developer | Lab 4 Layout Assignment',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 14,
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
          ),
          
          // List of exercises
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildExerciseCard(
                  context,
                  title: 'Exercise 1: Submit Form',
                  description: 'Input screen with a TextBox (Enter username) and a primary blue SUBMIT button.',
                  icon: Icons.input_rounded,
                  accentColor: const Color(0xFF2196F3),
                  screen: const Ex1SubmitScreen(),
                ),
                const SizedBox(height: 16),
                _buildExerciseCard(
                  context,
                  title: 'Exercise 2: Simple List',
                  description: 'Scrollable list of 10 items in individual light-blue containers with margin.',
                  icon: Icons.list_alt_rounded,
                  accentColor: const Color(0xFF00BCD4),
                  screen: const Ex2SimpleListScreen(),
                ),
                const SizedBox(height: 16),
                _buildExerciseCard(
                  context,
                  title: 'Exercise 3: Getting Started Testing',
                  description: 'Dynamic list of elevated cards showing titles, subtitles, and toggleable favorite heart icons.',
                  icon: Icons.favorite_rounded,
                  accentColor: const Color(0xFFE91E63),
                  screen: const Ex3GettingStartedScreen(),
                ),
                const SizedBox(height: 16),
                _buildExerciseCard(
                  context,
                  title: 'Exercise 4: Group List View Demo',
                  description: 'Grouped scroll layout by Teams. Includes circular letter avatars and navigate icons.',
                  icon: Icons.group_rounded,
                  accentColor: const Color(0xFF4CAF50),
                  screen: Ex4GroupListScreen(),
                ),
                const SizedBox(height: 16),
                _buildExerciseCard(
                  context,
                  title: 'Exercise 5: Welcome Back Form',
                  description: 'Interactive Login screen featuring real-time validations, custom illustration, and password reveal.',
                  icon: Icons.lock_person_rounded,
                  accentColor: const Color(0xFFFF9800),
                  screen: const Ex5LoginScreen(),
                ),
                const SizedBox(height: 30),
                // Footer
                Center(
                  child: Text(
                    'Built with ❤️ using Flutter',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required Widget screen,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Chevron icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[300],
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
