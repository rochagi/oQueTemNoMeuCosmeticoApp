import 'package:equatable/equatable.dart';

class MappedIngredientModel extends Equatable {
  final int id;
  final String matchedTerm;
  final String name;
  final String inciName;
  final String? casNumber;
  final String? functionCategory;
  final double safetyScore;
  final bool hasRedflags;
  final List<String> redflags;
  final int comedogenicRating;
  final int irritationRating;
  final bool isVegan;
  final bool isCleanBeauty;
  final bool isMicroplastic;
  final bool isPetroleumDerived;
  final bool isLowPooApproved;
  final bool isNoPooApproved;
  final String? carcinogenicityRiskLevel;
  final String? endocrineDisruptorRiskLevel;

  const MappedIngredientModel({
    required this.id,
    required this.matchedTerm,
    required this.name,
    required this.inciName,
    this.casNumber,
    this.functionCategory,
    this.safetyScore = 5.0,
    this.hasRedflags = false,
    this.redflags = const [],
    this.comedogenicRating = 0,
    this.irritationRating = 0,
    this.isVegan = false,
    this.isCleanBeauty = false,
    this.isMicroplastic = false,
    this.isPetroleumDerived = false,
    this.isLowPooApproved = true,
    this.isNoPooApproved = true,
    this.carcinogenicityRiskLevel,
    this.endocrineDisruptorRiskLevel,
  });

  factory MappedIngredientModel.fromJson(Map<String, dynamic> json) {
    final parsedRedflags = (json['redflags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [
          if (json['is_petroleum_derived'] == true) 'Derivado de Petróleo',
          if (json['is_microplastic'] == true) 'Microplástico',
          if (json['is_low_poo_approved'] == false || json['is_no_poo_approved'] == false)
            'Proibido Low/No Poo',
          if (json['carcinogenicity_risk_level'] == 'confirmed') 'Carcinogênico Confirmado',
          if (json['carcinogenicity_risk_level'] == 'suspected') 'Suspeita Carcinogênica',
          if (json['endocrine_disruptor_risk_level'] == 'high' ||
              json['endocrine_disruptor_risk_level'] == 'confirmed')
            'Disruptor Endócrino',
        ];

    final hasFlags = json['has_redflags'] as bool? ?? parsedRedflags.isNotEmpty;

    return MappedIngredientModel(
      id: json['id'] as int? ?? 0,
      matchedTerm: json['matched_term'] as String? ?? '',
      name: json['name'] as String? ?? 'Ingrediente',
      inciName: json['inci_name'] as String? ?? '',
      casNumber: json['cas_number'] as String?,
      functionCategory: json['function_category'] as String?,
      safetyScore: (json['safety_score'] as num?)?.toDouble() ?? 5.0,
      hasRedflags: hasFlags,
      redflags: parsedRedflags,
      comedogenicRating: json['comedogenic_rating'] as int? ?? 0,
      irritationRating: json['irritation_rating'] as int? ?? 0,
      isVegan: json['is_vegan'] as bool? ?? false,
      isCleanBeauty: json['is_clean_beauty'] as bool? ?? false,
      isMicroplastic: json['is_microplastic'] as bool? ?? false,
      isPetroleumDerived: json['is_petroleum_derived'] as bool? ?? false,
      isLowPooApproved: json['is_low_poo_approved'] as bool? ?? true,
      isNoPooApproved: json['is_no_poo_approved'] as bool? ?? true,
      carcinogenicityRiskLevel: json['carcinogenicity_risk_level'] as String?,
      endocrineDisruptorRiskLevel: json['endocrine_disruptor_risk_level'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    matchedTerm,
    name,
    inciName,
    casNumber,
    functionCategory,
    safetyScore,
    hasRedflags,
    redflags,
    comedogenicRating,
    irritationRating,
    isVegan,
    isCleanBeauty,
    isMicroplastic,
    isPetroleumDerived,
    isLowPooApproved,
    isNoPooApproved,
    carcinogenicityRiskLevel,
    endocrineDisruptorRiskLevel,
  ];
}
