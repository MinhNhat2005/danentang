# ỨNG DỤNG QUẢN LÝ SẢN PHẨM – FLUTTER + FIREBASE

Ứng dụng Admin quản lý sản phẩm trên Web và Android. Dự án sử dụng Flutter, Firebase Authentication và Cloud Firestore.

## 1. Đối chiếu yêu cầu đề bài

| Yêu cầu | Cách thực hiện |
|---|---|
| Flutter hoặc React Native | Flutter |
| CSDL Firebase hoặc MongoDB | Cloud Firestore |
| Thêm, hiển thị, sửa, xóa | CRUD trong collection `products` |
| Đúng 4 trường dữ liệu | `name`, `price`, `soluong`, `image` |
| Đăng nhập, đăng xuất | Firebase Authentication Email/Password |
| Chọn và hiển thị hình ảnh | `image_picker`, ảnh Base64 |
| Web và di động | Flutter Web + Android, giao diện responsive |

**Lưu ý:** Firestore document sản phẩm chỉ chứa đúng bốn trường `name`, `price`, `soluong`, `image`. ID là document ID do Firestore cấp, không được lưu thành field trong document. Không thêm `createdAt`, `updatedAt`, `category` hoặc trường nào khác.

## 2. Công nghệ và thư viện

- `firebase_core`: khởi tạo Firebase.
- `firebase_auth`: đăng nhập và đăng xuất Admin.
- `cloud_firestore`: lưu và đồng bộ sản phẩm realtime.
- `image_picker`: chọn ảnh từ thư viện trên Web/Android.
- `path_provider`: lưu bản sao ảnh cục bộ trên Android.

## 3. Cấu trúc thư mục chính

```text
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   └── product_model.dart
├── screens/
│   ├── login_screen.dart
│   ├── products_screen.dart
│   ├── product_form_screen.dart
│   └── profile_screen.dart
├── services/
│   ├── auth_service.dart
│   └── product_service.dart
├── utils/
│   ├── image_storage.dart
│   ├── image_storage_io.dart
│   ├── image_storage_web.dart
│   └── image_storage_stub.dart
└── theme/
    └── app_theme.dart

firebase/
└── firestore.rules
database/
└── products.sample.json
```

## 4. Cấu trúc cơ sở dữ liệu

Tên collection: `products`.

Mỗi document có đúng cấu trúc:

```json
{
  "name": "Áo thun nam",
  "price": 150000,
  "soluong": 20,
  "image": "base64:..."
}
```

- `name`: string – tên sản phẩm.
- `price`: number – giá sản phẩm.
- `soluong`: integer – số lượng.
- `image`: string – dữ liệu ảnh Base64.

Ảnh được giảm kích thước/chất lượng khi chọn và giới hạn dung lượng đầu vào 600 KB. Giá trị ảnh được lưu dưới dạng `base64:...` trong Firestore để cả Web và Android có thể đọc. Không cần tạo Firebase Storage bucket cho cách lưu này. Firestore giới hạn document 1 MiB, vì vậy không nên tăng kích thước ảnh tùy tiện.

## 5. Cài đặt và cấu hình Firebase

1. Mở Firebase Console: https://console.firebase.google.com/.
2. Tạo hoặc chọn Firebase project.
3. Vào **Authentication → Sign-in method**, bật **Email/Password**.
4. Vào **Authentication → Users → Add user** để tạo tài khoản Admin (email và mật khẩu do người thực hiện tự đặt).
5. Vào **Firestore Database → Create database**.
6. Mở tab Rules, dán nội dung file `firebase/firestore.rules` và Publish.
7. Kiểm tra `lib/firebase_options.dart` đang trỏ đến Firebase project đúng. File hiện tại được cấu hình cho project `user-management-b6be0`. Nếu dùng project khác, chạy FlutterFire CLI để tạo lại cấu hình:

```bash
 dart pub global activate flutterfire_cli
 flutterfire configure
```

Không đưa mật khẩu Admin vào source code hoặc file JSON dữ liệu.

## 6. Cài thư viện và chạy ứng dụng

Tại thư mục chứa `pubspec.yaml`, chạy:

```bash
flutter pub get
flutter devices
```

Chạy Web:

```bash
flutter run -d chrome
```

Build Web để triển khai:

```bash
flutter build web
```

Chạy Android trên máy ảo hoặc điện thoại đã bật USB debugging:

```bash
flutter run
```

## 7. Hướng dẫn kiểm thử chức năng

1. Mở ứng dụng, đăng nhập bằng tài khoản Admin đã tạo trong Firebase Authentication.
2. Nhấn **Thêm sản phẩm**.
3. Nhập tên, giá, số lượng và chọn ảnh từ thư viện.
4. Nhấn **Thêm sản phẩm**, kiểm tra document mới trong Firestore → `products`.
5. Chọn menu thao tác trên sản phẩm và nhấn **Sửa**; thay đổi thông tin rồi lưu.
6. Chọn **Xóa**, xác nhận và kiểm tra document đã bị xóa.
7. Đăng xuất, kiểm tra ứng dụng quay lại màn hình đăng nhập.
8. Lặp lại thao tác chọn ảnh và hiển thị trên Android.

## 8. Kiểm tra mã nguồn

```bash
flutter analyze
flutter test
```

## 9. Nội dung cần chụp ảnh đưa vào báo cáo

- Màn hình đăng nhập Admin.
- Màn hình danh sách sản phẩm trên Web.
- Form thêm sản phẩm có đủ 4 trường và ảnh.
- Thông báo/kết quả sau khi thêm sản phẩm.
- Màn hình sửa sản phẩm.
- Hộp thoại xác nhận và kết quả xóa sản phẩm.
- Firestore collection `products`, mở một document để thấy chính xác 4 trường.
- Màn hình danh sách và ảnh sản phẩm trên Android.
- Màn hình đăng xuất / quay lại đăng nhập.

## 10. Link nộp bài

- GitHub source code: điền link repository sau khi đẩy source.
- Video demo: điền link video sau khi quay thao tác thực tế.
- File cơ sở dữ liệu: `database/products.sample.json` (file mẫu mô tả đúng cấu trúc; dữ liệu thật và ảnh thật nằm trong Firestore của Firebase project).

Không sử dụng file JSON mẫu như dữ liệu ảnh thực tế: thay chuỗi `base64:THAY_BANG...` bằng dữ liệu ảnh thực tế nếu cần import mẫu. Cách dễ và chính xác nhất là thêm sản phẩm bằng ứng dụng để ảnh được mã hóa tự động.
