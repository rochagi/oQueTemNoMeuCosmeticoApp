import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF0D9488); // Teal 600
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFFCCFBF1);
  static const Color accent = Color(0xFF059669); // Emerald 600

  // Background & surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Score colors (matching API docs: 80-100, 60-79, 40-59, 0-39)
  static const Color scoreExcellent = Color(0xFF10B981); // Emerald 500
  static const Color scoreGood = Color(0xFF14B8A6);      // Teal 500
  static const Color scoreWarning = Color(0xFFF59E0B);   // Amber 500
  static const Color scoreDanger = Color(0xFFEF4444);    // Red 500

  static Color scoreColor(int score) {
    if (score >= 80) return scoreExcellent;
    if (score >= 60) return scoreGood;
    if (score >= 40) return scoreWarning;
    return scoreDanger;
  }

  static Color fromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      var clean = hexString.replaceAll('#', '').trim();
      if (clean.length == 6) {
        buffer.write('ff$clean');
        return Color(int.parse(buffer.toString(), radix: 16));
      } else if (clean.length == 8) {
        buffer.write(clean);
        return Color(int.parse(buffer.toString(), radix: 16));
      }
      return primary;
    } catch (_) {
      return primary;
    }
  }
}
