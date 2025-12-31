import 'book.dart';
import 'user.dart';

/// UserBook Model - Matches .NET UserBook entity (Many-to-Many relationship)
class UserBook {
  final int? id;
  final int userId;
  final int bookId;
  final User? user;
  final Book? book;

  UserBook({
    this.id,
    required this.userId,
    required this.bookId,
    this.user,
    this.book,
  });

  /// Create UserBook from JSON (API response)
  factory UserBook.fromJson(Map<String, dynamic> json) {
    return UserBook(
      id: json['id'] as int?,
      userId: json['userId'] as int? ?? 0,
      bookId: json['bookId'] as int? ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      book: json['book'] != null ? Book.fromJson(json['book']) : null,
    );
  }

  /// Convert UserBook to JSON (API request)
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'userId': userId, 'bookId': bookId};
  }
}
