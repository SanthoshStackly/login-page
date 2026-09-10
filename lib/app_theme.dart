import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkNavy = Color(0xFF0D1B3E);
  static const Color lightBlue = Color(0xFF2E86F5);
  static const Color skyBlue = Color(0xFF64B5F6);

  static const Color background = Colors.white;
  static const Color surfaceGrey = Color(0xFFF5F7FA);
  static const Color borderGrey = Color(0xFFE0E4EA);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF6B7280);
}

class UserSession {
  static String name = 'User';
  static String email = '';

  static String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
