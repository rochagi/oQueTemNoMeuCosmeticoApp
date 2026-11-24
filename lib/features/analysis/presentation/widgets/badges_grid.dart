import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/badges_model.dart';

class BadgesGrid extends StatelessWidget {
  final BadgesModel badges;

  const BadgesGrid({super.key, required this.badges});

  Widget _buildBadgeItem({
    required String label,
    required String icon,
    required bool isApproved,
  }) {
    final activeColor = AppColors.scoreExcellent;
    final inactiveColor = AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isApproved
            ? activeColor.withValues(alpha: 0.1)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isApproved
              ? activeColor.withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isApproved ? FontWeight.bold : FontWeight.w500,
              color: isApproved ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            isApproved ? Icons.check_circle : Icons.cancel_outlined,
            size: 16,
            color: isApproved ? activeColor : inactiveColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildBadgeItem(
          label: 'Vegano',
          icon: '🌱',
          isApproved: badges.isVegan,
        ),
        _buildBadgeItem(
          label: 'Clean Beauty',
          icon: '🧴',
          isApproved: badges.isCleanBeauty,
        ),
        _buildBadgeItem(
          label: 'Sem Microplásticos',
          icon: '🌊',
          isApproved: badges.isMicroplasticFree,
        ),
        _buildBadgeItem(
          label: 'Sem Petrolatos',
          icon: '🛢️',
          isApproved: badges.isPetroleumFree,
        ),
        _buildBadgeItem(
          label: 'Low Poo',
          icon: '🚿',
          isApproved: badges.isLowPooApproved,
        ),
        _buildBadgeItem(
          label: 'No Poo',
          icon: '✨',
          isApproved: badges.isNoPooApproved,
        ),
      ],
    );
  }
}
