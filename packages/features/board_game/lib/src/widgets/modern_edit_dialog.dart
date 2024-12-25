import 'package:board_game/src/widgets/modern_edit_option.dart';
import 'package:flutter/material.dart';

class ModernEditDialog extends StatelessWidget {
  final VoidCallback onSelectImage;
  final VoidCallback onSelectBackground;
  final VoidCallback onSelectBanner;

  const ModernEditDialog({
    super.key,
    required this.onSelectImage,
    required this.onSelectBackground,
    required this.onSelectBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3A1D21),
              const Color(0xFF2C1518),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withAlpha((0.1 * 255).round()),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ModernEditOption(
              title: 'Change Profile Picture',
              icon: Icons.person,
              onTap: onSelectImage,
            ),
            const SizedBox(height: 12),
            ModernEditOption(
              title: 'Change Background Color',
              icon: Icons.color_lens,
              onTap: onSelectBackground,
            ),
            const SizedBox(height: 12),
            ModernEditOption(
              title: 'Change Banner',
              icon: Icons.panorama,
              onTap: onSelectBanner,
            ),
          ],
        ),
      ),
    );
  }
}
