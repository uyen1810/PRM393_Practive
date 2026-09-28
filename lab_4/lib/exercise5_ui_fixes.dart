import 'package:flutter/material.dart';

class CommonUiFixesDemo extends StatefulWidget {
  const CommonUiFixesDemo({super.key});

  @override
  State<CommonUiFixesDemo> createState() => _CommonUiFixesDemoState();
}

class _CommonUiFixesDemoState extends State<CommonUiFixesDemo> {
  final List<String> movies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // FIX 1: Dùng Expanded bọc ListView bên trong Column để tránh lỗi vô hạn chiều cao (Unbounded Height Error)
            Expanded(
              // FIX 2: Trường hợp màn hình nhỏ hoặc bàn phím xuất hiện, ListView giúp tránh RenderFlex Overflow
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.movie, size: 28),
                    title: Text(movies[index]),
                    onTap: () {
                      // FIX 3: Gọi setState khi cập nhật dữ liệu để giao diện tự render lại
                      setState(() {
                        // Logic cập nhật trạng thái ở đây
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}