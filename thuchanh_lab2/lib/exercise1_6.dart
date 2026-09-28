class User {
  int id;
  String name;
  String? email;

  // Constructor
  User({required this.id, required this.name, this.email});

  // Factory constructor
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? "Khách",
      email: json['email'],
    );
  }

  void showProfile() {
    print("ID: $id | Tên: $name | Email: ${email ?? "Chưa cập nhật"}");
  }
}

void main() {
  // Giả lập dữ liệu JSON trả về từ API
  Map<String, dynamic> rawData1 = {
    "id": 1,
    "name": "Nam",
    "email": "nam@fpt.edu.vn"
  };

  Map<String, dynamic> rawData2 = {
    "id": 2,
    "name": null,
    "email": null
  };

  // Khởi tạo User từ JSON
  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  // Hiển thị thông tin
  user1.showProfile();
  user2.showProfile();
}