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

    test('extracts text between INGREDIENTES: and the ending period', () {
      const input = '''
MODO DE USO: Aplique nos cabelos úmidos.
PRECAUÇÕES: Manter fora do alcance de crianças.
INGREDIENTES: AQUA, CETEARYL ALCOHOL, DIMETHICONE, GLYCERIN.
INGREDIENTES (PORTUGUÊS): ÁGUA, ÁLCOOL CETEARÍLICO.
SAC: 0800 123 456
''';
      final extracted = TextCleaner.extractIngredientsBlock(input);
      expect(extracted, equals("AQUA, CETEARYL ALCOHOL, DIMETHICONE, GLYCERIN."));
    });

    test('extracts text starting from COMPOSIÇÃO: when no period exists before next section', () {
      const input = '''
COMBINAÇÃO EXCLUSIVA PARA BRILHO
COMPOSIÇÃO: AQUA, GLYCERIN, PARFUM
MODO DE USAR: Enxágue bem.
''';
      final extracted = TextCleaner.extractIngredientsBlock(input);
      expect(extracted, equals("AQUA, GLYCERIN, PARFUM"));
    });

    test('falls back to raw text when no ingredient header is present', () {
      const input = "AQUA, CETEARYL ALCOHOL, DIMETHICONE";
      final extracted = TextCleaner.extractIngredientsBlock(input);
      expect(extracted, equals("AQUA, CETEARYL ALCOHOL, DIMETHICONE"));
    });

    test('clean() applies extractIngredientsBlock automatically when header is present', () {
      const input = '''
MODO DE USO: Aplique nos cabelos.
INGREDIENTES: AQUA, \n CETEARYL ALCOHOL, \n GLYCERIN.
PRECAUÇÕES: Uso externo.
''';
      final cleaned = TextCleaner.clean(input);
      expect(cleaned, equals("AQUA, CETEARYL ALCOHOL, GLYCERIN."));
    });
  });
}
