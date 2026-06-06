// Lớp biểu diễn thông tin của một Trailer phim
class Trailer {
  final String name; // Tên của trailer (ví dụ: "Official Trailer #1")
  final String url;  // Đường dẫn giả lập hoặc link xem trailer

  // Hàm khởi tạo (Constructor) của lớp Trailer
  Trailer({
    required this.name,
    required this.url,
  });
}

// Lớp biểu diễn thông tin chi tiết của một bộ phim
class Movie {
  final int id;                 // Mã định danh duy nhất của bộ phim
  final String title;           // Tiêu đề/Tên bộ phim
  final String posterUrl;       // Đường dẫn ảnh poster của phim (dạng URL mạng)
  final double rating;          // Điểm đánh giá của phim (ví dụ: 8.6)
  final List<String> genres;    // Danh sách các thể loại phim (ví dụ: ["Sci-Fi", "Adventure"])
  final String overview;        // Nội dung mô tả/tóm tắt phim
  final List<Trailer> trailers; // Danh sách các trailer đi kèm bộ phim
  bool isFavorite;              // Trạng thái yêu thích của phim (có thể thay đổi)

  // Hàm khởi tạo (Constructor) của lớp Movie
  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.genres,
    required this.overview,
    required this.trailers,
    this.isFavorite = false,    // Mặc định ban đầu phim chưa được yêu thích
  });
}
