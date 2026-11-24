import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CriticalAlertsCard extends StatelessWidget {
  final List<String> alerts;

  const CriticalAlertsCard({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.scoreDanger, size: 22),
              SizedBox(width: 8),
              Text(
                'Alertas Críticos Identificados',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.scoreDanger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...alerts.map(
            (alert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.scoreDanger, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      alert,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF991B1B),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
