import 'package:domain_entities/domain_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_repository/game_repository.dart';
import 'package:logging/logging.dart';

part 'game_state.dart';

class GameNotifier extends StateNotifier<GameState> {
  final GameRepository repository;
  final _logger = Logger('GameNotifier');

  GameNotifier(this.repository) : super(GameState.initial());

  ExplodingAtoms findGameById(String id) {
    try {
      // TODO Implémenter la logique pour trouver le jeu par ID.
      throw UnimplementedError();
    } catch (e, stack) {
      _logger.severe('Error in findGameById: $e', e, stack);
      rethrow;
    }
  }

  Future<ExplodingAtoms> joinGame(String gameId, Player user) async {
    try {
      // TODO Implémenter la logique pour rejoindre un jeu.
      throw UnimplementedError();
    } catch (e, stack) {
      _logger.severe('Error in joinGame: $e', e, stack);
      rethrow;
    }
  }

  Future<List<ExplodingAtomsInfos>> getAllGameInfos() async {
    try {
      _logger.fine('Fetching all game infos...');
      List<ExplodingAtomsInfos> gameInfos = await repository.getAllGameInfos();
      state = state.copyWith(gameInfos: gameInfos);
      _logger.fine('Fetched ${gameInfos.length} game infos.');
      return gameInfos;
    } catch (e, stack) {
      _logger.severe('Error in getAllGameInfos: $e', e, stack);
      rethrow;
    }
  }

  Future<ExplodingAtoms> createGame(ExplodingAtoms game) async {
    try {
      _logger.fine('Creating a new game...');
      final createdGame = await repository.createGame(game);
      _logger.fine('Game created with id: ${createdGame.id}');
      return createdGame;
    } catch (e, stack) {
      _logger.severe('Error in createGame: $e', e, stack);
      rethrow;
    }
  }

  Future<ExplodingAtomsInfos> updateGameInfos(
      ExplodingAtomsInfos explodingAtomsInfos) async {
    try {
      _logger.fine('Updating game infos...');
      final updatedGameInfos =
          await repository.updateGameInfos(explodingAtomsInfos);
      _logger.fine('Game infos updated with id: ${updatedGameInfos.id}');
      return updatedGameInfos;
    } catch (e, stack) {
      _logger.severe('Error in updateGameInfos: $e', e, stack);
      rethrow;
    }
  }
}
