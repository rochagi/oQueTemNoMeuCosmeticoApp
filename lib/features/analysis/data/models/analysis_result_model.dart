import 'package:equatable/equatable.dart';
import 'badges_model.dart';
import 'mapped_ingredient_model.dart';

class AnalysisResultModel extends Equatable {
  final int score;
  final String ratingLabel;
  final String ratingColorHex;
  final int totalDetected;
  final int totalMapped;
  final int totalUnmapped;
  final BadgesModel badges;
  final List<String> criticalAlerts;
  final List<MappedIngredientModel> mappedIngredients;
  final List<String> unmappedIngredients;

  const AnalysisResultModel({
    required this.score,
    this.ratingLabel = 'Avaliação Indisponível',
    this.ratingColorHex = '#14B8A6',
    this.totalDetected = 0,
    this.totalMapped = 0,
    this.totalUnmapped = 0,
    this.badges = const BadgesModel(),
    this.criticalAlerts = const [],
    this.mappedIngredients = const [],
    this.unmappedIngredients = const [],
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    final mappedList = (json['mapped_ingredients'] as List<dynamic>?)
            ?.map((e) => MappedIngredientModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final unmappedList = (json['unmapped_ingredients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final alertsList = (json['critical_alerts'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return AnalysisResultModel(
      score: json['score'] as int? ?? 0,
      ratingLabel: json['rating_label'] as String? ?? 'Avaliação Indisponível',
      ratingColorHex: json['rating_color'] as String? ?? '#14B8A6',
      totalDetected: json['total_detected'] as int? ?? 0,
      totalMapped: json['total_mapped'] as int? ?? mappedList.length,
      totalUnmapped: json['total_unmapped'] as int? ?? unmappedList.length,
      badges: BadgesModel.fromJson(json['badges'] as Map<String, dynamic>?),
      criticalAlerts: alertsList,
      mappedIngredients: mappedList,
      unmappedIngredients: unmappedList,
    );
  }

  @override
  List<Object?> get props => [
    score,
    ratingLabel,
    ratingColorHex,
    totalDetected,
    totalMapped,
    totalUnmapped,
    badges,
    criticalAlerts,
    mappedIngredients,
    unmappedIngredients,
  ];
}
