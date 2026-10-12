import 'package:flutter/material.dart';

class AppColors {
  // --- Legacy tokens (kept so existing dashboard/screens keep working) ---
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkNavy = Color(0xFF0D1B3E);
  static const Color lightBlue = Color(0xFF2E86F5);
  static const Color skyBlue = Color(0xFF64B5F6);
  static const Color background = Colors.white;
  static const Color surfaceGrey = Color(0xFFF5F7FA);
  static const Color borderGrey = Color(0xFFE0E4EA);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF6B7280);

  // --- New Enterprise Design System tokens ---
  // Ink: authority / security context (auth screens, admin chrome)
  static const Color ink = Color(0xFF0F1330);
  static const Color ink2 = Color(0xFF1B1042);
  static const Color ink3 = Color(0xFF232A9C);

  // Accents - used sparingly against the neutral surface
  static const Color amberAI = Color(0xFFEBA32D); // AI / intelligent automation
  static const Color tealData = Color(0xFF4FDFC5); // connectivity / live data

  // Surface & text
  static const Color paper = Color(0xFFFFFFFF);
  static const Color paperDim = Color(0xFFF4F5F7);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textInk = Color(0xFF14171F);
  static const Color textMuted = Color(0xFF6B7280);

  // Semantic (status & alerts)
  static const Color success = Color(0xFF2E9E58);
  static const Color danger = Color(0xFFD14343);
  static const Color info = Color(0xFF2F6FE0);
  static const Color warning = Color(0xFFC8862A);
}

class UserSession {
  static String name = 'User';
  static String email = '';
  static String workspace = '';

  static String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
