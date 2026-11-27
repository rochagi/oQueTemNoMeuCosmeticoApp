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
        border: Border.all(
          color: ingredient.hasRedflags
              ? AppColors.scoreDanger.withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
        title: Row(
          children: [
            Expanded(
              child: Text(
                ingredient.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (ingredient.hasRedflags)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppColors.scoreDanger,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ingredient.inciName.isNotEmpty) ...[
              Text(
                'INCI: ${ingredient.inciName}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
            ] else if (ingredient.functionCategory != null) ...[
              Text(
                ingredient.functionCategory!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
            ],
            // Fast preview of redflags chips right on the tile
            if (ingredient.hasRedflags && ingredient.redflags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: ingredient.redflags
                    .take(2)
                    .map((rf) => _buildMiniBadge(rf, AppColors.scoreDanger))
                    .toList(),
              ),
            ],
          ],
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (ingredient.hasRedflags && ingredient.redflags.isNotEmpty) ...[
                  const Text(
                    'Alertas e Redflags:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.scoreDanger,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ingredient.redflags
                        .map((rf) => _buildMiniBadge(rf, AppColors.scoreDanger))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
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
                if (ingredient.functionCategory != null && ingredient.inciName.isNotEmpty) ...[
                  Text(
                    'Função: ${ingredient.functionCategory}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (onTapDetails != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onTapDetails,
                      icon: const Icon(Icons.menu_book, size: 18),
                      label: const Text(
                        'Ver Ficha Técnica Completa (Dossiê)',
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
        border: Border.all(color: color.withValues(alpha: 0.25)),
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
