import 'package:flutter/material.dart';

class ModernLootboxButton extends StatelessWidget {
  final AnimationController controller;

  const ModernLootboxButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final glowAnimation =
            Tween<double>(begin: 0, end: 5).animate(controller);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.amber[700]!,
                Colors.amber[600]!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withAlpha((0.3 * 255).round()),
                blurRadius: glowAnimation.value * 3,
                spreadRadius: glowAnimation.value,
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pushNamed('/open_lootbox'),
            child: const Text(
              'OPEN LOOTBOX',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }
}
