import 'package:flutter/material.dart';
import '../models/movie.dart';

// Màn hình chi tiết thông tin bộ phim
class DetailScreen extends StatefulWidget {
  final Movie movie; // Nhận đối tượng phim được truyền từ màn hình trước

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Hàm xử lý khi nhấn nút Favorite (Yêu thích) - cập nhật trạng thái phim
  void _toggleFavorite() {
    setState(() {
      widget.movie.isFavorite = !widget.movie.isFavorite;
    });

    // Hiển thị thông báo (SnackBar) phản hồi cho người dùng
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.movie.isFavorite
              ? "Đã thêm '${widget.movie.title}' vào danh sách yêu thích!"
              : "Đã xóa '${widget.movie.title}' khỏi danh sách yêu thích!",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Hàm xử lý khi nhấn nút Rate (Đánh giá)
  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Đánh giá phim"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bạn đánh giá thế nào về phim '${widget.movie.title}'?"),
              const SizedBox(height: 16),
              // Hiển thị thanh chọn điểm từ 1 đến 5 sao giả lập
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.amber, size: 36),
                    onPressed: () {
                      Navigator.pop(context); // Đóng hộp thoại
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cảm ơn bạn đã đánh giá ${index + 1} sao cho bộ phim!"),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy bỏ"),
            ),
          ],
        );
      },
    );
  }

  // Hàm xử lý khi nhấn nút Share (Chia sẻ)
  void _shareMovie() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Liên kết chia sẻ của phim '${widget.movie.title}' đã được sao chép!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FC), // Đồng bộ màu nền trang chủ
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1B1F)),
          onPressed: () {
            // Quay trở lại màn hình trước đó
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: Color(0xFF1C1B1F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        // Cho phép cuộn toàn bộ màn hình nếu nội dung quá dài (Responsive)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner: Ảnh lớn ở trên kèm hiệu ứng chuyển cảnh Hero và dải màu gradient
            Hero(
              tag: 'poster_${widget.movie.id}', // Tag Hero phải trùng khớp với màn hình danh sách
              child: Stack(
                children: [
                  // Ảnh bìa phim (Tỷ lệ chiều cao cố định giống hình mẫu)
                  widget.movie.posterUrl.startsWith('assets/')
                      ? Image.asset(
                          widget.movie.posterUrl,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.movie.posterUrl,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                            );
                          },
                        ),
                  // Dải màu gradient phủ phía dưới ảnh để làm nổi bật tiêu đề
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black38,
                            Colors.black87, // Đậm nhất ở đáy để chữ trắng hiển thị rõ
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Chữ tiêu đề phim hiển thị đè lên ảnh ở góc dưới trái
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Material(
                      // Bọc Material để tránh lỗi render text của Widget Hero
                      color: Colors.transparent,
                      child: Text(
                        widget.movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Danh sách các thể loại hiển thị dạng Chips (Wrap tự động xuống dòng)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8, // Khoảng cách giữa các chip
                runSpacing: 8, // Khoảng cách dòng khi xuống dòng
                children: widget.movie.genres.map((genre) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F1FA), // Nền màu tím xám rất nhạt
                      border: Border.all(color: const Color(0xFFE2DCF0)), // Viền bo nhạt màu
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc nhỏ giống hình chụp
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF49454F),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Đoạn văn mô tả (Overview Text)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.movie.overview,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF49454F),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Hàng nút chức năng (Favorite, Rate, Share)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nút Favorite (Yêu thích) - Có toggle thay đổi trạng thái
                  _buildActionButton(
                    icon: widget.movie.isFavorite
                        ? Icons.favorite // Trái tim đầy màu đỏ khi đã thích
                        : Icons.favorite_border,
                    color: widget.movie.isFavorite ? Colors.red : const Color(0xFF49454F),
                    label: "Favorite",
                    onTap: _toggleFavorite,
                  ),
                  // Nút Rate (Đánh giá)
                  _buildActionButton(
                    icon: Icons.star_border,
                    color: const Color(0xFF49454F),
                    label: "Rate",
                    onTap: _showRatingDialog,
                  ),
                  // Nút Share (Chia sẻ)
                  _buildActionButton(
                    icon: Icons.share,
                    color: const Color(0xFF49454F),
                    label: "Share",
                    onTap: _shareMovie,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Phần Danh sách Trailer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Trailers",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1B1F),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Danh sách Trailer ngăn cách bởi các đường phân tuyến (Dividers)
            ListView.separated(
              shrinkWrap: true, // Cho phép ListView có độ dài co giãn theo nội dung
              physics: const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của ListView để cuộn chung với body
              itemCount: widget.movie.trailers.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE2DCF0),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final trailer = widget.movie.trailers[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: const Icon(
                    Icons.play_circle_fill_rounded, // Biểu tượng play trong hình tròn giống ảnh mẫu
                    color: Color(0xFF49454F),
                    size: 28,
                  ),
                  title: Text(
                    trailer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1C1B1F),
                    ),
                  ),
                  onTap: () {
                    // Sự kiện giả lập phát trailer
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đang mở trailer: '${trailer.name}'..."),
                      ),
                    );
                  },
                );
              },
            ),
            // Thêm chút khoảng trống ở đáy trang để cuộn thoải mái
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Hàm helper xây dựng các nút Action đẹp, gọn
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
