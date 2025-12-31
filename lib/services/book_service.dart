import 'api_service.dart';
import '../models/book.dart';
import '../config/api_config.dart';

/// Book Service - CRUD operations for books
class BookService {
  final ApiService _api = ApiService();

  /// Get all books
  Future<List<Book>> getAll() async {
    final response = await _api.get(ApiConfig.books);
    if (response is List) {
      return response.map((json) => Book.fromJson(json)).toList();
    }
    return [];
  }

  /// Get book by ID
  Future<Book?> getById(int id) async {
    final response = await _api.get(ApiConfig.bookById(id));
    if (response != null) {
      return Book.fromJson(response);
    }
    return null;
  }

  /// Create new book
  Future<Book?> create(Book book) async {
    try {
      final response = await _api.post(ApiConfig.books, book.toJson());
      if (response != null) {
        return Book.fromJson(response);
      }
      return book;
    } catch (e) {
      rethrow;
    }
  }

  /// Update book
  Future<Book?> update(int id, Book book) async {
    final response = await _api.put(ApiConfig.bookById(id), book.toJson());
    if (response != null) {
      return Book.fromJson(response);
    }
    return null;
  }

  /// Delete book
  Future<bool> delete(int id) async {
    try {
      await _api.delete(ApiConfig.bookById(id));
      return true;
    } catch (e) {
      return false;
    }
  }
}
