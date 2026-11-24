import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/mapped_ingredient_model.dart';

class IngredientExpansionTile extends StatelessWidget {
  final MappedIngredientModel ingredient;
  final VoidCallback? onTapDetails;

  const IngredientExpansionTile({
    super.key,
    required this.ingredient,
    this.onTapDetails,
  });

  Color _getScoreColor(double score) {
    if (score >= 8.0) return AppColors.scoreExcellent;
    if (score >= 6.0) return AppColors.scoreGood;
    if (score >= 4.0) return AppColors.scoreWarning;
    return AppColors.scoreDanger;
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(ingredient.safetyScore);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scoreColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            ingredient.safetyScore.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ),
        title: Text(
          ingredient.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: ingredient.functionCategory != null
            ? Text(
                ingredient.functionCategory!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ingredient.inciName.isNotEmpty) ...[
                  Text(
                    'Nome INCI: ${ingredient.inciName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (ingredient.casNumber != null) ...[
                  Text(
                    'Código CAS: ${ingredient.casNumber}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (ingredient.matchedTerm.isNotEmpty) ...[
                  Text(
                    'Termo lido no rótulo: "${ingredient.matchedTerm}"',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (ingredient.isPetroleumDerived)
                      _buildMiniBadge('Derivado de Petróleo', AppColors.scoreDanger),
                    if (ingredient.isMicroplastic)
                      _buildMiniBadge('Microplástico Sintético', AppColors.scoreDanger),
                    if (!ingredient.isLowPooApproved)
                      _buildMiniBadge('Proibido Low Poo', AppColors.scoreWarning),
                    if (ingredient.isVegan)
                      _buildMiniBadge('Vegano', AppColors.scoreExcellent),
                  ],
                ),
                if (onTapDetails != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: onTapDetails,
                      icon: const Icon(Icons.menu_book, size: 16),
                      label: const Text(
                        'Ver Ficha Completa (Mecanismos & Estudos)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
