import 'dart:math';
import 'package:domain_entities/domain_entities.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Cell extends PositionComponent
    with TapCallbacks, HasGameRef<ExplodingAtoms> {
  final int row;
  final int col;
  int atomCount = 0;
  int? owner;

  Cell({required this.row, required this.col});

  @override
  Future<void> onLoad() async {
    size = Vector2(50, 50);
    position = Vector2(col * size.x, row * size.y);
  }

  @override
  void render(Canvas canvas) {
    // Dessiner la cellule
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(size.toRect(), paint);

    // Dessiner le contour
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawRect(size.toRect(), borderPaint);

    if (atomCount > 0) {
      final atomPaint = Paint()..color = getPlayerColor();
      double centerX = size.x / 2;
      double centerY = size.y / 2;
      double radius = 15;

      for (int i = 0; i < atomCount; i++) {
        double angle = i * (360 / atomCount) * (3.14 / 180);
        canvas.drawCircle(
          Offset(
            centerX + radius * cos(angle),
            centerY + radius * sin(angle),
          ),
          5.0,
          atomPaint,
        );
      }
    }
  }

  Color getPlayerColor() {
    switch (owner) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (owner == null || owner == gameRef.currentPlayer) {
      owner = gameRef.currentPlayer;
      atomCount++;

      // Vérifiez si la cellule doit exploser
      checkExplosion();

      // Passez au tour suivant
      gameRef.nextTurn();
    }
  }

  void checkExplosion() {
    int maxAtoms = getMaxAtoms();
    if (atomCount < maxAtoms) return;

    // Lancez l'explosion via le jeu
    gameRef.explode(this);
  }

  int getMaxAtoms() {
    int x = col;
    int y = row;
    int maxAtoms = 4;

    if (x == 0) maxAtoms--;
    if (y == 0) maxAtoms--;
    if (y == gameRef.gridRows - 1) maxAtoms--;
    if (x == gameRef.gridCols - 1) maxAtoms--;

    return maxAtoms;
  }

  Cell copyWith({
    int? row,
    int? col,
    int? atomCount,
    int? owner,
  }) {
    return Cell(
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  Cell.fromJson(Map<String, dynamic> json)
      : row = json['row'],
        col = json['col'],
        atomCount = json['atomCount'],
        owner = json['owner'];

  Map<String, dynamic> toJson() => {
        'row': row,
        'col': col,
        'atomCount': atomCount,
        'owner': owner,
      };
}
