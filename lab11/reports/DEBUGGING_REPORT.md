# Hướng dẫn và nhận định kiểm thử Taskly

Ứng dụng quản lý tác vụ dùng model Task và TaskRepository trong bộ nhớ.
Các test kiểm tra dữ liệu, giao diện, điều hướng và luồng thêm/sửa hoàn chỉnh.

## Vấn đề layout tiềm năng

Tiêu đề dài hoặc bàn phím ở màn hình nhỏ có thể làm nội dung form tràn.
Màn hình danh sách dùng Expanded cho ô nhập và ListView; màn hình Detail dùng
SingleChildScrollView. Dùng Widget Inspector xem constraints và thử cỡ chữ lớn
để xác minh. Đây là tình huống cần kiểm tra, không phải lỗi đã quan sát bằng DevTools.

## Vấn đề hiệu năng tiềm năng

TaskListScreen gọi setState ở cấp màn hình khi toggle/xóa task. Với nhiều tác vụ,
các hàng đang thấy có thể dựng lại dù chỉ một task đổi. Performance Timeline và
Track widget builds giúp xác định các widget dựng lại và thời gian frame.
Lab 12 trình diễn cách tách TaskTile và dùng Selector để giới hạn rebuild.

## Cách lấy ảnh DevTools thật

Chạy app debug, chọn Open Flutter DevTools trong Android Studio.
1. Widget Inspector: mở cây TaskListScreen và chọn một ListTile; lưu ảnh widget tree.
2. Performance: record, thêm/toggle/sửa vài task, stop; lưu ảnh timeline.
Đặt ảnh vào reports/screenshots và dẫn ảnh khi hoàn thiện bản nộp.
Hiện chưa có ảnh/trace từ thiết bị, không coi unit/widget test là bằng chứng profile.

