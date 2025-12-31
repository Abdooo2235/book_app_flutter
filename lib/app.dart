import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';

/// Main App Widget - Entry point of the application
class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App name
      title: 'BookShelf',

      // Hide debug banner
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme, // Light mode theme
      darkTheme: AppTheme.darkTheme, // Dark mode theme
      themeMode: ThemeMode.system, // Auto switch based on system preference
      // Starting screen
      initialRoute: '/',

      // App Routes (navigation paths)
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen
        '/home': (context) => const HomeScreen(), // Main home screen
      },
    );
  }
}
