import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/analysis_result_model.dart';
import '../../data/repositories/analysis_repository.dart';
import '../widgets/badges_grid.dart';
import '../widgets/critical_alerts_card.dart';
import '../widgets/ingredient_detail_sheet.dart';
import '../widgets/ingredient_expansion_tile.dart';
import '../widgets/score_hero_card.dart';
import '../widgets/unmapped_ingredients_list.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResultModel result;
  final AnalysisRepository? repository;

  const ResultScreen({
    super.key,
    required this.result,
    this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRepo = repository ?? AnalysisRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Análise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Hero
            ScoreHeroCard(
              score: result.score,
              ratingLabel: result.ratingLabel,
              ratingColorHex: result.ratingColorHex,
            ),
            const SizedBox(height: 20),

            // Critical alerts
            if (result.criticalAlerts.isNotEmpty) ...[
              CriticalAlertsCard(alerts: result.criticalAlerts),
              const SizedBox(height: 20),
            ],

            // Badges Section
            const Text(
              'Selos e Conformidade',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            BadgesGrid(badges: result.badges),
            const SizedBox(height: 24),

            // Mapped ingredients section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ingredientes Mapeados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${result.mappedIngredients.length} encontrados',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (result.mappedIngredients.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nenhum ingrediente foi mapeado com exatidão nesta composição.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
            else
              ...result.mappedIngredients.map(
                (ingredient) => IngredientExpansionTile(
                  ingredient: ingredient,
                  onTapDetails: () {
                    IngredientDetailSheet.show(
                      context,
                      ingredientId: ingredient.id,
                      fallbackName: ingredient.name,
                      repository: effectiveRepo,
                    );
                  },
                ),
              ),

            // Unmapped ingredients section
            if (result.unmappedIngredients.isNotEmpty) ...[
              const SizedBox(height: 16),
              UnmappedIngredientsList(unmapped: result.unmappedIngredients),
            ],

            const SizedBox(height: 32),

            // Button to return and scan another product
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear Outro Produto'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
