import 'package:flutter/material.dart';

class Ex2SimpleListScreen extends StatelessWidget {
  const Ex2SimpleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Exercise 2: Simple List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFB3E5FC), // Light blue, very close to mock screenshot
                borderRadius: BorderRadius.circular(4.0), // Rounded corners
              ),
              child: Text(
                'Item ${index + 1}',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
