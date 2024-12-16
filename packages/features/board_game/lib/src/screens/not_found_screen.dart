import 'dart:async';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  int _counter = 10; // Compteur initialisé à 10
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Démarre un timer qui décrémente le compteur chaque seconde
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        _timer.cancel(); // Arrête le timer lorsque le compteur atteint 0
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Retour à la page précédente
        }
      } else {
        setState(() {
          _counter--; // Décrémente le compteur
        });
      }
    });
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Assurez-vous d'arrêter le timer pour éviter les fuites de mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404 - Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Returning in $_counter seconds...',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
