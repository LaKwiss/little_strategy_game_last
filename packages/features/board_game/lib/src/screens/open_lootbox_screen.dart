import 'dart:async';
import 'dart:math' as math;
import 'package:board_game/src/providers/lootbox/lootbox_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

// PACKAGES EXTERNES
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shimmer/shimmer.dart';

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

  // Animations pour la box
  late Animation<double> _verticalOffsetAnimation;
  late Animation<double> _rotateYAnimation;
  late Animation<double> _rotateZAnimation;
  late Animation<double> _scaleAnimation;

  // Animations de background
  late Animation<Color?> _backgroundColorAnimation;

  final Logger _logger = Logger('OpenLootboxScreen');

  @override
  void initState() {
    super.initState();

    // Confetti
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));

    // Animation Controller principal
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Animations de la box
    _verticalOffsetAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rotateYAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rotateZAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animation de background (couleurs)
    _backgroundColorAnimation = ColorTween(
      begin: Colors.deepPurple.shade900,
      end: Colors.indigo.shade900,
    ).animate(
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
    if (_isOpening) return; // Évite les double-clics

    setState(() {
      _isOpening = true;
      // Effet d'expansion lors de l'ouverture
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    });

    _logger.info('Ouverture de la lootbox...');
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Récupération du loot
      final loot = await ref.read(lootboxProvider.notifier).getRandomLoot();

      // Ajout du loot à l’utilisateur
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.displayName == null) {
        throw Exception('Utilisateur non connecté ou displayName absent.');
      }

      await ref
          .read(lootboxProvider.notifier)
          .addLootToUser(loot, currentUser.displayName!);

      // Réinitialisation après obtention
      setState(() {
        _loot = loot;
        _isOpening = false;
        _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
      });

      // Lancement des confettis
      _confettiController.play();
      _logger.info('Loot obtenu : ${_loot!.name}');
      _showWinDialog();
    } catch (error) {
      setState(() {
        _isOpening = false;
        _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );
      });
      _logger.severe('Erreur lors de l\'ouverture de la lootbox', error);
      _showErrorDialog();
    }
  }

  void _showWinDialog() {
    if (_loot == null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                  parent: _animationController, curve: Curves.elasticOut),
            ),
            child: AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      ScaleAnimatedText(
                        'VICTOIRE !',
                        scalingFactor: 0.8,
                        duration: const Duration(milliseconds: 1200),
                      )
                    ],
                    isRepeatingAnimation: false,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Vous avez obtenu : ${_loot!.name}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Petite animation visuelle simple (sans assets externes)
                  // On va simuler une sorte d’aura tournante avec un simple Container qui tourne
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * math.pi,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const SweepGradient(
                                colors: [
                                  Colors.amber,
                                  Colors.transparent,
                                  Colors.amber,
                                  Colors.transparent
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.star,
                                color: Colors.amber.shade400,
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    // Arrière-plan : gradient radial animé + scintillement
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          final backgroundColor =
              _backgroundColorAnimation.value ?? Colors.deepPurple.shade900;

          final gradient = RadialGradient(
            center: const Alignment(0, 0),
            radius: 1.0,
            colors: [
              backgroundColor.withOpacity(0.9),
              Colors.black.withOpacity(0.95),
            ],
            stops: const [0.3, 1.0],
          );

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: gradient),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Confetti
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.purple,
                    Colors.orange
                  ],
                ),

                // Aura lumineuse dynamique
                Transform.scale(
                  scale: 2.5 +
                      math.sin(_animationController.value * math.pi) * 0.5,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(
                              0.6 + _animationController.value * 0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Titre animé au dessus
                Positioned(
                  top: 100,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1000),
                      animatedTexts: [
                        RotateAnimatedText("Ouvrez"),
                        RotateAnimatedText("Cette"),
                        RotateAnimatedText("LOOTBOX !"),
                      ],
                    ),
                  ),
                ),

                // La lootbox
                Tooltip(
                  message: 'Cliquez pour ouvrir la lootbox !',
                  child: GestureDetector(
                    onTap: _onPressButton,
                    child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..translate(0.0, _verticalOffsetAnimation.value)
                        ..rotateY(_rotateYAnimation.value)
                        ..rotateZ(_rotateZAnimation.value)
                        ..scale(_scaleAnimation.value),
                      child: Shimmer.fromColors(
                        baseColor: _isOpening
                            ? Colors.blueAccent
                            : Colors.blue.shade700,
                        highlightColor: Colors.cyanAccent,
                        period: const Duration(seconds: 2),
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: _isOpening
                                    ? Colors.blueAccent.withOpacity(0.7)
                                    : Colors.blue.shade900.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Fond de la box
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              if (_isOpening)
                                // Un indicatif de chargement
                                Transform.scale(
                                  scale: 1.5,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 6,
                                  ),
                                )
                              else
                                Transform.rotate(
                                  angle: math.sin(_animationController.value *
                                          math.pi) *
                                      0.1,
                                  child: const Icon(
                                    Icons.casino_outlined,
                                    size: 200,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
