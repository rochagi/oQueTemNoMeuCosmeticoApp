import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/ingredient_detail_model.dart';

void main() {
  group('IngredientDetailModel', () {
    const jsonString = '''
{
  "id": 1,
  "name": "Petrolato / Vaselina",
  "inci_name": "Petrolatum",
  "cas_number": "8009-03-8",
  "function_category": "Emoliente / Oclusivo",
  "description": "Mistura purificada de hidrocarbonetos semi-sólidos obtidos do petróleo.",
  "safety_score": 4.5,
  "origin": "Mineral",
  "is_vegan": true,
  "is_clean_beauty": false,
  "is_microplastic": false,
  "microplastic_risk_level": "none",
  "microplastic_notes": null,
  "is_petroleum_derived": true,
  "is_low_poo_approved": false,
  "is_no_poo_approved": false,
  "petroleum_notes": "Derivado do petróleo com alto poder oclusivo que gera acúmulo (build-up).",
  "carcinogenicity_risk_level": "under_investigation",
  "carcinogenicity_classification": "EU Anexo II",
  "carcinogenicity_notes": "Pode conter impurezas de PAHs se não for altamente refinado.",
  "endocrine_disruptor_risk_level": "none",
  "endocrine_disruptor_mechanism": null,
  "benefits": ["Barreira Oclusiva Intensa", "Prevenção de Ressecamento"],
  "contraindications": ["Peles com acne inflamatória grave", "Adeptos de Low e No Poo"],
  "side_effects": ["Acúmulo nos fios"],
  "max_allowed_concentration": null,
  "regulatory_statuses": [
    {
      "id": 1,
      "region_agency": "Anvisa (Brasil)",
      "status": "allowed",
      "details": "Permitido em cosméticos gerais."
    }
  ],
  "studies": [
    {
      "id": 1,
      "title": "Safety evaluation of mineral hydrocarbons",
      "authors": "Smith et al.",
      "publication_year": 2020,
      "doi_or_url": "https://doi.org/example"
    }
  ],
  "aliases": [
    { "id": 1, "alias_name": "Vaselina" }
  ]
}
''';

    test('parses full ingredient detail JSON correctly', () {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final detail = IngredientDetailModel.fromJson(jsonMap);

      expect(detail.id, equals(1));
      expect(detail.name, equals('Petrolato / Vaselina'));
      expect(detail.inciName, equals('Petrolatum'));
      expect(detail.description, contains('Mistura purificada'));
      expect(detail.safetyScore, equals(4.5));
      expect(detail.origin, equals('Mineral'));
      expect(detail.isPetroleumDerived, isTrue);
      expect(detail.petroleumNotes, contains('build-up'));
      expect(detail.carcinogenicityRiskLevel, equals('under_investigation'));
      expect(detail.carcinogenicityNotes, contains('PAHs'));
      expect(detail.benefits, contains('Barreira Oclusiva Intensa'));
      expect(detail.contraindications, contains('Adeptos de Low e No Poo'));

      // Regulatory statuses
      expect(detail.regulatoryStatuses.length, equals(1));
      expect(detail.regulatoryStatuses.first.regionAgency, equals('Anvisa (Brasil)'));
      expect(detail.regulatoryStatuses.first.status, equals('allowed'));

      // Studies
      expect(detail.studies.length, equals(1));
      expect(detail.studies.first.title, contains('Safety evaluation'));
      expect(detail.studies.first.publicationYear, equals(2020));

      // Safe alternatives logic (for petroleum derived, suggest plant oils)
      expect(detail.suggestedAlternatives, isNotEmpty);
      expect(detail.suggestedAlternatives.first, contains('Manteiga de Karité ou Óleos Vegetais'));
    });
  });
}
