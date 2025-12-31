import 'package:flutter/material.dart';

/// App Color Palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color secondary = Color(0xFFA29BFE);

  // Status Colors
  static const Color success = Color(0xFF00D9A5);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFD93D);
  static const Color info = Color(0xFF4FACFE);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0F0F23);
  static const Color backgroundLight = Color(0xFFF8F9FA);

  // Surface Colors
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF2D3436);
  static const Color textSecondaryDark = Color(0xFFB2BEC3);
  static const Color textSecondaryLight = Color(0xFF636E72);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
