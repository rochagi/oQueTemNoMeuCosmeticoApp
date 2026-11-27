import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/analysis_result_model.dart';

void main() {
  group('AnalysisResultModel', () {
    const jsonString = '''
{
  "score": 68,
  "rating_label": "Bom / Seguro",
  "rating_color": "#14B8A6",
  "total_detected": 5,
  "total_mapped": 4,
  "total_unmapped": 1,
  "badges": {
    "is_vegan": true,
    "is_clean_beauty": false,
    "is_microplastic_free": false,
    "is_petroleum_free": false,
    "is_low_poo_approved": false,
    "is_no_poo_approved": false
  },
  "critical_alerts": [
    "Derivado de Petroleo: Petrolato pode acumular",
    "Rotina Capilar: Petrolato e proibido para Low Poo",
    "Microplastico: Carbomer e persistente"
  ],
  "mapped_ingredients": [
    {
      "id": 10,
      "matched_term": "AQUA",
      "name": "Aqua",
      "inci_name": "Aqua",
      "cas_number": "7732-18-5",
      "function_category": "Solvente",
      "safety_score": 10.0,
      "comedogenic_rating": 0,
      "irritation_rating": 0,
      "is_vegan": true,
      "is_clean_beauty": true,
      "is_microplastic": false,
      "is_petroleum_derived": false,
      "is_low_poo_approved": true,
      "is_no_poo_approved": true,
      "carcinogenicity_risk_level": "none",
      "endocrine_disruptor_risk_level": "none"
    },
    {
      "id": 1,
      "matched_term": "VASELINA",
      "name": "Petrolato / Vaselina",
      "inci_name": "Petrolatum",
      "cas_number": "8009-03-8",
      "function_category": "Emoliente / Oclusivo",
      "safety_score": 4.5,
      "is_petroleum_derived": true,
      "is_low_poo_approved": false,
      "is_no_poo_approved": false
    }
  ],
  "unmapped_ingredients": [
    "PHENOXYETHANOL"
  ]
}
''';

    test('parses complete API json payload successfully', () {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final result = AnalysisResultModel.fromJson(jsonMap);

      expect(result.score, equals(68));
      expect(result.ratingLabel, equals('Bom / Seguro'));
      expect(result.ratingColorHex, equals('#14B8A6'));
      expect(result.totalDetected, equals(5));
      expect(result.totalMapped, equals(4));
      expect(result.totalUnmapped, equals(1));

      // Badges
      expect(result.badges.isVegan, isTrue);
      expect(result.badges.isCleanBeauty, isFalse);
      expect(result.badges.isMicroplasticFree, isFalse);
      expect(result.badges.isPetroleumFree, isFalse);
      expect(result.badges.isLowPooApproved, isFalse);
      expect(result.badges.isNoPooApproved, isFalse);

      // Alerts
      expect(result.criticalAlerts.length, equals(3));
      expect(result.criticalAlerts.first, contains('Petrolato'));

      // Mapped Ingredients
      expect(result.mappedIngredients.length, equals(2));
      final aqua = result.mappedIngredients[0];
      expect(aqua.id, equals(10));
      expect(aqua.name, equals('Aqua'));
      expect(aqua.inciName, equals('Aqua'));
      expect(aqua.safetyScore, equals(10.0));
      expect(aqua.functionCategory, equals('Solvente'));
      expect(aqua.isVegan, isTrue);

      final vaselina = result.mappedIngredients[1];
      expect(vaselina.id, equals(1));
      expect(vaselina.name, equals('Petrolato / Vaselina'));
      expect(vaselina.safetyScore, equals(4.5));
      expect(vaselina.isPetroleumDerived, isTrue);
      expect(vaselina.hasRedflags, isTrue);
      expect(vaselina.redflags, contains('Derivado de Petróleo'));

      // Unmapped Ingredients
      expect(result.unmappedIngredients, equals(['PHENOXYETHANOL']));
    });

    test('parses quick lightweight payload with has_redflags and redflags array correctly', () {
      final quickJson = {
        'score': 68,
        'rating_label': 'Atenção Moderada',
        'rating_color': '#F59E0B',
        'total_detected': 2,
        'total_mapped': 2,
        'total_unmapped': 0,
        'badges': {
          'is_vegan': true,
          'is_clean_beauty': false,
          'is_microplastic_free': false,
          'is_petroleum_free': false,
          'is_low_poo_approved': false,
          'is_no_poo_approved': false,
        },
        'critical_alerts': [
          '🛢️ Contém Derivado de Petróleo (Petrolatum)',
        ],
        'mapped_ingredients': [
          {
            'id': 10,
            'matched_term': 'AQUA',
            'name': 'Aqua',
            'inci_name': 'Aqua',
            'safety_score': 10.0,
            'has_redflags': false,
            'redflags': <String>[],
          },
          {
            'id': 1,
            'matched_term': 'VASELINA',
            'name': 'Petrolato / Vaselina',
            'inci_name': 'Petrolatum',
            'safety_score': 4.5,
            'has_redflags': true,
            'redflags': ['Derivado de Petróleo', 'Proibido Low/No Poo'],
          },
        ],
        'unmapped_ingredients': <String>[],
      };

      final result = AnalysisResultModel.fromJson(quickJson);
      expect(result.score, equals(68));
      expect(result.mappedIngredients.length, equals(2));
      expect(result.mappedIngredients[0].hasRedflags, isFalse);
      expect(result.mappedIngredients[0].redflags, isEmpty);
      expect(result.mappedIngredients[1].hasRedflags, isTrue);
      expect(result.mappedIngredients[1].redflags, equals(['Derivado de Petróleo', 'Proibido Low/No Poo']));
    });

    test('handles missing or nullable fields gracefully with safe fallbacks', () {
      final emptyJson = <String, dynamic>{
        'score': 50,
      };

      final result = AnalysisResultModel.fromJson(emptyJson);
      expect(result.score, equals(50));
      expect(result.ratingLabel, equals('Avaliação Indisponível'));
      expect(result.ratingColorHex, equals('#14B8A6'));
      expect(result.totalDetected, equals(0));
      expect(result.criticalAlerts, isEmpty);
      expect(result.mappedIngredients, isEmpty);
      expect(result.unmappedIngredients, isEmpty);
      expect(result.badges.isVegan, isFalse);
    });
  });
}
