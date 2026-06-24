# Weather Companion — Lab 8B (Practical REST API Integration)

## 1. Kịch bản đã chọn
**Scenario A – Weather Companion App.**

## 2. App giúp giải quyết vấn đề gì?
App giúp người dùng ra quyết định nhanh cho ngày hôm nay:
- **"Hôm nay có cần mang ô không?"**
- **"Trời có hợp đi dạo / chơi thể thao ngoài trời không?"**
- **"Nên mặc gì cho phù hợp nhiệt độ?"**

Người dùng tìm một thành phố → app gọi REST API lấy thời tiết hiện tại → hiển thị
nhiệt độ, độ ẩm, gió, lượng mưa **và** đưa ra các **gợi ý hướng quyết định**
thay vì chỉ liệt kê số liệu thô.

## 3. API sử dụng (miễn phí, KHÔNG cần API key)
- **Geocoding** (tìm thành phố → toạ độ):
  `https://geocoding-api.open-meteo.com/v1/search?name=...`
- **Forecast** (thời tiết hiện tại theo toạ độ):
  `https://api.open-meteo.com/v1/forecast?latitude=...&longitude=...&current=...`

Nguồn: [Open-Meteo](https://open-meteo.com).

## 4. Kiến trúc (Service Layer pattern)
```
lib/
├── main.dart                       # Khởi động app
├── models/
│   ├── city.dart                   # Model City + fromJson (kết quả geocoding)
│   └── weather.dart                # Model Weather + fromJson + logic gợi ý
├── services/
│   └── weather_service.dart        # SERVICE LAYER: mọi lệnh gọi http nằm ở đây
└── screens/
    ├── home_screen.dart            # Màn hình chính: form tìm kiếm + danh sách
    └── weather_detail_screen.dart  # Màn hình chi tiết: thời tiết + gợi ý
```
- UI **không** gọi `http` trực tiếp — chỉ gọi `WeatherService.searchCities()` và
  `WeatherService.fetchWeatherForCity()`.
- Dùng `FutureBuilder` để bind dữ liệu API vào UI.

## 5. Đáp ứng yêu cầu chức năng của lab
| Yêu cầu | Cách hiện thực |
|---|---|
| Gọi REST API thật bằng `http` | `weather_service.dart` |
| Xử lý lỗi mạng | `WeatherException` + timeout + try/catch |
| Parse JSON → model class | `City.fromJson`, `Weather.fromJson` |
| UI có ý nghĩa (không phải text thô) | Card, ListTile, icon, thẻ gợi ý |
| Loading / Error / Empty + Retry | Có đủ ở cả 2 màn hình |
| Service Layer | `WeatherService` tách riêng |
| Phần "hướng quyết định" | Gợi ý mang ô / hoạt động / trang phục |

## 6. Cách chạy
```bash
flutter pub get
flutter run            # chọn thiết bị Android / Chrome / Windows
```
Gõ tên thành phố không dấu (vd `Hanoi`, `Tokyo`, `Da Nang`) để có kết quả tốt nhất.

## 7. Cách chụp các trạng thái để nộp
- **Loading**: ngay sau khi bấm tìm / mở màn hình chi tiết.
- **Error + Retry**: tắt mạng (hoặc bật chế độ máy bay) rồi tìm kiếm.
- **Data**: tìm một thành phố và mở chi tiết.
- **Empty**: tìm một chuỗi vô nghĩa (vd `xyzxyz`).
