import 'package:flutter_test/flutter_test.dart';
import 'package:cosmetic_scanner/core/utils/text_cleaner.dart';

void main() {
  group('TextCleaner', () {
    test('removes excess newlines and normalizes whitespace', () {
      const input = "AQUA  /  WATER,\n\n  GLYCERIN,\r\n\r\nNIACINAMIDE.";
      final cleaned = TextCleaner.clean(input);
      expect(cleaned, equals("AQUA / WATER, GLYCERIN, NIACINAMIDE."));
    });

    test('preserves commas, slashes, and periods while trimming outer space', () {
      const input = "  Petrolatum, Paraffinum Liquidum / Mineral Oil.  ";
      final cleaned = TextCleaner.clean(input);
      expect(cleaned, equals("Petrolatum, Paraffinum Liquidum / Mineral Oil."));
    });

    test('handles empty or whitespace only text gracefully', () {
      expect(TextCleaner.clean("   "), equals(""));
      expect(TextCleaner.clean(""), equals(""));
    });

    test('removes non-printable OCR noise characters', () {
      const input = "AQUA,\u0000\u0007 CARBOMER,\uFFFD PHENOXYETHANOL";
      final cleaned = TextCleaner.clean(input);
      expect(cleaned, equals("AQUA, CARBOMER, PHENOXYETHANOL"));
    });
  });
}
