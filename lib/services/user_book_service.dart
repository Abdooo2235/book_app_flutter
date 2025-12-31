import '../config/api_config.dart';
import '../models/user_book.dart';
import 'api_service.dart';

/// UserBook Service - Operations for user-book relationships
class UserBookService {
  final ApiService _api = ApiService();

  /// Get all user-book relationships
  Future<List<UserBook>> getAll() async {
    final response = await _api.get(ApiConfig.userBooks);
    if (response is List) {
      return response.map((json) => UserBook.fromJson(json)).toList();
    }
    return [];
  }

  /// Get books for a specific user
  Future<List<UserBook>> getByUserId(int userId) async {
    final all = await getAll();
    return all.where((ub) => ub.userId == userId).toList();
  }

  /// Add book to user's collection
  Future<UserBook?> addBookToUser(int userId, int bookId) async {
    final userBook = UserBook(userId: userId, bookId: bookId);
    final response = await _api.post(ApiConfig.userBooks, userBook.toJson());
    if (response != null) {
      return UserBook.fromJson(response);
    }
    return null;
  }

  /// Remove book from user's collection
  Future<bool> removeBookFromUser(int userBookId) async {
    try {
      await _api.delete(ApiConfig.userBookById(userBookId));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if user has a book
  Future<UserBook?> checkUserHasBook(int userId, int bookId) async {
    final userBooks = await getByUserId(userId);
    try {
      return userBooks.firstWhere((ub) => ub.bookId == bookId);
    } catch (e) {
      return null;
    }
  }
}
