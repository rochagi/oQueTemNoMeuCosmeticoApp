import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/features/analysis/cubit/analysis_cubit.dart';
import 'package:cosmetic_scanner/features/analysis/cubit/analysis_state.dart';
import 'package:cosmetic_scanner/features/scanner/cubit/scanner_cubit.dart';
import 'package:cosmetic_scanner/features/scanner/cubit/scanner_state.dart';
import 'package:cosmetic_scanner/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:cosmetic_scanner/features/settings/cubit/settings_cubit.dart';
import 'package:cosmetic_scanner/features/settings/cubit/settings_state.dart';

class MockScannerCubit extends Mock implements ScannerCubit {}
class MockAnalysisCubit extends Mock implements AnalysisCubit {}
class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockScannerCubit mockScannerCubit;
  late MockAnalysisCubit mockAnalysisCubit;
  late MockSettingsCubit mockSettingsCubit;

  setUp(() {
    mockScannerCubit = MockScannerCubit();
    mockAnalysisCubit = MockAnalysisCubit();
    mockSettingsCubit = MockSettingsCubit();

    when(() => mockScannerCubit.state).thenReturn(const ScannerInitial());
    when(() => mockScannerCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockAnalysisCubit.state).thenReturn(const AnalysisInitial());
    when(() => mockAnalysisCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockSettingsCubit.state).thenReturn(const SettingsState());
    when(() => mockSettingsCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('ScannerScreen renders header, hero banner and capture buttons', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ScannerCubit>.value(value: mockScannerCubit),
          BlocProvider<AnalysisCubit>.value(value: mockAnalysisCubit),
          BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
        ],
        child: const MaterialApp(
          home: ScannerScreen(),
        ),
      ),
    );

    expect(find.text('O Que Tem No Meu Cosmético?'), findsOneWidget);
    expect(find.text('Tirar Foto (Câmera)'), findsOneWidget);
    expect(find.text('Escolher da Galeria'), findsOneWidget);
    expect(find.text('Digitar Ingredientes Manualmente'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
