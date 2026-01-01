/// API Configuration
class ApiConfig {
  static const String baseUrl = 'http://10.122.109.131:5101';

  // API Endpoints
  static const String books = '/api/book';
  static const String users = '/api/user';
  static const String userBooks = '/api/userbook';

  // Helper methods
  static String bookById(int id) => '/api/book/$id';
  static String userById(int id) => '/api/user/$id';
  static String userBookById(int id) => '/api/userbook/$id';
}
