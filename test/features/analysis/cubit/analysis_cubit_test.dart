import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/core/network/api_exceptions.dart';
import 'package:cosmetic_scanner/features/analysis/cubit/analysis_cubit.dart';
import 'package:cosmetic_scanner/features/analysis/cubit/analysis_state.dart';
import 'package:cosmetic_scanner/features/analysis/data/models/analysis_result_model.dart';
import 'package:cosmetic_scanner/features/analysis/data/repositories/analysis_repository.dart';

class MockAnalysisRepository extends Mock implements AnalysisRepository {}

void main() {
  late MockAnalysisRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalysisRepository();
  });

  const mockResult = AnalysisResultModel(
    score: 80,
    ratingLabel: 'Excelente / Altamente Seguro',
    ratingColorHex: '#10B981',
  );

  group('AnalysisCubit', () {
    test('initial state is AnalysisInitial', () {
      final cubit = AnalysisCubit(repository: mockRepository);
      expect(cubit.state, equals(const AnalysisInitial()));
      cubit.close();
    });

    blocTest<AnalysisCubit, AnalysisState>(
      'emits [AnalysisLoading, AnalysisSuccess] when analyze succeeds',
      build: () {
        when(() => mockRepository.analyzeFormula(any()))
            .thenAnswer((_) async => mockResult);
        return AnalysisCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.analyze('AQUA, GLYCERIN'),
      expect: () => [
        const AnalysisLoading(),
        const AnalysisSuccess(mockResult),
      ],
    );

    blocTest<AnalysisCubit, AnalysisState>(
      'emits [AnalysisLoading, AnalysisFailure] when analyze throws ApiException',
      build: () {
        when(() => mockRepository.analyzeFormula(any()))
            .thenThrow(ApiException('Falha ao analisar'));
        return AnalysisCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.analyze('INVALID'),
      expect: () => [
        const AnalysisLoading(),
        const AnalysisFailure('Falha ao analisar'),
      ],
    );

    blocTest<AnalysisCubit, AnalysisState>(
      'emits [AnalysisLoading, AnalysisFailure] when analyze throws NetworkException',
      build: () {
        when(() => mockRepository.analyzeFormula(any()))
            .thenThrow(NetworkException('Sem conexão'));
        return AnalysisCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.analyze('AQUA'),
      expect: () => [
        const AnalysisLoading(),
        const AnalysisFailure('Sem conexão'),
      ],
    );
  });
}
