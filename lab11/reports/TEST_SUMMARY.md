# Kết quả kiểm thử lab11

Ngày kiểm tra: 15/10/2026.
Phân tích mã: không có cảnh báo/lỗi.
Test tự động: 16 test thành công; mã kết thúc 0.

Các nhóm: unit model/repository, widget UI, navigation, full flow thêm/sửa,
tích hợp model và repository.
Các test đều chạy trong môi trường Flutter test, không cần backend.
integration_test/taskly_test.dart là bản kiểm thử thiết bị; đã chạy thành công trên emulator Android.
Chưa có số liệu FPS/jank hoặc ảnh DevTools được quan sát trên thiết bị.

Chạy lại: flutter analyze; flutter test.
Chạy thiết bị: flutter test integration_test -d <android-device-id>.
