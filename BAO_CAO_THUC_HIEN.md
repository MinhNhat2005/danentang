# BÁO CÁO THỰC HIỆN – ỨNG DỤNG QUẢN LÝ SẢN PHẨM

> Sinh viên điền họ tên, mã sinh viên, lớp, giảng viên và ngày thực hiện trước khi nộp. Chèn ảnh chụp màn hình thực tế vào các vị trí được đánh dấu. Không sử dụng ảnh minh họa giả thay cho ảnh chạy ứng dụng.

## 1. Mục tiêu

Xây dựng ứng dụng Admin bằng Flutter có thể đăng nhập, thêm, hiển thị, sửa, xóa sản phẩm trên nền tảng Web và Android. Dữ liệu được lưu trên Firebase Cloud Firestore.

## 2. Công nghệ sử dụng

| Công nghệ / thư viện | Vai trò |
|---|---|
| Flutter | Xây dựng giao diện đa nền tảng |
| Firebase Core | Khởi tạo kết nối Firebase |
| Firebase Authentication | Xác thực Admin bằng Email/Password |
| Cloud Firestore | Lưu và đồng bộ dữ liệu sản phẩm realtime |
| image_picker | Chọn ảnh từ thiết bị |
| path_provider | Lưu bản sao ảnh cục bộ trên Android |

## 3. Thiết kế cơ sở dữ liệu

Collection: `products`.

Một document chỉ gồm đúng 4 trường:

| Tên trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `name` | String | Tên sản phẩm |
| `price` | Number | Giá sản phẩm |
| `soluong` | Integer | Số lượng sản phẩm |
| `image` | String | Nội dung ảnh Base64 |

Document ID được Firestore tự sinh, không phải field dữ liệu. Không thêm trường khác vào document sản phẩm.

**Ảnh chụp cần chèn:** Firebase Console → Firestore Database → collection `products` → mở document để thể hiện bốn trường.

## 4. Các bước thực hiện

### Bước 1. Tạo và cấu hình Firebase

- Tạo Firebase project.
- Đăng ký ứng dụng Web và Android tương ứng.
- Bật Authentication Email/Password.
- Tạo tài khoản Admin trong Authentication.
- Tạo Cloud Firestore.
- Cập nhật Firebase options nếu sử dụng project riêng.
- Triển khai `firebase/firestore.rules`.

**Ảnh minh họa cần chèn:** Firebase project overview; Authentication đã bật Email/Password; danh sách tài khoản Admin; Firestore database.

### Bước 2. Cài đặt thư viện Flutter

Chạy `flutter pub get`. Các package chính: `firebase_core`, `firebase_auth`, `cloud_firestore`, `image_picker`, `path_provider`.

**Ảnh minh họa cần chèn:** Terminal chạy lệnh `flutter pub get` thành công và các package trong `pubspec.yaml`.

### Bước 3. Xây dựng đăng nhập Admin

Ứng dụng dùng Firebase Authentication. Khi đăng nhập thành công, `AuthGate` nhận trạng thái xác thực và chuyển đến trang quản lý sản phẩm. Khi đăng xuất, ứng dụng trở về màn hình đăng nhập. Mật khẩu không được ghi vào Firestore.

**Ảnh minh họa cần chèn:** màn hình đăng nhập và màn hình sau đăng nhập.

### Bước 4. Xây dựng chức năng thêm sản phẩm

Admin nhập tên, giá, số lượng và chọn ảnh. Ứng dụng kiểm tra dữ liệu, mã hóa ảnh thành Base64 rồi thêm document vào collection `products` với đúng bốn field.

**Ảnh minh họa cần chèn:** form thêm sản phẩm và sản phẩm sau khi thêm.

### Bước 5. Hiển thị danh sách sản phẩm

`ProductService.watchProducts()` lắng nghe snapshots của Firestore. Khi dữ liệu thay đổi, giao diện tự cập nhật. Danh sách hiển thị ảnh, tên, giá và số lượng; có tìm kiếm theo tên. Giao diện thay đổi bố cục phù hợp với màn hình rộng và điện thoại.

**Ảnh minh họa cần chèn:** danh sách sản phẩm trên Web và Android.

### Bước 6. Xây dựng chức năng sửa sản phẩm

Admin chọn thao tác Sửa, cập nhật các thông tin cần thiết và lưu. Ứng dụng gọi `update()` trên document tương ứng, chỉ cập nhật bốn field quy định.

**Ảnh minh họa cần chèn:** form sửa và kết quả sau khi lưu.

### Bước 7. Xây dựng chức năng xóa sản phẩm

Admin chọn Xóa, xác nhận trong hộp thoại. Ứng dụng gọi `delete()` trên document tương ứng. Danh sách realtime tự cập nhật sau khi xóa.

**Ảnh minh họa cần chèn:** hộp thoại xác nhận và danh sách sau khi xóa.

### Bước 8. Chọn và hiển thị ảnh trên di động

Dùng `image_picker` để chọn ảnh. Ảnh được giới hạn dung lượng đầu vào 600 KB và mã hóa Base64 để lưu Firestore. Cùng giá trị ảnh có thể được giải mã và hiển thị trên Web và Android.

**Ảnh minh họa cần chèn:** giao diện chọn ảnh trên Android và ảnh sản phẩm hiển thị trong danh sách.

## 5. Kiểm thử

| STT | Ca kiểm thử | Kết quả cần ghi nhận |
|---|---|---|
| 1 | Đăng nhập đúng tài khoản Admin | Vào trang sản phẩm |
| 2 | Đăng nhập sai mật khẩu | Firebase từ chối đăng nhập |
| 3 | Thêm sản phẩm đủ dữ liệu | Document được tạo trong `products` |
| 4 | Bỏ trống tên sản phẩm | Hiện thông báo kiểm tra dữ liệu |
| 5 | Nhập giá không hợp lệ | Không cho lưu |
| 6 | Nhập số lượng không phải số nguyên | Không cho lưu |
| 7 | Chọn ảnh sản phẩm | Ảnh xem trước và được lưu |
| 8 | Sửa sản phẩm | Document được cập nhật |
| 9 | Xóa sản phẩm | Document bị xóa sau xác nhận |
| 10 | Đăng xuất | Trở về màn hình đăng nhập |
| 11 | Chạy trên Web | Danh sách và ảnh hiển thị |
| 12 | Chạy trên Android | Danh sách và ảnh hiển thị |

Sinh viên ghi kết quả thực tế (Đạt/Chưa đạt) và ghi chú cho từng ca kiểm thử sau khi chạy.

## 6. Hướng dẫn chạy

```bash
flutter pub get
flutter run -d chrome
```

Android:

```bash
flutter run
```

Kiểm tra mã nguồn:

```bash
flutter analyze
flutter test
```

## 7. Kết luận

Ứng dụng được tổ chức theo mô hình tách model, service và screen. Chức năng CRUD sản phẩm thao tác với Firebase Cloud Firestore; Firebase Authentication quản lý đăng nhập Admin; ảnh sản phẩm được lưu Base64 để hỗ trợ đồng bộ Web và Android. Trước khi nộp, cần chạy kiểm thử thực tế, bổ sung ảnh chụp minh họa, cập nhật thông tin sinh viên và đính kèm link GitHub cùng video demo.

## 8. Thông tin nộp bài

- GitHub: [Điền link repository]
- Video demo: [Điền link video]
- File dữ liệu: `database/products.sample.json`
