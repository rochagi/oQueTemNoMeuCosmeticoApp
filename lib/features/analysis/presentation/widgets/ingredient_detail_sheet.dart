import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/ingredient_detail_model.dart';
import '../../data/repositories/analysis_repository.dart';

class IngredientDetailSheet extends StatefulWidget {
  final int ingredientId;
  final String fallbackName;
  final AnalysisRepository repository;

  const IngredientDetailSheet({
    super.key,
    required this.ingredientId,
    required this.fallbackName,
    required this.repository,
  });

  static Future<void> show(
    BuildContext context, {
    required int ingredientId,
    required String fallbackName,
    required AnalysisRepository repository,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => IngredientDetailSheet(
        ingredientId: ingredientId,
        fallbackName: fallbackName,
        repository: repository,
      ),
    );
  }

  @override
  State<IngredientDetailSheet> createState() => _IngredientDetailSheetState();
}

class _IngredientDetailSheetState extends State<IngredientDetailSheet> {
  late Future<IngredientDetailModel> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = widget.repository.getIngredientDetails(widget.ingredientId);
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return AppColors.scoreExcellent;
    if (score >= 6.0) return AppColors.scoreGood;
    if (score >= 4.0) return AppColors.scoreWarning;
    return AppColors.scoreDanger;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return FutureBuilder<IngredientDetailModel>(
          future: _detailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  _buildHandle(),
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: 16),
                          Text(
                            'Consultando ficha técnica e evidências científicas...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                children: [
                  _buildHandle(),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.scoreDanger, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar detalhes de "${widget.fallbackName}"',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _detailFuture = widget.repository
                                      .getIngredientDetails(widget.ingredientId);
                                });
                              },
                              child: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            final detail = snapshot.data!;
            final scoreColor = _getScoreColor(detail.safetyScore);

            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                _buildHandle(),

                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'INCI: ${detail.inciName.isNotEmpty ? detail.inciName : 'Não informado'}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (detail.casNumber != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              'CAS: ${detail.casNumber}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            detail.safetyScore.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          const Text(
                            'Segurança',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (detail.functionCategory != null)
                      _buildChip(detail.functionCategory!, Icons.category,
                          AppColors.primary),
                    if (detail.origin != null)
                      _buildChip('Origem: ${detail.origin}', Icons.nature,
                          AppColors.textSecondary),
                    if (detail.isPetroleumDerived)
                      _buildChip('Derivado de Petróleo', Icons.oil_barrel,
                          AppColors.scoreDanger),
                    if (detail.isMicroplastic)
                      _buildChip('Microplástico Sintético', Icons.water,
                          AppColors.scoreDanger),
                    if (!detail.isLowPooApproved)
                      _buildChip(
                          'Proibido Low Poo', Icons.block, AppColors.scoreWarning),
                    if (detail.isVegan)
                      _buildChip('Vegano', Icons.eco, AppColors.scoreExcellent),
                  ],
                ),
                const SizedBox(height: 20),

                // Description
                if (detail.description != null && detail.description!.isNotEmpty) ...[
                  _buildSectionTitle('Descrição Técnica', Icons.description_outlined),
                  const SizedBox(height: 6),
                  Text(
                    detail.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Mechanism & Red Flags
                _buildSectionTitle('Mecanismo de Ação e Riscos', Icons.biotech_outlined),
                const SizedBox(height: 8),
                _buildMechanismCard(detail),
                const SizedBox(height: 20),

                // Regulatory Status
                if (detail.regulatoryStatuses.isNotEmpty) ...[
                  _buildSectionTitle('Status Regulatório', Icons.gavel_outlined),
                  const SizedBox(height: 8),
                  ...detail.regulatoryStatuses.map((reg) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reg.regionAgency,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (reg.details != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      reg.details!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                ],

                // Scientific Studies
                if (detail.studies.isNotEmpty) ...[
                  _buildSectionTitle('Evidências & Estudos Científicos', Icons.menu_book_outlined),
                  const SizedBox(height: 8),
                  ...detail.studies.map((study) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              study.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (study.authors != null || study.publicationYear != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${study.authors ?? ''} ${study.publicationYear != null ? '(${study.publicationYear})' : ''}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                ],

                // Benefits & Contraindications
                if (detail.benefits.isNotEmpty || detail.contraindications.isNotEmpty) ...[
                  _buildSectionTitle('Benefícios & Contraindicações', Icons.health_and_safety_outlined),
                  const SizedBox(height: 8),
                  if (detail.benefits.isNotEmpty) ...[
                    const Text('Benefícios:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.scoreExcellent)),
                    const SizedBox(height: 4),
                    ...detail.benefits.map((b) => Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text('• $b',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.textSecondary)),
                        )),
                    const SizedBox(height: 10),
                  ],
                  if (detail.contraindications.isNotEmpty) ...[
                    const Text('Contraindicações / Cuidados:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.scoreDanger)),
                    const SizedBox(height: 4),
                    ...detail.contraindications.map((c) => Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text('• $c',
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF991B1B))),
                        )),
                  ],
                  const SizedBox(height: 20),
                ],

                // Safe Alternatives
                _buildSectionTitle('Alternativas Seguras e Limpas', Icons.eco_outlined),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Se você busca uma rotina Clean Beauty, considere cosméticos que substituam este ingrediente por:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF166534),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...detail.suggestedAlternatives.map(
                        (alt) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('🌿 ', style: TextStyle(fontSize: 13)),
                              Expanded(
                                child: Text(
                                  alt,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF14532D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMechanismCard(IngredientDetailModel detail) {
    final hasPetroleumNotes = detail.petroleumNotes != null;
    final hasMicroplasticNotes = detail.microplasticNotes != null;
    final hasCarcinogenicityNotes = detail.carcinogenicityNotes != null;
    final hasEndocrineMechanism = detail.endocrineDisruptorMechanism != null;

    if (!hasPetroleumNotes &&
        !hasMicroplasticNotes &&
        !hasCarcinogenicityNotes &&
        !hasEndocrineMechanism) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Text(
          'Nenhum alerta toxicológico crítico registrado para este ingrediente nas dosagens cosméticas usuais.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasPetroleumNotes) ...[
            const Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.scoreDanger, size: 18),
                SizedBox(width: 6),
                Text(
                  'Mecanismo de Oclusão & Acúmulo (Build-up):',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.scoreDanger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              detail.petroleumNotes!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
            ),
            const SizedBox(height: 10),
          ],
          if (hasCarcinogenicityNotes) ...[
            const Row(
              children: [
                Icon(Icons.biotech, color: AppColors.scoreDanger, size: 18),
                SizedBox(width: 6),
                Text(
                  'Carcinogenicidade & Impurezas:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.scoreDanger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              detail.carcinogenicityNotes!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
            ),
            const SizedBox(height: 10),
          ],
          if (hasEndocrineMechanism) ...[
            const Row(
              children: [
                Icon(Icons.science, color: AppColors.scoreDanger, size: 18),
                SizedBox(width: 6),
                Text(
                  'Mecanismo de Disrupção Endócrina:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.scoreDanger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              detail.endocrineDisruptorMechanism!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
            ),
            const SizedBox(height: 10),
          ],
          if (hasMicroplasticNotes) ...[
            const Row(
              children: [
                Icon(Icons.water_drop, color: AppColors.scoreWarning, size: 18),
                SizedBox(width: 6),
                Text(
                  'Impacto Ambiental & Microplásticos:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              detail.microplasticNotes!,
              style: const TextStyle(fontSize: 13, color: Color(0xFFB45309)),
            ),
          ],
        ],
      ),
    );
  }
}
