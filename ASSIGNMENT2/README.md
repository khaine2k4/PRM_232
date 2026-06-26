# TaskFlow Pro — Assignment 2

Todo List app nâng cấp từ Assignment 1, bổ sung **đăng nhập (authentication)**,
**giữ phiên đăng nhập**, và **lưu trữ dữ liệu bền vững** bằng **SQLite** (cục bộ)
có **đồng bộ best-effort lên SQL Server**.

## Kiến trúc lưu trữ (Hybrid)

- **SQLite (`sqflite`)** là *nguồn dữ liệu chính* → app chạy đầy đủ kể cả khi offline.
- **SQL Server (`mssql_connection`)** là *bản sao bền vững* → mỗi thay đổi cục bộ
  được đẩy lên server theo cơ chế best-effort (không bao giờ làm crash app nếu mất mạng).
- **SharedPreferences** giữ phiên đăng nhập + lựa chọn giao diện (theme).

```
lib/
├── main.dart                     # Bootstrap + RootGate (Login vs Home)
├── config/app_config.dart        # Thông tin SQL Server (đổi tại đây)
├── models/
│   ├── app_user.dart
│   └── todo_task.dart            # + userId, synced, isDeleted
├── services/
│   ├── session_service.dart      # SharedPreferences: phiên + theme + last sync
│   ├── database_service.dart     # SQLite CRUD (users, tasks)
│   ├── auth_service.dart         # register / login / logout (SHA-256)
│   ├── sql_server_service.dart   # Kết nối + bootstrap DB/bảng trên SQL Server
│   └── sync_service.dart         # Đẩy thay đổi cục bộ -> SQL Server
└── screens/
    ├── splash_screen.dart
    ├── login_screen.dart / register_screen.dart
    ├── todo_screen.dart          # Shell: 4 tab + FAB + logout
    ├── home_tab.dart / schedule_tab.dart / stats_tab.dart / settings_tab.dart
    └── task_detail_sheet.dart    # Thêm / sửa task
```

## Đáp ứng yêu cầu đề bài

| Yêu cầu | Triển khai |
|---|---|
| **1. Login Screen** (email, password, button) | `login_screen.dart` |
| Validation: bắt buộc nhập, báo lỗi khi trống | Form validators + SnackBar |
| Chỉ login lần đầu, lưu trạng thái, mở Home khi đã login | `SessionService` + `_RootGate` trong `main.dart` |
| **2. Task Management** (add / view / toggle / delete) | `todo_screen.dart` + `home_tab.dart` |
| Mỗi task có ID, Title, trạng thái, ngày tạo | `models/todo_task.dart` |
| **3. Persistent Storage – Option A SQLite** (Insert/Read/Update/Delete) | `database_service.dart` |
| **4. Logout** (xóa phiên, về Login, lần sau phải login lại) | `auth_service.logout()` + `settings_tab.dart` |

### Tính năng vượt yêu cầu (bonus)
- Đăng ký tài khoản + xác nhận mật khẩu, mật khẩu băm SHA-256.
- Dữ liệu tách theo từng user (`userId`).
- Đồng bộ lên SQL Server riêng + nút "Đồng bộ" thủ công + hiển thị lần đồng bộ cuối.
- Dark/Light theme (được **ghi nhớ** giữa các lần mở app).
- Tìm kiếm, lọc theo danh mục, độ ưu tiên, hạn chót.
- Tab Lịch (timeline theo giờ) + tab Thống kê (biểu đồ tiến độ).
- Vuốt để xóa + Hoàn tác (undo).

## Cấu hình SQL Server

Mở `lib/config/app_config.dart` và chỉnh nếu cần:

```dart
static const String sqlServerIp = '100.123.181.94';
static const String sqlServerPort = '1433';
static const String sqlServerDatabase = 'Assignment2Todo';
static const String sqlServerUser = 'sa';
static const String sqlServerPassword = 'Khaidz12345';
```

> App **tự động tạo** database `Assignment2Todo` cùng 2 bảng `Users`, `Tasks`
> nếu chưa tồn tại (xem `sql_server_service.dart`). Nếu muốn tạo tay, dùng
> `sql/schema.sql`.

**Lưu ý mạng:** IP `100.123.181.94` là địa chỉ Tailscale → thiết bị/emulator chạy
app phải nằm trong cùng tailnet thì đồng bộ mới thành công. Nếu không kết nối được,
app vẫn hoạt động bình thường với SQLite và sẽ đồng bộ lại khi có mạng (nút "Đồng bộ").

## Chạy app

```bash
flutter pub get
flutter run            # chọn Android (khuyến nghị) hoặc Windows
```

Đăng ký một tài khoản → đăng nhập → thêm/sửa/xóa task. Đóng app rồi mở lại:
- Vẫn đăng nhập sẵn (bỏ qua màn Login).
- Task vẫn còn (đọc từ SQLite).
- Nhấn **Đăng xuất** trong Settings → lần mở sau yêu cầu đăng nhập lại.
