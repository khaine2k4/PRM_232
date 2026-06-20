import 'package:flutter/material.dart';

import '../models/post.dart';

/// Màn hình chi tiết (bonus): hiển thị đầy đủ một bài viết khi nhấn vào item.
class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bài viết #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            post.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('User ID: ${post.userId}',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const Divider(height: 32),
          Text(post.body, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
