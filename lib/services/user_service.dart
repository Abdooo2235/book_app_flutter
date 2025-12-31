import '../config/api_config.dart';
import '../models/user.dart';
import 'api_service.dart';

/// User Service - CRUD operations and authentication
class UserService {
  final ApiService _api = ApiService();

  /// Get all users
  Future<List<User>> getAll() async {
    final response = await _api.get(ApiConfig.users);
    if (response is List) {
      return response.map((json) => User.fromJson(json)).toList();
    }
    return [];
  }

  /// Get user by ID
  Future<User?> getById(int id) async {
    final response = await _api.get(ApiConfig.userById(id));
    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  /// Register new user
  Future<User?> register(User user) async {
    final response = await _api.post(ApiConfig.users, user.toJson());
    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  /// Login user (finds user by email and validates password)
  Future<User?> login(String email, String password) async {
    // Since backend doesn't have auth endpoint, we fetch all users
    // and validate locally (not secure, but matches current backend)
    final users = await getAll();
    try {
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  /// Update user
  Future<User?> update(int id, User user) async {
    final response = await _api.put(ApiConfig.userById(id), user.toJson());
    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  /// Delete user
  Future<bool> delete(int id) async {
    try {
      await _api.delete(ApiConfig.userById(id));
      return true;
    } catch (e) {
      return false;
    }
  }
}
