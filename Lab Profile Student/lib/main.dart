import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Profile"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                  AssetImage("assets/images/khai.jpg"),
                ),

                SizedBox(height: 20),

                // Name
                Text(
                  "Nguyễn Quang Khải",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                // Student ID
                Text(
                  "Student ID: DE180636",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 10),

                // Role
                Text(
                  "Flutter Developer",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 10),

                // Skill
                Text(
                  "Skill: Có khả năng giao tiếp với AI",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}