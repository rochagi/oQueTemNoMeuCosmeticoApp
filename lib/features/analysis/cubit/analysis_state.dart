import 'package:equatable/equatable.dart';
import '../data/models/analysis_result_model.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisLoading extends AnalysisState {
  const AnalysisLoading();
}

class AnalysisSuccess extends AnalysisState {
  final AnalysisResultModel result;

  const AnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class AnalysisFailure extends AnalysisState {
  final String errorMessage;

  const AnalysisFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
