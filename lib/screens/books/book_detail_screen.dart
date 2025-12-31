import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/user_book_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cards/book_card.dart';

/// Book Detail Screen - Shows full book information
class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  // Service for user-book operations
  final UserBookService _userBookService = UserBookService();

  // Default user ID (no auth required)
  static const int defaultUserId = 1;

  // State variables
  bool _isInMyBooks = false;
  bool _isLoading = false;
  int? _userBookId;

  @override
  void initState() {
    super.initState();
    _checkIfInMyBooks();
  }

  /// Check if this book is already in user's collection
  Future<void> _checkIfInMyBooks() async {
    if (widget.book.id != null) {
      final userBook = await _userBookService.checkUserHasBook(
        defaultUserId,
        widget.book.id!,
      );

      if (mounted) {
        setState(() {
          _isInMyBooks = userBook != null;
          _userBookId = userBook?.id;
        });
      }
    }
  }

  /// Add or remove book from My Books
  Future<void> _toggleMyBooks() async {
    setState(() => _isLoading = true);

    try {
      if (_isInMyBooks && _userBookId != null) {
        // Remove from My Books
        final success = await _userBookService.removeBookFromUser(_userBookId!);
        if (success && mounted) {
          setState(() {
            _isInMyBooks = false;
            _userBookId = null;
          });
          _showSnackBar('Removed from My Books', AppColors.info);
        }
      } else {
        // Add to My Books
        final userBook = await _userBookService.addBookToUser(
          defaultUserId,
          widget.book.id!,
        );
        if (userBook != null && mounted) {
          setState(() {
            _isInMyBooks = true;
            _userBookId = userBook.id;
          });
          _showSnackBar('Added to My Books', AppColors.success);
        }
      }
    } catch (e) {
      _showSnackBar('Failed: $e', AppColors.error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Helper to show snackbar messages
  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = BookCard.getBookGradient(widget.book.id ?? 0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible App Bar with Book Cover
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: gradientColors[0],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles (matching book card)
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: 40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 50,
                      bottom: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // Book Icon Centered
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            width: 120,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_stories_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Book Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Title
                  Text(
                    widget.book.title.isNotEmpty
                        ? widget.book.title
                        : widget.book.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),

                  // Author
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 18,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.book.author,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add/Remove from My Books Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _toggleMyBooks,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _isInMyBooks
                                  ? Icons.bookmark_remove
                                  : Icons.bookmark_add,
                            ),
                      label: Text(
                        _isInMyBooks
                            ? 'Remove from My Books'
                            : 'Add to My Books',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInMyBooks
                            ? AppColors.secondary
                            : AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Description Section
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.book.description.isNotEmpty
                        ? widget.book.description
                        : 'No description available.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Book Info Cards
                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        icon: Icons.book,
                        label: 'Name',
                        value: widget.book.name,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        icon: Icons.numbers,
                        label: 'ID',
                        value: widget.book.id?.toString() ?? 'N/A',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build an info card widget
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
