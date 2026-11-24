import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/core/network/api_client.dart';
import 'package:cosmetic_scanner/core/network/api_exceptions.dart';
import 'package:cosmetic_scanner/core/storage/settings_storage.dart';
import 'package:cosmetic_scanner/features/analysis/data/repositories/analysis_repository.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockSettingsStorage extends Mock implements SettingsStorage {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockSettingsStorage mockSettingsStorage;
  late ApiClient apiClient;
  late AnalysisRepository repository;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://localhost'));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSettingsStorage = MockSettingsStorage();
    when(() => mockSettingsStorage.getBaseUrl())
        .thenAnswer((_) async => 'http://127.0.0.1:8000/api');

    apiClient = ApiClient(client: mockHttpClient, storage: mockSettingsStorage);
    repository = AnalysisRepository(apiClient: apiClient);
  });

  group('AnalysisRepository', () {
    const mockSuccessResponse = '''
{
  "score": 85,
  "rating_label": "Excelente / Altamente Seguro",
  "rating_color": "#10B981",
  "total_detected": 1,
  "total_mapped": 1,
  "total_unmapped": 0,
  "badges": {"is_vegan": true},
  "critical_alerts": [],
  "mapped_ingredients": [
    {
      "id": 1,
      "matched_term": "AQUA",
      "name": "Aqua",
      "inci_name": "Aqua",
      "safety_score": 10.0
    }
  ],
  "unmapped_ingredients": []
}
''';

    test('analyzeFormula calls /analyze/quick and returns AnalysisResultModel on 200 OK', () async {
      when(() => mockHttpClient.post(
            any(that: predicate<Uri>((uri) => uri.path.endsWith('/analyze/quick'))),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(mockSuccessResponse, 200));

      final result = await repository.analyzeFormula('AQUA');

      expect(result.score, equals(85));
      expect(result.ratingLabel, equals('Excelente / Altamente Seguro'));
      expect(result.mappedIngredients.length, equals(1));
      expect(result.mappedIngredients.first.name, equals('Aqua'));
    });

    test('getIngredientDetails calls /ingredients/{id} and returns IngredientDetailModel', () async {
      const mockDetailResponse = '''
{
  "id": 1,
  "name": "Petrolato / Vaselina",
  "inci_name": "Petrolatum",
  "function_category": "Emoliente / Oclusivo",
  "description": "Mistura purificada de hidrocarbonetos semi-sólidos obtidos do petróleo.",
  "safety_score": 4.5,
  "is_petroleum_derived": true,
  "petroleum_notes": "Gera acúmulo build-up.",
  "benefits": ["Oclusão"],
  "contraindications": ["Low Poo"],
  "regulatory_statuses": [],
  "studies": []
}
''';

      when(() => mockHttpClient.get(
            any(that: predicate<Uri>((uri) => uri.path.endsWith('/ingredients/1'))),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(mockDetailResponse, 200));

      final detail = await repository.getIngredientDetails(1);

      expect(detail.id, equals(1));
      expect(detail.name, equals('Petrolato / Vaselina'));
      expect(detail.isPetroleumDerived, isTrue);
      expect(detail.petroleumNotes, contains('build-up'));
    });

    test('analyzeFormula throws ApiException on 422 Unprocessable Entity', () async {
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('{"message": "Dados inválidos"}', 422));

      expect(
        () => repository.analyzeFormula(''),
        throwsA(isA<ApiException>()),
      );
    });

    test('analyzeFormula throws NetworkException on connection failure', () async {
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(http.ClientException('Falha de conexão'));

      expect(
        () => repository.analyzeFormula('AQUA'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
