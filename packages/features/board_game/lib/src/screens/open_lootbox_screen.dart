import 'dart:async';
import 'package:board_game/src/providers/lootbox/lootbox_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class OpenLootboxScreen extends ConsumerStatefulWidget {
  const OpenLootboxScreen({super.key});

  @override
  _OpenLootboxState createState() => _OpenLootboxState();
}

class _OpenLootboxState extends ConsumerState<OpenLootboxScreen> {
  Loot? _loot;
  bool _isOpening = false;
  late ConfettiController _confettiController;
  final Logger _logger = Logger('OpenLootboxScreen');

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _onPressButton() async {
    if (_isOpening) return;
    setState(() {
      _isOpening = true;
    });

    try {
      _logger.info('Ouverture de la lootbox...');
      await Future.delayed(const Duration(seconds: 3));

      // Fetch loot
      final loot = await ref.read(lootboxProvider.notifier).getRandomLoot();
      setState(() {
        _loot = loot;
        _isOpening = false;
      });

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
    if (_loot == null) return; // Safety check
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vous avez gagné !'),
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
          title: const Text(
            'Erreur',
          ),
          content: const Text(
              'Impossible d\'ouvrir la lootbox. Veuillez réessayer.'),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade900.withValues(alpha: 200),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.casino_outlined,
                            size: 200,
                            color: Colors.white,
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
      ),
    );
  }
}
