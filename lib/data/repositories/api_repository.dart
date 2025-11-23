import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post_model.dart';
import '../local/shared_prefs_helper.dart';
import '../models/users_model.dart';

class ApiRepository {
  final String baseUrl = "https://dummyjson.com";
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  // --- Auth ---
  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60, // Token expiration time
      }),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      // Error handling based on API response
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Login Failed');
    }
  }

  Future<UserModel> getCurrentUser() async {
    final token = await _prefsHelper.getToken();
    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data['token'] =
          token; // API doesn't return token in /me, so we attach existing one
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  // --- Posts ---
  Future<List<PostModel>> getPosts({
    int limit = 10,
    int skip = 0,
    String? searchQuery,
  }) async {
    String url;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url = '$baseUrl/posts/search?q=$searchQuery&limit=$limit&skip=$skip';
    } else {
      url = '$baseUrl/posts?limit=$limit&skip=$skip';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List posts = data['posts'];
      return posts.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<PostModel> getPostDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post details');
    }
  }
}
