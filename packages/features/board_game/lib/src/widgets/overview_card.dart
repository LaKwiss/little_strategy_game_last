import 'package:board_game/board_game.dart';
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF292524),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OMEN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                Text(
                  'PLAYED 354H 46M',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    StatItem(label: 'Win Ratio', value: '62.11%'),
                    const SizedBox(width: 32),
                    StatItem(label: 'K/D Ratio', value: '1.14'),
                    const SizedBox(width: 32),
                    StatItem(label: 'Dmg/Round', value: '138.2'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1917),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person,
              size: 96,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
