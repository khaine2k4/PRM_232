import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/sample_data.dart';
import 'detail_screen.dart';

// Màn hình trang chủ hiển thị danh sách phim và thanh tìm kiếm
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến lưu trữ giá trị nhập vào ô tìm kiếm để lọc phim
  String _searchQuery = "";

  // Danh sách phim sau khi đã được lọc qua thanh tìm kiếm
  List<Movie> get _filteredMovies {
    if (_searchQuery.isEmpty) {
      return sampleMovies;
    }
    // Lọc theo tiêu đề phim (không phân biệt chữ hoa, chữ thường)
    return sampleMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Màu nền xám nhạt pha tím nhẹ nhàng, tinh tế khớp với hình ảnh mẫu
      backgroundColor: const Color(0xFFF9F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Trong suốt appbar để tiệp màu nền
        elevation: 0, // Bỏ bóng đổ của AppBar
        title: const Text(
          "Movies",
          style: TextStyle(
            color: Color(0xFF1C1B1F), // Màu chữ tối đậm hiện đại
            fontSize: 32, // Chữ to giống hình chụp
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Tiêu đề lệch trái
        titleSpacing: 24, // Khoảng cách lề trái cho chữ "Movies"
      ),
      body: Column(
        children: [
          // 🔍 Thanh tìm kiếm (Tìm phim theo tên) - Tính năng nâng cao giúp ứng dụng premium hơn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Tìm kiếm phim...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F1FA), // Màu nền ô nhập liệu tiệp với card
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // 🎬 Danh sách phim cuộn (Scrollable List)
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(
                    child: Text(
                      "Không tìm thấy bộ phim nào phù hợp!",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        // Thẻ Card chứa thông tin phim
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F1FA), // Màu nền card tím xám nhạt giống hình mẫu
                          borderRadius: BorderRadius.circular(18), // Bo tròn góc lớn
                        ),
                        // InkWell để tạo hiệu ứng gợn nước khi chạm (tap)
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () async {
                            // Chuyển hướng sang màn hình Chi tiết phim
                            // Sử dụng Navigator.push + MaterialPageRoute và truyền đối tượng movie
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(movie: movie),
                              ),
                            );
                            // Sau khi quay lại từ màn hình chi tiết, cập nhật lại trạng thái (Favorite,...) nếu có
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0), // Khoảng đệm bên trong thẻ
                            child: Row(
                              children: [
                                // 1. Ảnh Poster phim (Thiết kế dạng chữ nhật ngang bo góc khớp hình)
                                Hero(
                                  tag: 'poster_${movie.id}', // Tag Hero phải trùng khớp với màn hình chi tiết
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Bo tròn ảnh poster
                                    child: movie.posterUrl.startsWith('assets/')
                                        ? Image.asset(
                                            movie.posterUrl,
                                            width: 110,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            movie.posterUrl,
                                            width: 110,
                                            height: 70,
                                            fit: BoxFit.cover, // Cắt ảnh vừa vặn khung hình
                                            errorBuilder: (context, error, stackTrace) {
                                              // Hiển thị ảnh thay thế nếu lỗi mạng
                                              return Container(
                                                width: 110,
                                                height: 70,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.movie, color: Colors.grey),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16), // Khoảng cách giữa ảnh và chữ

                                // 2. Cột thông tin phim (Tiêu đề, Điểm, Thể loại)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Tiêu đề phim
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1C1B1F),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      // Điểm đánh giá và các thể loại phim
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_border_rounded, // Icon ngôi sao viền giống hình "☆"
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              "${movie.rating} • ${movie.genres.join(', ')}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // 3. Biểu tượng chevron chỉ hướng mũi tên ">" ở rìa phải
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
