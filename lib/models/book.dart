/// Book Model - Matches .NET Book entity
class Book {
  final int? id;
  final String name;
  final String title;
  final String author;
  final String description;

  Book({
    this.id,
    required this.name,
    required this.title,
    required this.author,
    required this.description,
  });

  /// Create Book from JSON (API response)
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  /// Convert Book to JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'title': title,
      'author': author,
      'description': description,
    };
  }

  /// Create a copy with modified fields
  Book copyWith({
    int? id,
    String? name,
    String? title,
    String? author,
    String? description,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
    );
  }
}
