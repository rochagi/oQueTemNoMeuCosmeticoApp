import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/analysis_result_model.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/badges_model.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/mapped_ingredient_model.dart';
import 'package:cosmetic_scanner/features/analysis/presentation/screens/result_screen.dart';

void main() {
  const mockResult = AnalysisResultModel(
    score: 68,
    ratingLabel: 'Bom / Seguro',
    ratingColorHex: '#14B8A6',
    totalDetected: 2,
    totalMapped: 1,
    totalUnmapped: 1,
    badges: BadgesModel(
      isVegan: true,
      isCleanBeauty: false,
      isMicroplasticFree: true,
      isPetroleumFree: false,
      isLowPooApproved: true,
      isNoPooApproved: true,
    ),
    criticalAlerts: [
      'Alerta: Petrolato presente na fórmula',
    ],
    mappedIngredients: [
      MappedIngredientModel(
        id: 10,
        matchedTerm: 'AQUA',
        name: 'Aqua / Água Purificada',
        inciName: 'Aqua',
        functionCategory: 'Solvente',
        safetyScore: 10.0,
      ),
    ],
    unmappedIngredients: [
      'NOVO_COMPONENTE_XYZ',
    ],
  );

  testWidgets('ResultScreen displays score hero, badges, critical alerts, and ingredients', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ResultScreen(result: mockResult),
      ),
    );

    // Score & rating label
    expect(find.text('68'), findsOneWidget);
    expect(find.text('Bom / Seguro'), findsOneWidget);

    // Badges
    expect(find.text('Vegano'), findsOneWidget);
    expect(find.text('Low Poo'), findsOneWidget);

    // Critical alert
    expect(find.text('Alerta: Petrolato presente na fórmula'), findsOneWidget);

    // Mapped ingredient
    expect(find.text('Aqua / Água Purificada'), findsOneWidget);
    expect(find.text('10.0'), findsOneWidget);

    // Unmapped ingredient
    expect(find.text('NOVO_COMPONENTE_XYZ'), findsOneWidget);

    // Back / Scan another button
    expect(find.text('Escanear Outro Produto'), findsOneWidget);

    // Expand ingredient tile
    await tester.tap(find.text('Aqua / Água Purificada'));
    await tester.pumpAndSettle();

    expect(find.text('Ver Ficha Completa (Mecanismos & Estudos)'), findsOneWidget);
  });
}
