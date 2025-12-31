import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../theme/app_colors.dart';

/// Modern Book Card Widget with clean UI/UX
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  /// Get gradient colors based on book ID for consistency
  static List<Color> getBookGradient(int id) {
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)], // Purple-Blue
      [const Color(0xFF11998E), const Color(0xFF38EF7D)], // Teal-Green
      [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)], // Coral-Yellow
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)], // Blue-Cyan
      [const Color(0xFFF093FB), const Color(0xFFF5576C)], // Pink-Red
      [const Color(0xFF5EE7DF), const Color(0xFFB490CA)], // Teal-Purple
      [const Color(0xFFFA709A), const Color(0xFFFEE140)], // Pink-Yellow
      [const Color(0xFF30CFD0), const Color(0xFF330867)], // Cyan-Purple
    ];
    return gradients[id % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover with Gradient
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: getBookGradient(book.id ?? 0),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Decorative circles
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -15,
                            bottom: -15,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                          ),
                          // Book Icon
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.auto_stories_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Book Info Section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            book.title.isNotEmpty ? book.title : book.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            book.author,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Action Menu (Three dots)
              if (showActions)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildActionMenu(context, isDark),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF2A2A3E) : Colors.white,
      elevation: 8,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                'Edit',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
    );
  }
}
