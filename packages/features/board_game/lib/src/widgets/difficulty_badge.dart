import 'package:flutter/material.dart';

class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({
    super.key,
    required this.difficulty,
  });

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (difficulty) {
      case 'Beginner':
        backgroundColor = Colors.green[900]!;
        textColor = Colors.green[200]!;
        break;
      case 'Intermediate':
        backgroundColor = Colors.yellow[900]!;
        textColor = Colors.yellow[200]!;
        break;
      default:
        backgroundColor = Colors.red[900]!;
        textColor = Colors.red[200]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
