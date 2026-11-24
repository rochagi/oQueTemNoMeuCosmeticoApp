import 'package:equatable/equatable.dart';

class RegulatoryStatusModel extends Equatable {
  final int id;
  final String regionAgency;
  final String status;
  final String? details;

  const RegulatoryStatusModel({
    required this.id,
    required this.regionAgency,
    required this.status,
    this.details,
  });

  factory RegulatoryStatusModel.fromJson(Map<String, dynamic> json) {
    return RegulatoryStatusModel(
      id: json['id'] as int? ?? 0,
      regionAgency: json['region_agency'] as String? ?? 'Desconhecido',
      status: json['status'] as String? ?? 'allowed',
      details: json['details'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, regionAgency, status, details];
}

class StudyModel extends Equatable {
  final int id;
  final String title;
  final String? authors;
  final int? publicationYear;
  final String? doiOrUrl;

  const StudyModel({
    required this.id,
    required this.title,
    this.authors,
    this.publicationYear,
    this.doiOrUrl,
  });

  factory StudyModel.fromJson(Map<String, dynamic> json) {
    return StudyModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Sem título',
      authors: json['authors'] as String?,
      publicationYear: json['publication_year'] as int?,
      doiOrUrl: json['doi_or_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, title, authors, publicationYear, doiOrUrl];
}

class IngredientDetailModel extends Equatable {
  final int id;
  final String name;
  final String inciName;
  final String? casNumber;
  final String? functionCategory;
  final String? description;
  final double safetyScore;
  final String? origin;
  final bool isVegan;
  final bool isCleanBeauty;
  final bool isMicroplastic;
  final String? microplasticRiskLevel;
  final String? microplasticNotes;
  final bool isPetroleumDerived;
  final bool isLowPooApproved;
  final bool isNoPooApproved;
  final String? petroleumNotes;
  final String? carcinogenicityRiskLevel;
  final String? carcinogenicityClassification;
  final String? carcinogenicityNotes;
  final String? endocrineDisruptorRiskLevel;
  final String? endocrineDisruptorMechanism;
  final List<String> benefits;
  final List<String> contraindications;
  final List<String> sideEffects;
  final double? maxAllowedConcentration;
  final List<RegulatoryStatusModel> regulatoryStatuses;
  final List<StudyModel> studies;
  final List<String> aliases;

  const IngredientDetailModel({
    required this.id,
    required this.name,
    required this.inciName,
    this.casNumber,
    this.functionCategory,
    this.description,
    this.safetyScore = 5.0,
    this.origin,
    this.isVegan = false,
    this.isCleanBeauty = false,
    this.isMicroplastic = false,
    this.microplasticRiskLevel,
    this.microplasticNotes,
    this.isPetroleumDerived = false,
    this.isLowPooApproved = true,
    this.isNoPooApproved = true,
    this.petroleumNotes,
    this.carcinogenicityRiskLevel,
    this.carcinogenicityClassification,
    this.carcinogenicityNotes,
    this.endocrineDisruptorRiskLevel,
    this.endocrineDisruptorMechanism,
    this.benefits = const [],
    this.contraindications = const [],
    this.sideEffects = const [],
    this.maxAllowedConcentration,
    this.regulatoryStatuses = const [],
    this.studies = const [],
    this.aliases = const [],
  });

  factory IngredientDetailModel.fromJson(Map<String, dynamic> json) {
    final regStatuses = (json['regulatory_statuses'] as List<dynamic>?)
            ?.map((e) => RegulatoryStatusModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final studyList = (json['studies'] as List<dynamic>?)
            ?.map((e) => StudyModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final aliasList = (json['aliases'] as List<dynamic>?)
            ?.map((e) {
              if (e is Map<String, dynamic>) {
                return e['alias_name']?.toString() ?? '';
              }
              return e.toString();
            })
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    final benefitList = (json['benefits'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final contraList = (json['contraindications'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final sideEffectList = (json['side_effects'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return IngredientDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Ingrediente',
      inciName: json['inci_name'] as String? ?? '',
      casNumber: json['cas_number'] as String?,
      functionCategory: json['function_category'] as String?,
      description: json['description'] as String?,
      safetyScore: (json['safety_score'] as num?)?.toDouble() ?? 5.0,
      origin: json['origin'] as String?,
      isVegan: json['is_vegan'] as bool? ?? false,
      isCleanBeauty: json['is_clean_beauty'] as bool? ?? false,
      isMicroplastic: json['is_microplastic'] as bool? ?? false,
      microplasticRiskLevel: json['microplastic_risk_level'] as String?,
      microplasticNotes: json['microplastic_notes'] as String?,
      isPetroleumDerived: json['is_petroleum_derived'] as bool? ?? false,
      isLowPooApproved: json['is_low_poo_approved'] as bool? ?? true,
      isNoPooApproved: json['is_no_poo_approved'] as bool? ?? true,
      petroleumNotes: json['petroleum_notes'] as String?,
      carcinogenicityRiskLevel: json['carcinogenicity_risk_level'] as String?,
      carcinogenicityClassification: json['carcinogenicity_classification'] as String?,
      carcinogenicityNotes: json['carcinogenicity_notes'] as String?,
      endocrineDisruptorRiskLevel: json['endocrine_disruptor_risk_level'] as String?,
      endocrineDisruptorMechanism: json['endocrine_disruptor_mechanism'] as String?,
      benefits: benefitList,
      contraindications: contraList,
      sideEffects: sideEffectList,
      maxAllowedConcentration: (json['max_allowed_concentration'] as num?)?.toDouble(),
      regulatoryStatuses: regStatuses,
      studies: studyList,
      aliases: aliasList,
    );
  }

  /// Calculates safe and clean beauty alternatives based on ingredient profile
  List<String> get suggestedAlternatives {
    final alternatives = <String>[];

    if (isPetroleumDerived) {
      alternatives.add('Manteiga de Karité ou Óleos Vegetais (Jojoba, Argan, Coco)');
      alternatives.add('Esqualano Vegetal (derivado da oliva ou cana-de-açúcar)');
    }

    if (isMicroplastic) {
      alternatives.add('Goma Xantana ou Goma Guar (espessantes botânicos)');
      alternatives.add('Amido de Tapioca ou Arroz');
    }

    if (carcinogenicityRiskLevel != null && carcinogenicityRiskLevel != 'none') {
      alternatives.add('Substitutos com certificação COSMOS / EcoCert');
    }

    if (endocrineDisruptorRiskLevel != null && endocrineDisruptorRiskLevel != 'none') {
      alternatives.add('Conservantes limpos: Gluconolactona, Benzoato de Sódio ou Ácido Anísico');
    }

    if (alternatives.isEmpty) {
      if (functionCategory != null && functionCategory!.toLowerCase().contains('emoliente')) {
        alternatives.add('Óleo de Semente de Uva ou Manteiga de Murumuru');
      } else if (functionCategory != null && functionCategory!.toLowerCase().contains('solvente')) {
        alternatives.add('Hidrolatos e Águas Florais Orgânicas');
      } else {
        alternatives.add('Ativos botânicos certificados e biocompatíveis');
      }
    }

    return alternatives;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    inciName,
    casNumber,
    functionCategory,
    description,
    safetyScore,
    origin,
    isVegan,
    isCleanBeauty,
    isMicroplastic,
    microplasticRiskLevel,
    microplasticNotes,
    isPetroleumDerived,
    isLowPooApproved,
    isNoPooApproved,
    petroleumNotes,
    carcinogenicityRiskLevel,
    carcinogenicityClassification,
    carcinogenicityNotes,
    endocrineDisruptorRiskLevel,
    endocrineDisruptorMechanism,
    benefits,
    contraindications,
    sideEffects,
    maxAllowedConcentration,
    regulatoryStatuses,
    studies,
    aliases,
  ];
}
