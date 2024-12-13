import 'package:domain_entities/domain_entities.dart';

class ExplodingAtomsInfos {
  final String id;
  final int gridRows;
  final int gridCols;
  final int currentPlayer;
  final int totalPlayers;
  final int turn;
  final int totalAtoms;
  final ExplodingAtomsState state;
  final String title;

  ExplodingAtomsInfos({
    required this.id,
    required this.gridRows,
    required this.gridCols,
    required this.currentPlayer,
    required this.totalPlayers,
    required this.turn,
    required this.totalAtoms,
    required this.state,
    required this.title,
  });

  factory ExplodingAtomsInfos.fromJson(Map<String, dynamic> json) {
    int stateIndex = json['state'] ?? 0;
    if (stateIndex < 0 || stateIndex >= ExplodingAtomsState.values.length) {
      stateIndex = 0;
    }

    return ExplodingAtomsInfos(
      id: json['id'] as String,
      gridRows: json['gridRows'] as int,
      gridCols: json['gridCols'] as int,
      currentPlayer: json['currentPlayer'] as int,
      totalPlayers: json['totalPlayers'] as int,
      turn: json['turn'] as int,
      totalAtoms: json['totalAtoms'] as int,
      state: ExplodingAtomsState.values[stateIndex],
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
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
    };
  }
}
