import 'dart:developer';
import 'package:domain_entities/domain_entities.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

enum ExplodingAtomsState {
  waitingForPlayers,
  started,
  ended,
}

class ExplodingAtoms extends FlameGame with TapCallbacks {
  late String id;

  int turn = 0;
  ExplodingAtomsState state = ExplodingAtomsState.waitingForPlayers;
  String title = "Exploding Atoms";

  // Au lieu de laisser grid en late sans initialisation,
  // on l'initialise à une liste vide pour éviter les lateErrors.
  // Cela permet d'avoir toujours grid prêt lors de l'appel de toJson().
  List<List<Cell>> grid = const [];

  int currentPlayer = 1;
  int totalPlayers = 2;
  int totalAtoms = 0;

  final int gridRows;
  final int gridCols;

  ExplodingAtoms({
    required this.gridRows,
    required this.gridCols,
    required this.id,
  });

  void resetGrid() {
    for (var row in grid) {
      for (var cell in row) {
        cell.atomCount = 0;
        cell.owner = null;
      }
    }
    turn = 0;
    totalAtoms = 0;
    currentPlayer = 1;
    state = ExplodingAtomsState.waitingForPlayers;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Ici, on initialise la grille après le super.onLoad().
    // Si toJson() est appelé avant onLoad(), grid sera vide mais pas null.
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

    if (totalPlayers > 1) {
      state = ExplodingAtomsState.started;
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
    // Envoyer le jeu sur Firestore ici, si nécessaire.
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
      final winner = owners.first;
      log("Le joueur $winner a gagné !");
      state = ExplodingAtomsState.ended;
      // resetGrid(); // Optionnel
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

  void countAtoms() {
    totalAtoms = 0;
    for (var row in grid) {
      for (var cell in row) {
        totalAtoms += cell.atomCount;
      }
    }
  }

  ExplodingAtoms.fromJson(Map<String, dynamic> json)
      : gridRows = json['gridRows'],
        gridCols = json['gridCols'] {
    if (!json.containsKey('id') ||
        !json.containsKey('gridRows') ||
        !json.containsKey('gridCols')) {
      throw Exception('JSON invalide pour ExplodingAtoms');
    }

    id = json['id'] as String;
    currentPlayer = json['currentPlayer'] ?? 1;
    totalPlayers = json['totalPlayers'] ?? 2;
    turn = json['turn'] ?? 0;
    totalAtoms = json['totalAtoms'] ?? 0;

    int stateIndex = json['state'] ?? 0;
    if (stateIndex < 0 || stateIndex >= ExplodingAtomsState.values.length) {
      stateIndex = 0;
    }
    state = ExplodingAtomsState.values[stateIndex];

    title = json['title'] ?? "Exploding Atoms";

    if (!json.containsKey('grid')) {
      throw Exception('JSON invalide : pas de champ grid');
    }

    var gridData = json['grid'];
    if (gridData is! List) {
      throw Exception('grid doit être une liste');
    }

    // Ici on s'assure d'initialiser grid avant tout appel à toJson().
    grid = List.generate(
      gridRows,
      (row) => List.generate(
        gridCols,
        (col) {
          var cellData = (gridData[row][col]);
          return Cell.fromJson(cellData);
        },
      ),
    );
  }

  Map<String, dynamic> toJson() {
    // Cette méthode suppose que grid est toujours initialisé.
    return {
      'id': id,
      'gridRows': gridRows,
      'gridCols': gridCols,
      'currentPlayer': currentPlayer,
      'totalPlayers': totalPlayers,
      'turn': turn,
      'totalAtoms': totalAtoms,
      'state': state.index,
      'title': title,
      'grid':
          grid.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
    };
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    super.onTapDown(event);
  }

  ExplodingAtomsInfos toGameInfos() {
    return ExplodingAtomsInfos(
      id: id,
      gridRows: gridRows,
      gridCols: gridCols,
      currentPlayer: currentPlayer,
      totalPlayers: totalPlayers,
      turn: turn,
      totalAtoms: totalAtoms,
      state: state,
      title: title,
    );
  }
}
