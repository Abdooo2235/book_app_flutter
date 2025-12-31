import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cards/book_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/dialogs/confirm_dialog.dart';
import 'add_edit_book_screen.dart';
import 'book_detail_screen.dart';

/// Books List Screen with grid view
class BooksListScreen extends StatefulWidget {
  const BooksListScreen({super.key});

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    try {
      final books = await _bookService.getAll();
      setState(() {
        _books = books;
        _filteredBooks = books;
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

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredBooks = _books;
      } else {
        _filteredBooks = _books.where((book) {
          final titleMatch = book.title.toLowerCase().contains(
            query.toLowerCase(),
          );
          final authorMatch = book.author.toLowerCase().contains(
            query.toLowerCase(),
          );
          final nameMatch = book.name.toLowerCase().contains(
            query.toLowerCase(),
          );
          return titleMatch || authorMatch || nameMatch;
        }).toList();
      }
    });
  }

  Future<void> _deleteBook(Book book) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Delete Book',
      message: 'Are you sure you want to delete "${book.title}"?',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true) {
      final success = await _bookService.delete(book.id!);
      if (success) {
        _loadBooks();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    }
  }

  void _navigateToAddBook() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditBookScreen()),
    );
    if (result == true) {
      _loadBooks();
    }
  }

  void _navigateToEditBook(Book book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditBookScreen(book: book)),
    );
    if (result == true) {
      _loadBooks();
    }
  }

  void _navigateToBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadBooks),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterBooks,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterBooks('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Books Grid
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Loading books...')
                : _filteredBooks.isEmpty
                ? EmptyState(
                    icon: Icons.menu_book_rounded,
                    title: _searchQuery.isEmpty
                        ? 'No Books Yet'
                        : 'No Results Found',
                    subtitle: _searchQuery.isEmpty
                        ? 'Add your first book to get started'
                        : 'Try a different search term',
                    buttonText: _searchQuery.isEmpty ? 'Add Book' : null,
                    onButtonPressed: _searchQuery.isEmpty
                        ? _navigateToAddBook
                        : null,
                  )
                : RefreshIndicator(
                    onRefresh: _loadBooks,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return BookCard(
                          book: book,
                          onTap: () => _navigateToBookDetail(book),
                          showActions: true,
                          onEdit: () => _navigateToEditBook(book),
                          onDelete: () => _deleteBook(book),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddBook,
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}
