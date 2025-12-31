import 'package:flutter/material.dart';
import '../../models/user_book.dart';
import '../../services/user_book_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';
import '../books/book_detail_screen.dart';

/// My Books Screen - Shows saved books
/// Uses default user ID = 1 (no authentication required)
class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  // Service for user-book operations
  final UserBookService _userBookService = UserBookService();

  // Default user ID (no auth)
  static const int defaultUserId = 1;

  // State variables
  List<UserBook> _userBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyBooks();
  }

  /// Load user's saved books from API
  Future<void> _loadMyBooks() async {
    setState(() => _isLoading = true);

    try {
      final userBooks = await _userBookService.getByUserId(defaultUserId);
      setState(() {
        _userBooks = userBooks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load books: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Remove a book from collection
  Future<void> _removeFromMyBooks(UserBook userBook) async {
    final success = await _userBookService.removeBookFromUser(userBook.id!);

    if (success) {
      _loadMyBooks(); // Refresh list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book removed from your collection'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: const Text('My Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMyBooks,
            tooltip: 'Refresh',
          ),
        ],
      ),

      // Body
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading your books...')
          : _userBooks.isEmpty
          ? const EmptyState(
              icon: Icons.bookmark_border,
              title: 'No Books Yet',
              subtitle: 'Books you add will appear here',
            )
          : RefreshIndicator(
              onRefresh: _loadMyBooks,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _userBooks.length,
                itemBuilder: (context, index) {
                  final userBook = _userBooks[index];
                  return _buildBookItem(userBook, isDark);
                },
              ),
            ),
    );
  }

  /// Build a single book item in the list
  Widget _buildBookItem(UserBook userBook, bool isDark) {
    final book = userBook.book;

    return Dismissible(
      key: Key(userBook.id.toString()),
      direction: DismissDirection.endToStart,

      // Swipe background (delete)
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      // On swipe delete
      onDismissed: (_) => _removeFromMyBooks(userBook),

      // Book card
      child: GestureDetector(
        onTap: () {
          if (book != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Book Icon
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book?.title ?? book?.name ?? 'Unknown Book',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book?.author ?? 'Unknown Author',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Remove Button
              IconButton(
                icon: const Icon(Icons.bookmark_remove),
                color: AppColors.error,
                onPressed: () => _removeFromMyBooks(userBook),
                tooltip: 'Remove from My Books',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
