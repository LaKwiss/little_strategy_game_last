part of 'game_notifier.dart';

enum GameStatus { initial, loading, loaded, error }

class GameState extends Equatable {
  final List<ExplodingAtoms> games;
  final GameStatus status;
  final String error;
  final List<ExplodingAtomsInfos> gameInfos;

  const GameState({
    this.games = const [],
    this.status = GameStatus.initial,
    this.error = '',
    this.gameInfos = const [],
  });

  GameState copyWith({
    List<ExplodingAtoms>? games,
    GameStatus? status,
    String? error,
    List<ExplodingAtomsInfos>? gameInfos,
  }) {
    return GameState(
      games: games ?? this.games,
      status: status ?? this.status,
      error: error ?? this.error,
      gameInfos: gameInfos ?? this.gameInfos,
    );
  }

  @override
  List<Object?> get props => [games, status, error, gameInfos];

  @override
  bool get stringify => true;

  factory GameState.initial() {
    return const GameState();
  }
}
