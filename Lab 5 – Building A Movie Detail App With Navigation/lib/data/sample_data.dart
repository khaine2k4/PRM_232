import '../models/movie.dart';

// Danh sách dữ liệu mẫu chứa các bộ phim hiển thị trong ứng dụng
// Khớp hoàn toàn với thông tin và hình ảnh trong yêu cầu đề bài
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: "Dune: Part Two",
    // Sử dụng ảnh poster cục bộ đã được tải về thư mục assets
    posterUrl: "assets/images/download.jpg",
    rating: 8.6,
    genres: ["Sci-Fi", "Adventure", "Drama"],
    overview: "Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.",
    trailers: [
      Trailer(
        name: "Official Trailer #1",
        url: "https://www.youtube.com/watch?v=Way9Dexny3w",
      ),
      Trailer(
        name: "IMAX Sneak Peek",
        url: "https://www.youtube.com/watch?v=J7hS1K87F_c",
      ),
    ],
    isFavorite: false, // Mặc định ban đầu chưa yêu thích
  ),
  Movie(
    id: 2,
    title: "Deadpool & Wolverine",
    // Sử dụng ảnh poster cục bộ đã được tải về thư mục assets
    posterUrl: "assets/images/images.jpg",
    rating: 8.3,
    genres: ["Action", "Comedy"],
    overview: "The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.",
    trailers: [
      Trailer(
        name: "Red Band Trailer",
        url: "https://www.youtube.com/watch?v=73_1biulkYk",
      ),
      Trailer(
        name: "Behind the Scenes",
        url: "https://www.youtube.com/watch?v=ZlNFpri-Y90",
      ),
    ],
    isFavorite: false, // Mặc định ban đầu chưa yêu thích
  ),
];
