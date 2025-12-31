/// API Configuration
/// Update baseUrl to match your .NET backend URL
class ApiConfig {
  // Change this to your .NET backend URL
  // For Android emulator use: http://10.0.2.2:5000
  // For iOS simulator/real device use your machine's IP: http://192.168.x.x:5000
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
