import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Add/Edit Book Screen
class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bookService = BookService();
  bool _isLoading = false;

  bool get isEditing => widget.book != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.book!.name;
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _descriptionController.text = widget.book!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final book = Book(
        id: widget.book?.id,
        name: _nameController.text.trim(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      Book? result;
      if (isEditing) {
        result = await _bookService.update(widget.book!.id!, book);
      } else {
        result = await _bookService.create(book);
      }

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Book updated successfully'
                  : 'Book added successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to save book');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Book' : 'Add Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              CustomTextField(
                label: 'Book Name',
                hint: 'Enter book name',
                controller: _nameController,
                prefixIcon: Icons.book,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Title Field
              CustomTextField(
                label: 'Title',
                hint: 'Enter book title',
                controller: _titleController,
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Author Field
              CustomTextField(
                label: 'Author',
                hint: 'Enter author name',
                controller: _authorController,
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description Field
              CustomTextField(
                label: 'Description',
                hint: 'Enter book description',
                controller: _descriptionController,
                prefixIcon: Icons.description,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: isEditing ? 'Update Book' : 'Add Book',
                onPressed: _saveBook,
                isLoading: _isLoading,
                icon: isEditing ? Icons.save : Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
