import 'package:atomic_sokoo/exploding_atoms.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  static const int gridRows = 8;
  static const gridCols = 8;

  final ExplodingAtoms game =
      ExplodingAtoms(gridCols: gridCols, gridRows: gridRows, id: '1');

  @override
  Widget build(BuildContext context) {
    // lib/main.dart
    int height = gridCols;
    int width = gridRows;
    int cellSize = 50;

    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            SizedBox(
                height: (height * cellSize).toDouble(),
                width: (width * cellSize).toDouble(),
                child: GameWidget(game: game)),
            Text(
              'Joueur actuel : ${game.currentPlayer}',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
