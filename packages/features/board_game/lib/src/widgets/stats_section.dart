import 'package:flutter/material.dart';

import 'widgets.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF3A1D21),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
          const Text(
            'Your Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Temps de jeu total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C1518),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '12,340h',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Play Time',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Statistiques détaillées
          Row(
            children: [
              StatItem(value: '2,340', label: 'Wins'),
              const SizedBox(width: 16),
              StatItem(value: '5,420', label: 'Matches'),
              const SizedBox(width: 16),
              StatItem(value: '4,580', label: 'Hours'),
            ],
          ),
        ],
      ),
    );
  }
}
