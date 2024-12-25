import 'package:board_game/src/widgets/modern_lootbox_button.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModernProfileCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ProfileData profile;
  final User? user;
  final AnimationController glowController;
  final VoidCallback onSelectImage;

  const ModernProfileCard({
    super.key,
    required this.formKey,
    required this.profile,
    required this.user,
    required this.glowController,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3A1D21).withAlpha(
              (0.95 * 255).round(),
            ),
            const Color(0xFF2C1518).withAlpha(
              (0.95 * 255).round(),
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(
            (0.1 * 255).round(),
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              (0.2 * 255).round(),
            ),
            blurRadius: 30,
            spreadRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Centrage horizontal de l'avatar
            Center(
              child: _buildAvatar(),
            ),
            const SizedBox(height: 24),
            _buildTextField('Username', user?.displayName ?? 'No username'),
            const SizedBox(height: 16),
            _buildTextField('Email', user?.email ?? 'No email'),
            const SizedBox(height: 24),
            ModernLootboxButton(controller: glowController),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: onSelectImage,
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center, // Pour centrer l'icône dans le cercle
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.purple.withAlpha(
              (0.5 * 255).round(),
            ),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withAlpha(
                (0.2 * 255).round(),
              ),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
          image: FirebaseAuth.instance.currentUser?.photoURL != null
              ? DecorationImage(
                  image: NetworkImage(
                    FirebaseAuth.instance.currentUser!.photoURL!,
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.center, // Centrage de l'image
                )
              : null,
        ),
        child: FirebaseAuth.instance.currentUser?.photoURL == null
            ? const Icon(Icons.person, size: 40, color: Colors.white70)
            : null,
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha((0.1 * 255).round()),
          width: 1,
        ),
      ),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withAlpha(
              (0.7 * 255).round(),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
