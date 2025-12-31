# 📚 Book Manager - Flutter App

A modern, feature-rich Flutter application for managing your book collection. Built with a clean architecture and integrated with a .NET Web API backend.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- 📖 **Browse Books** - View all available books in a beautiful grid layout
- ➕ **Add Books** - Create new book entries with title, author, and description
- ✏️ **Edit Books** - Update book information easily
- 🗑️ **Delete Books** - Remove books from the collection
- 🔖 **My Books** - Save books to your personal collection
- 🔍 **Search** - Find books by title, author, or name
- 🌙 **Dark Mode** - Beautiful dark theme enabled by default
- 📱 **Responsive** - Works on Android, iOS, Web, and Desktop

## 📸 Screenshots

|           Books List            |          Book Details           |          Add Book          |
| :-----------------------------: | :-----------------------------: | :------------------------: |
| Modern grid with gradient cards | Full book info with save option | Clean form with validation |

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # MaterialApp configuration
├── config/
│   ├── api_config.dart       # API endpoints & base URL
│   └── app_routes.dart       # Navigation routes
├── models/
│   ├── book.dart             # Book data model
│   ├── user.dart             # User data model
│   └── user_book.dart        # User-Book relationship model
├── screens/
│   ├── home/
│   │   └── home_screen.dart  # Main navigation hub
│   ├── books/
│   │   ├── books_list_screen.dart    # Books grid view
│   │   ├── book_detail_screen.dart   # Book details page
│   │   └── add_edit_book_screen.dart # Create/Edit form
│   ├── my_books/
│   │   └── my_books_screen.dart      # User's saved books
│   └── splash/
│       └── splash_screen.dart        # Loading screen
├── services/
│   ├── api_service.dart      # HTTP client wrapper
│   ├── book_service.dart     # Book CRUD operations
│   └── user_book_service.dart # User-Book management
├── theme/
│   ├── app_colors.dart       # Color palette
│   └── app_theme.dart        # Light & Dark themes
└── widgets/
    ├── cards/
    │   └── book_card.dart    # Modern book card widget
    ├── common/
    │   ├── custom_button.dart
    │   ├── custom_text_field.dart
    │   ├── empty_state.dart
    │   └── loading_indicator.dart
    └── dialogs/
        └── confirm_dialog.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- .NET Web API Backend (running on port 5101)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Abdooo2235/book_app_flutter.git
   cd book_app_flutter
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API URL**

   Edit `lib/config/api_config.dart` and set your backend URL:

   ```dart
   static const String baseUrl = 'http://YOUR_IP:5101';
   ```

   - For Android Emulator: `http://10.0.2.2:5101`
   - For Physical Device: `http://YOUR_WIFI_IP:5101`
   - For Web/Desktop: `http://localhost:5101`

4. **Run the app**

   ```bash
   # Run on connected device
   flutter run

   # Run on specific platform
   flutter run -d chrome      # Web
   flutter run -d windows     # Windows Desktop
   flutter run -d android     # Android
   ```

## 🔌 API Endpoints

The app connects to a .NET Web API with the following endpoints:

| Method | Endpoint             | Description                     |
| ------ | -------------------- | ------------------------------- |
| GET    | `/api/book`          | Get all books                   |
| GET    | `/api/book/{id}`     | Get book by ID                  |
| POST   | `/api/book`          | Create new book                 |
| PUT    | `/api/book/{id}`     | Update book                     |
| DELETE | `/api/book/{id}`     | Delete book                     |
| GET    | `/api/userbook`      | Get all user-book relationships |
| POST   | `/api/userbook`      | Add book to user's collection   |
| DELETE | `/api/userbook/{id}` | Remove from collection          |

## 📦 Dependencies

| Package                | Version | Purpose              |
| ---------------------- | ------- | -------------------- |
| `http`                 | ^1.2.0  | HTTP requests to API |
| `provider`             | ^6.1.1  | State management     |
| `google_fonts`         | ^6.1.0  | Custom typography    |
| `cached_network_image` | ^3.3.1  | Image caching        |
| `shimmer`              | ^3.0.0  | Loading effects      |
| `shared_preferences`   | ^2.2.2  | Local storage        |
| `intl`                 | ^0.19.0 | Internationalization |

## 🎨 Design Features

- **Modern UI** - Glassmorphism-inspired cards with gradient backgrounds
- **Dynamic Colors** - Each book card gets a unique gradient based on ID
- **Smooth Animations** - Micro-interactions and transitions
- **Responsive Layout** - Adapts to different screen sizes
- **Dark Theme** - Eye-friendly dark mode as default

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 👥 Authors

- **Abdoo** - _Initial work_ - [Abdooo2235](https://github.com/Abdooo2235)
- **Eslam** - _UI/UX Development_

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ using Flutter
</p>
