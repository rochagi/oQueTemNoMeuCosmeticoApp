import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosmetic_scanner/core/network/api_client.dart';
import 'package:cosmetic_scanner/core/storage/settings_storage.dart';
import 'package:cosmetic_scanner/features/analysis/data/repositories/analysis_repository.dart';
import 'package:cosmetic_scanner/features/scanner/services/image_service.dart';
import 'package:cosmetic_scanner/features/scanner/services/ocr_service.dart';
import 'package:cosmetic_scanner/main.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockAnalysisRepository extends Mock implements AnalysisRepository {}
class MockImageService extends Mock implements ImageService {}
class MockOcrService extends Mock implements OcrService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches smoke test and renders scanner screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final settingsStorage = SettingsStorage();
    final mockApiClient = MockApiClient();
    final mockAnalysisRepo = MockAnalysisRepository();
    final mockImageService = MockImageService();
    final mockOcrService = MockOcrService();

    await tester.pumpWidget(
      CosmeticScannerApp(
        settingsStorage: settingsStorage,
        apiClient: mockApiClient,
        analysisRepository: mockAnalysisRepo,
        imageService: mockImageService,
        ocrService: mockOcrService,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('O Que Tem No Meu Cosmético?'), findsOneWidget);
    expect(find.text('Tirar Foto (Câmera)'), findsOneWidget);
    expect(find.text('Escolher da Galeria'), findsOneWidget);
  });
}
