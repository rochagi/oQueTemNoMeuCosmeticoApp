import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/ingredient_detail_model.dart';
import 'package:cosmetic_scanner/features/analysis/data/repositories/analysis_repository.dart';
import 'package:cosmetic_scanner/features/analysis/presentation/widgets/ingredient_detail_sheet.dart';

class MockAnalysisRepository extends Mock implements AnalysisRepository {}

void main() {
  late MockAnalysisRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalysisRepository();
  });

  const mockDetail = IngredientDetailModel(
    id: 1,
    name: 'Petrolato / Vaselina',
    inciName: 'Petrolatum',
    functionCategory: 'Emoliente / Oclusivo',
    description: 'Mistura purificada de hidrocarbonetos semi-sólidos obtidos do petróleo.',
    safetyScore: 4.5,
    origin: 'Mineral',
    isPetroleumDerived: true,
    petroleumNotes: 'Alto poder oclusivo que gera acúmulo (build-up) nos fios.',
    benefits: ['Barreira Oclusiva Intensa'],
    contraindications: ['Adeptos de Low e No Poo'],
    regulatoryStatuses: [
      RegulatoryStatusModel(
        id: 1,
        regionAgency: 'Anvisa (Brasil)',
        status: 'allowed',
        details: 'Permitido em cosméticos gerais.',
      ),
    ],
    studies: [
      StudyModel(
        id: 1,
        title: 'Safety assessment of petrolatum in cosmetic products',
        authors: 'Johnson et al.',
        publicationYear: 2021,
      ),
    ],
  );

  testWidgets('IngredientDetailSheet displays full technical details, mechanism, studies, and alternatives', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    when(() => mockRepository.getIngredientDetails(1))
        .thenAnswer((_) async => mockDetail);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientDetailSheet(
            ingredientId: 1,
            fallbackName: 'Petrolato / Vaselina',
            repository: mockRepository,
          ),
        ),
      ),
    );

    // Initial loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Settle async future
    await tester.pumpAndSettle();

    // Verify header
    expect(find.text('Petrolato / Vaselina'), findsOneWidget);
    expect(find.text('INCI: Petrolatum'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);

    // Verify mechanism & red flags
    expect(find.text('Mecanismo de Ação e Riscos'), findsOneWidget);
    expect(find.textContaining('build-up'), findsOneWidget);

    // Verify regulatory status
    expect(find.text('Status Regulatório'), findsOneWidget);
    expect(find.text('Anvisa (Brasil)'), findsOneWidget);

    // Verify scientific studies
    expect(find.text('Evidências & Estudos Científicos'), findsOneWidget);
    expect(find.text('Safety assessment of petrolatum in cosmetic products'), findsOneWidget);

    // Verify clean alternatives
    expect(find.text('Alternativas Seguras e Limpas'), findsOneWidget);
    expect(find.textContaining('Manteiga de Karité ou Óleos Vegetais'), findsOneWidget);
  });
}
