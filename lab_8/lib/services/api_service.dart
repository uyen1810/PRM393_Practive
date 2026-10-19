import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client
          .get(
        Uri.parse(baseUrl),
        headers: {'Accept': 'application/json'},
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Raw JSON preview: ${response.body.substring(0, 100)}...');

        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((jsonItem) => Post.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load posts (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  Future<Post> createPost(String title, String body) async {
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        print('Created Post Response: ${response.body}');
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }
}