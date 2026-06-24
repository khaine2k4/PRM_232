# Lab 8 — API-powered List Screen (Flutter + REST API)

App lấy danh sách bài viết từ REST API công khai, parse JSON → model và hiển thị
bằng `ListView.builder` với `FutureBuilder` (loading / error / data).

## API sử dụng
`https://jsonplaceholder.typicode.com/posts` (GET danh sách, POST tạo mới).

## Kiến trúc (Service Layer pattern)
```
lib/
├── main.dart                       # MaterialApp → PostListScreen
├── models/
│   └── post.dart                   # Model Post + factory fromJson() + toJson()
├── services/
│   └── api_service.dart            # ApiService: fetchPosts() (GET) + createPost() (POST)
└── screens/
    ├── post_list_screen.dart       # Danh sách: FutureBuilder + ListView.builder
    ├── post_detail_screen.dart     # Chi tiết bài viết (bonus)
    └── create_post_screen.dart     # Form POST tạo bài viết mới (bonus)
```

## Đáp ứng yêu cầu lab
| Sub-task | Hiện thực |
|---|---|
| 8.1 GET request | `ApiService.fetchPosts()` dùng `http.get` |
| 8.2 JSON → Model + ListView | `Post.fromJson`, `json.decode`, `ListView.builder` |
| 8.3 Loading + Error | `CircularProgressIndicator`, thông báo lỗi + nút **Thử lại** |
| 8.4 ApiService (Service Layer) | UI không gọi http; `http.Client` được inject |
| Widgets bắt buộc | `FutureBuilder`, `ListView.builder`, `CircularProgressIndicator`, `json.decode()`, `factory fromJson()`, exception handling |

## Bonus đã làm thêm
- ✅ Pull-to-refresh (`RefreshIndicator`)
- ✅ Màn hình chi tiết khi nhấn vào item
- ✅ POST request: form tạo bài viết mới + báo thành công/lỗi
- ✅ Nút Retry trong trạng thái lỗi
- ✅ UI Card + icon + avatar
- ✅ Unit test cho `ApiService` dùng `MockClient` (chứng minh inject client + parse JSON)

## Cách chạy
```bash
flutter pub get
flutter run            # Android Studio / VS Code (chọn Android / Chrome / Windows)
flutter test           # chạy 2 test (1 widget + 1 unit)
```

## Chụp màn hình để nộp
- **Loading**: ngay khi mở app (trước khi data về).
- **Error**: tắt mạng rồi bấm nút Tải lại / kéo refresh → hiện lỗi + nút Thử lại.
- **List loaded**: danh sách bài viết hiển thị đầy đủ.
