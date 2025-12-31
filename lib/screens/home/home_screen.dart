import 'package:flutter/material.dart';
import '../books/books_list_screen.dart';
import '../my_books/my_books_screen.dart';
import '../../theme/app_colors.dart';

/// Home Screen - Main navigation hub with bottom nav bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current selected tab index
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const BooksListScreen(), // Tab 0: All Books
    const MyBooksScreen(), // Tab 1: My Books
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Display current screen based on selected tab
      body: IndexedStack(index: _currentIndex, children: _screens),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Books Tab
                _buildNavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Books',
                  index: 0,
                  isDark: isDark,
                ),
                // My Books Tab
                _buildNavItem(
                  icon: Icons.bookmark_rounded,
                  label: 'My Books',
                  index: 1,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build a single navigation item
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? (isDark ? AppColors.secondary : AppColors.primary)
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.secondary : AppColors.primary).withValues(
                  alpha: 0.1,
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
