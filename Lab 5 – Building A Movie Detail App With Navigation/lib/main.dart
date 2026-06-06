import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Điểm xuất phát của ứng dụng Flutter
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tên ứng dụng
      title: 'Movie Detail App',
      
      // 🛠️ Tắt biểu trưng "DEBUG" ở góc trên bên phải để ứng dụng trông sạch sẽ, chuyên nghiệp
      debugShowCheckedModeBanner: false,
      
      // 🎨 Cấu hình Theme (Giao diện) cho toàn bộ ứng dụng
      theme: ThemeData(
        // Thiết lập tông màu hạt nhân (seed color) là màu tím đậm,
        // giúp sinh ra bảng màu hài hòa tự động cho các Widget Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          surface: const Color(0xFFF9F7FC), // Màu nền mặc định cho các màn hình
        ),
        useMaterial3: true, // Bật Material Design 3 mới nhất
        
        // Cấu hình phông chữ mặc định
        fontFamily: 'Roboto',
      ),
      
      // Màn hình khởi đầu của ứng dụng là HomeScreen (Trang danh sách phim)
      home: const HomeScreen(),
    );
  }
}
