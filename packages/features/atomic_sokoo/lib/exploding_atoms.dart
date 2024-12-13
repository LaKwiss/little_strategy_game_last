import 'dart:developer';
import 'package:atomic_sokoo/cell.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class ExplodingAtoms extends FlameGame with TapCallbacks {
  int turn = 0;

  String id;

  late List<List<Cell>> grid;

  int currentPlayer = 1;
  int totalPlayers = 2;

  ExplodingAtoms(
      {required this.gridRows, required this.gridCols, required this.id});

  final int gridRows;
  final int gridCols;

  void resetGrid() {
    for (var row in grid) {
      for (var cell in row) {
        cell.atomCount = 0;
        cell.owner = null;
      }
    }
  }

  @override
  Future<void> onLoad() async {
    grid = List.generate(
      gridRows,
      (row) => List.generate(
        gridCols,
        (col) => Cell(row: row, col: col),
      ),
    );

    for (var row in grid) {
      for (var cell in row) {
        add(cell);
      }
    }
  }

  Cell? getCell(int row, int col) {
    if (row >= 0 && row < gridRows && col >= 0 && col < gridCols) {
      return grid[row][col];
    }
    return null;
  }

  void nextTurn() {
    turn++;
    checkWinCondition();
    currentPlayer = currentPlayer % totalPlayers + 1;
  }

  void checkWinCondition() {
    Set<int> owners = {};
    for (var row in grid) {
      for (var cell in row) {
        if (cell.owner != null) {
          owners.add(cell.owner!);
        }
      }
    }

    if (owners.length == 1 && turn > 1) {
      log("Le joueur ${owners.first} a gagné !");
      resetGrid();
    }
  }

  List<Cell> getNeighbors(Cell cell) {
    int x = cell.col;
    int y = cell.row;

    List<Cell> neighbors = [];
    if (y > 0) neighbors.add(grid[y - 1][x]);
    if (x > 0) neighbors.add(grid[y][x - 1]);
    if (y < gridRows - 1) neighbors.add(grid[y + 1][x]);
    if (x < gridCols - 1) neighbors.add(grid[y][x + 1]);

    return neighbors;
  }

  void explode(Cell cell) {
    int maxAtoms = cell.getMaxAtoms();

    if (cell.atomCount < maxAtoms) return;

    cell.atomCount = 0;
    cell.owner = null;

    List<Cell> neighbors = getNeighbors(cell);

    for (var neighbor in neighbors) {
      neighbor.atomCount++;
      neighbor.owner = currentPlayer;

      if (neighbor.atomCount >= neighbor.getMaxAtoms()) {
        explode(neighbor);
      }
    }
  }
}
