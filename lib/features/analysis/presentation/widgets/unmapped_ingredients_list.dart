import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class UnmappedIngredientsList extends StatelessWidget {
  final List<String> unmapped;

  const UnmappedIngredientsList({super.key, required this.unmapped});

  @override
  Widget build(BuildContext context) {
    if (unmapped.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ingredientes Não Mapeados (${unmapped.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Estes termos foram detectados pelo scanner mas ainda não constam no banco de dados e serão revisados:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: unmapped
                .map(
                  (term) => Chip(
                    label: Text(
                      term,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
