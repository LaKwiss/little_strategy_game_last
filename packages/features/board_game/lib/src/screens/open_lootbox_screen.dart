import 'dart:async';
import 'package:board_game/src/providers/lootbox/lootbox_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class OpenLootboxScreen extends ConsumerStatefulWidget {
  const OpenLootboxScreen({super.key});

  @override
  _OpenLootboxState createState() => _OpenLootboxState();
}

class _OpenLootboxState extends ConsumerState<OpenLootboxScreen>
    with SingleTickerProviderStateMixin {
  Loot? _loot;
  bool _isOpening = false;
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _verticalOffsetAnimation;
  late Animation<double> _sizeAnimation;
  final Logger _logger = Logger('OpenLootboxScreen');

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // Contrôleur d'animation pour la pulsation constante
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Animation pour un décalage vertical constant de ±5px
    _verticalOffsetAnimation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animation pour la taille normale
    _sizeAnimation = Tween<double>(begin: 250, end: 250).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onPressButton() async {
    if (_isOpening) return; // Évite les clics multiples
    setState(() {
      _isOpening = true;

      // Étend la taille pour l'animation d'ouverture
      _sizeAnimation = Tween<double>(begin: 250, end: 285).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    });

    try {
      _logger.info('Ouverture de la lootbox...');
      await Future.delayed(const Duration(seconds: 3)); // Animation de 3s

      // Récupère un loot aléatoire
      final loot = await ref.read(lootboxProvider.notifier).getRandomLoot();

      // Ajoute le loot au joueur
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.displayName == null) {
        throw Exception('Utilisateur non connecté ou displayName absent.');
      }

      await ref
          .read(lootboxProvider.notifier)
          .addLootToUser(loot, currentUser.displayName!);

      // Active les confettis et affiche le loot obtenu
      setState(() {
        _loot = loot;
        _isOpening = false;

        // Réinitialise la taille après l'ouverture
        _sizeAnimation = Tween<double>(begin: 250, end: 250).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
      });
      _confettiController.play();
      _logger.info('Loot obtenu : ${_loot!.name}');
      _showWinDialog();
    } catch (error) {
      setState(() {
        _isOpening = false;
      });
      _logger.severe('Erreur lors de l\'ouverture de la lootbox', error);
      _showErrorDialog();
    }
  }

  void _showWinDialog() {
    if (_loot == null) return; // Sécurité
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vous avez gagné ! 🎉'),
          content: Text('Vous avez obtenu : ${_loot!.name}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: const Text(
              'Impossible d\'ouvrir la lootbox. Veuillez réessayer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Confetti Widget pour célébration
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow
              ],
            ),
            Tooltip(
              message: 'Cliquez pour ouvrir la lootbox !',
              child: GestureDetector(
                onTap: _onPressButton,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _verticalOffsetAnimation.value),
                      child: Container(
                        width: _sizeAnimation.value,
                        height: _sizeAnimation.value,
                        decoration: BoxDecoration(
                          color: _isOpening
                              ? Colors.blueAccent.withOpacity(0.8)
                              : Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: _isOpening
                              ? [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.6),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color:
                                        Colors.blue.shade900.withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: _isOpening
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 6,
                                )
                              : const Icon(
                                  Icons.casino_outlined,
                                  size: 200,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
