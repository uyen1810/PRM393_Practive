# LAB 10 - Authentication, Session Management & Notifications (Full Integrated)

## 1. Cách chạy ứng dụng (How to run)
1. Cài đặt dependencies: `flutter pub get`
2. Chạy ứng dụng trên máy ảo Android (API 33+): `flutter run`
3. Chấp nhận quyền gửi thông báo (Notification Permission) khi ứng dụng khởi động.

## 2. Tài khoản Test (Test Accounts)
Ứng dụng tích hợp công tắc chuyển đổi trực tiếp trên màn hình Login:
- **Chế độ Real REST API (DummyJSON - Lab 10.2):**
    - Username: `emilys`
    - Password: `emilyspass`
- **Chế độ Mock Login (Lab 10.1):**
    - Email: `test@example.com`
    - Password: `123456`
- **Google Sign-In (Lab 10.4):** Sử dụng tài khoản Google trên thiết bị (yêu cầu đặt file `google-services.json` vào `android/app/`).