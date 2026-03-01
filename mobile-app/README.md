# KidFavor Mobile App (Flutter)

Ứng dụng mobile cho KidFavor E-commerce - Cửa hàng đồ chơi trẻ em.

## 📱 Tính năng

- ✅ Đăng nhập/Đăng xuất
- ✅ Xem danh sách sản phẩm
- ✅ Xem chi tiết sản phẩm
- ✅ Thêm vào giỏ hàng
- ✅ Quản lý giỏ hàng (tăng/giảm số lượng, xóa sản phẩm)
- ✅ Tính tổng giá trị giỏ hàng

## 🚀 Cài đặt

### Yêu cầu

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode (để chạy emulator)
- Backend API đang chạy tại `http://localhost:8080`

### Các bước cài đặt

1. **Di chuyển vào thư mục mobile-app:**

```bash
cd /Users/phnanhky/IntelliJ/MSS301-BE/mobile-app
```

2. **Cài đặt dependencies:**

```bash
flutter pub get
```

3. **Chạy ứng dụng:**

```bash
# Chạy trên Android emulator
flutter run

# Hoặc chỉ định device
flutter run -d <device_id>

# Xem danh sách devices
flutter devices
```

## ⚙️ Cấu hình

### Kết nối với Backend API

Mở file `lib/services/api_service.dart` và cập nhật `baseUrl`:

```dart
// Nếu chạy trên máy tính (web/desktop)
static const String baseUrl = 'http://localhost:8080';

// Nếu chạy trên Android Emulator
static const String baseUrl = 'http://10.0.2.2:8080';

// Nếu chạy trên thiết bị thật (thay bằng IP máy tính của bạn)
static const String baseUrl = 'http://192.168.1.xxx:8080';
```

**Tìm IP máy tính:**

```bash
# macOS/Linux
ifconfig | grep "inet "

# Windows
ipconfig
```

## 📂 Cấu trúc thư mục

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── product.dart
│   ├── cart.dart
│   └── user.dart
├── services/                 # API services
│   ├── api_service.dart      # Base API service
│   ├── auth_service.dart     # Authentication
│   └── cart_service.dart     # Cart management
├── screens/                  # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── product_list_screen.dart
│   ├── product_detail_screen.dart
│   └── cart_screen.dart
└── widgets/                  # Reusable widgets (future)
```

## 🎯 API Endpoints được sử dụng

### User Service

- `POST /user-service/auth/login` - Đăng nhập
- `GET /user-service/users/{id}` - Lấy thông tin user

### Product Service

- `GET /product-service/products` - Danh sách sản phẩm
- `GET /product-service/products/{id}` - Chi tiết sản phẩm

### Cart Service

- `GET /cart-service/carts/{userId}` - Lấy giỏ hàng
- `POST /cart-service/carts` - Thêm vào giỏ hàng
- `PUT /cart-service/carts/{userId}/items/{productId}` - Cập nhật số lượng
- `DELETE /cart-service/carts/{userId}/items/{productId}` - Xóa sản phẩm
- `DELETE /cart-service/carts/{userId}` - Xóa toàn bộ giỏ hàng

## 🔐 Test Account

```
Username: johndoe
Password: password123
```

## 📝 TODO - Tính năng tiếp theo

- [ ] Đăng ký tài khoản mới
- [ ] Tìm kiếm sản phẩm
- [ ] Lọc sản phẩm theo danh mục
- [ ] Đánh giá sản phẩm
- [ ] Lịch sử đơn hàng
- [ ] Thanh toán
- [ ] Push notifications
- [ ] Dark mode

## 🐛 Debug

### Lỗi kết nối API

```
SocketException: Failed host lookup
```

**Giải pháp:** Kiểm tra lại `baseUrl` trong `api_service.dart`

### Android Network Permission

Thêm vào `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS App Transport Security

Thêm vào `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 📸 Screenshots

_(TODO: Thêm screenshots của ứng dụng)_

## 🤝 Contributing

1. Fork the project
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is part of MSS301-BE microservices system.
