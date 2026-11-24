import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_exceptions.dart';
import '../data/repositories/analysis_repository.dart';
import 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final AnalysisRepository _repository;

  AnalysisCubit({AnalysisRepository? repository})
      : _repository = repository ?? AnalysisRepository(),
        super(const AnalysisInitial());

  Future<void> analyze(String rawText) async {
    emit(const AnalysisLoading());
    try {
      final result = await _repository.analyzeFormula(rawText);
      emit(AnalysisSuccess(result));
    } on ApiException catch (e) {
      emit(AnalysisFailure(e.message));
    } catch (e) {
      emit(AnalysisFailure('Erro ao analisar os ingredientes: $e'));
    }
  }

  void reset() {
    emit(const AnalysisInitial());
  }
}
