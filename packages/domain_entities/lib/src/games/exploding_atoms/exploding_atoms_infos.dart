/// Represents the informations of the game.
class ExplodingAtomsInfos {
  final String id;
  final int gridRows;
  final int gridCols;
  final int currentPlayer;
  final int totalPlayers;
  final int turn;
  final int totalAtoms;
  final String state;
  final String title;
  final DateTime createdAt;

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
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ExplodingAtomsInfos.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) {
    return ExplodingAtomsInfos(
      id: json['id'] ?? id,
      gridRows: json['gridRows'],
      gridCols: json['gridCols'],
      currentPlayer: json['currentPlayer'],
      totalPlayers: json['totalPlayers'],
      turn: json['turn'],
      totalAtoms: json['totalAtoms'],
      state: json['state'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
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
      'state': state,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ExplodingAtomsInfos copyWith({
    String? id,
    int? gridRows,
    int? gridCols,
    int? currentPlayer,
    int? totalPlayers,
    int? turn,
    int? totalAtoms,
    String? state,
    String? title,
    DateTime? createdAt,
  }) {
    return ExplodingAtomsInfos(
      id: id ?? this.id,
      gridRows: gridRows ?? this.gridRows,
      gridCols: gridCols ?? this.gridCols,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      turn: turn ?? this.turn,
      totalAtoms: totalAtoms ?? this.totalAtoms,
      state: state ?? this.state,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
