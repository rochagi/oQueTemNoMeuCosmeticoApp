import 'package:equatable/equatable.dart';

class BadgesModel extends Equatable {
  final bool isVegan;
  final bool isCleanBeauty;
  final bool isMicroplasticFree;
  final bool isPetroleumFree;
  final bool isLowPooApproved;
  final bool isNoPooApproved;

  const BadgesModel({
    this.isVegan = false,
    this.isCleanBeauty = false,
    this.isMicroplasticFree = false,
    this.isPetroleumFree = false,
    this.isLowPooApproved = false,
    this.isNoPooApproved = false,
  });

  factory BadgesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BadgesModel();

    return BadgesModel(
      isVegan: json['is_vegan'] as bool? ?? false,
      isCleanBeauty: json['is_clean_beauty'] as bool? ?? false,
      isMicroplasticFree: json['is_microplastic_free'] as bool? ?? false,
      isPetroleumFree: json['is_petroleum_free'] as bool? ?? false,
      isLowPooApproved: json['is_low_poo_approved'] as bool? ?? false,
      isNoPooApproved: json['is_no_poo_approved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'is_vegan': isVegan,
    'is_clean_beauty': isCleanBeauty,
    'is_microplastic_free': isMicroplasticFree,
    'is_petroleum_free': isPetroleumFree,
    'is_low_poo_approved': isLowPooApproved,
    'is_no_poo_approved': isNoPooApproved,
  };

  @override
  List<Object?> get props => [
    isVegan,
    isCleanBeauty,
    isMicroplasticFree,
    isPetroleumFree,
    isLowPooApproved,
    isNoPooApproved,
  ];
}
