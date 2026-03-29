import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String postsEndpoint = '$baseUrl/posts';
  static const String usersEndpoint = '$baseUrl/users';

  // GET all posts
  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(postsEndpoint));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // GET single post
  static Future<Post> fetchPost(int id) async {
    try {
      final response = await http.get(Uri.parse('$postsEndpoint/$id'));
      
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // CREATE new post
  static Future<Post> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(postsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(post.toJson()),
      );
      
      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // UPDATE post
  static Future<Post> updatePost(Post post) async {
    if (post.id == null) {
      throw Exception('Post ID is required for update');
    }
    
    try {
      final response = await http.put(
        Uri.parse('$postsEndpoint/${post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(post.toJson()),
      );
      
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // DELETE post
  static Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('$postsEndpoint/$id'));
      
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // GET all users - properly placed inside the class
  static Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(usersEndpoint));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // GET single user
  static Future<User> fetchUser(int id) async {
    try {
      final response = await http.get(Uri.parse('$usersEndpoint/$id'));
      
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}