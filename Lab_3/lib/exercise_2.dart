class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}

class UserRepository {
  Future<List<User>> getUsers() async {
    final jsonList = [
      {
        'name': 'Nguyen Van Anh',
        'email': 'anh@gmail.com',
      },
      {
        'name': 'Tran Thi Binh',
        'email': 'binh@gmail.com',
      },
      {
        'name': 'Le Van Chien',
        'email': 'chien@gmail.com',
      },
    ];

    await Future.delayed(const Duration(seconds: 1));

    return jsonList
        .map((json) => User.fromJson(json))
        .toList();
  }
}