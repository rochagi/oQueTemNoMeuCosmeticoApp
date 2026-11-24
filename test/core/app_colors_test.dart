import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmetic_scanner/core/constants/app_colors.dart';

void main() {
  group('AppColors', () {
    test('scoreColor returns correct color for 80-100 (Excelente)', () {
      expect(AppColors.scoreColor(100), equals(const Color(0xFF10B981)));
      expect(AppColors.scoreColor(80), equals(const Color(0xFF10B981)));
    });

    test('scoreColor returns correct color for 60-79 (Bom)', () {
      expect(AppColors.scoreColor(79), equals(const Color(0xFF14B8A6)));
      expect(AppColors.scoreColor(60), equals(const Color(0xFF14B8A6)));
    });

    test('scoreColor returns correct color for 40-59 (Atenção)', () {
      expect(AppColors.scoreColor(59), equals(const Color(0xFFF59E0B)));
      expect(AppColors.scoreColor(40), equals(const Color(0xFFF59E0B)));
    });

    test('scoreColor returns correct color for 0-39 (Risco Alto)', () {
      expect(AppColors.scoreColor(39), equals(const Color(0xFFEF4444)));
      expect(AppColors.scoreColor(0), equals(const Color(0xFFEF4444)));
    });

    test('fromHex parses 6-character and 7-character hex string correctly', () {
      expect(AppColors.fromHex('#10B981'), equals(const Color(0xFF10B981)));
      expect(AppColors.fromHex('10B981'), equals(const Color(0xFF10B981)));
      expect(AppColors.fromHex('#EF4444'), equals(const Color(0xFFEF4444)));
    });

    test('fromHex fallback on invalid string returns default primary color', () {
      expect(AppColors.fromHex('invalid'), equals(AppColors.primary));
    });
  });
}
