import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';

/// Màn hình chính: hiển thị danh sách bài viết lấy từ REST API.
/// Minh hoạ FutureBuilder + ListView.builder + loading/error states.
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;

  // Bài viết do người dùng tự tạo (POST). Vì JSONPlaceholder là API GIẢ,
  // server không thực sự lưu, nên ta giữ chúng ở client để hiển thị ngay đầu danh sách.
  final List<Post> _createdPosts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _postsFuture = _apiService.fetchPosts();
  }

  // Tạo lại Future → FutureBuilder chạy lại (dùng cho nút Thử lại & pull-to-refresh).
  Future<void> _refresh() async {
    setState(_load);
    await _postsFuture;
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _openCreateForm() async {
    final created = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
    if (created != null && mounted) {
      setState(() => _createdPosts.insert(0, created)); // chèn lên đầu danh sách
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tạo bài viết #${created.id}: ${created.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts (REST API)'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateForm,
        icon: const Icon(Icons.add),
        label: const Text('Tạo mới'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // 1) LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) ERROR + nút Thử lại
          if (snapshot.hasError) {
            return _ErrorState(
              message: 'Đã có lỗi xảy ra.\n${snapshot.error}',
              onRetry: _refresh,
            );
          }

          // Ghép bài tự tạo (lên đầu) + bài lấy từ API.
          final posts = [..._createdPosts, ...(snapshot.data ?? [])];

          // 3) EMPTY
          if (posts.isEmpty) {
            return const Center(child: Text('Không có bài viết nào.'));
          }

          // 4) DATA — ListView.builder + pull-to-refresh
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${post.id}')),
                    title: Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Trạng thái lỗi với thông báo thân thiện + nút Thử lại.
class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
