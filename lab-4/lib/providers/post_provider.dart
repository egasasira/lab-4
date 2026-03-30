// lib/providers/post_provider.dart
import '../services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';  // ← Add this import
import '../exceptions/api_exceptions.dart';  // ← Add this import

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  final PostService _postService = PostService();  // ← Add this

  // Getters
  List<Post> get posts => _posts;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all posts
  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch posts from the new service
      _posts = await _postService.fetchPosts();
      
      // For users, we still need to fetch from your existing ApiService
      // or add a user service. For now, let's keep your existing user fetch
      _users = await ApiService.fetchUsers();
      
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
    } on ServerException catch (e) {
      _error = e.toString();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unexpected error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new post
  Future<bool> createPost(Post post) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPost = await _postService.createPost(post);
      _posts.insert(0, newPost);
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } on ServerException catch (e) {
      _error = e.toString();
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update post
  Future<bool> updatePost(Post post) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedPost = await _postService.updatePost(post);
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } on ServerException catch (e) {
      _error = e.toString();
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete post
  Future<bool> deletePost(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _postService.deletePost(id);
      _posts.removeWhere((post) => post.id == id);
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } on ServerException catch (e) {
      _error = e.toString();
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get post by id
  Post? getPostById(int id) {
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add this method to get user name (you'll need to implement user fetching)
  String getUserName(int userId) {
    try {
      final user = _users.firstWhere((user) => user.id == userId);
      return user.name;
    } catch (e) {
      return 'User #$userId';
    }
  }

  String getUserUsername(int userId) {
    try {
      final user = _users.firstWhere((user) => user.id == userId);
      return user.username;
    } catch (e) {
      return 'user$userId';
    }
  }
}