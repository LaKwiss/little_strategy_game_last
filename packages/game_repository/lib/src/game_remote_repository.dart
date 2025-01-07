import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/foundation.dart';
import 'package:game_repository/game_repository.dart';
import 'package:logging/logging.dart';

class GameRemoteRepository implements GameRepository {
  final gamesNode = 'games';

  late FirebaseFirestore _firestore;

  final _logger = Logger('GameRemoteRepository');

  GameRemoteRepository(
    FirebaseFirestore firestoreDatabase,
  ) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print(
            '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
      }
    });

    _firestore = firestoreDatabase;
  }

  @override
  Future<List<ExplodingAtoms>> getAllGames() async {
    try {
      _logger.fine('Fetching all games...');
      final querySnapshot = await _firestore.collection('games').get();
      final gamesList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ExplodingAtoms.fromJson(data..['id'] = doc.id);
      }).toList();
      _logger.fine('Fetched ${gamesList.length} games.');
      return gamesList;
    } catch (e, stack) {
      _logger.severe('Error in getAllGames: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ExplodingAtoms> getGame(String id) async {
    try {
      _logger.fine('Fetching game with id: $id');
      final doc = await _firestore.collection('games').doc(id).get();
      if (!doc.exists) {
        _logger.warning('Game with id $id not found.');
        throw Exception('Game not found');
      }
      final data = doc.data();
      if (data == null) {
        _logger.severe('Data is null for game with id: $id');
        throw Exception('Game data is null');
      }
      return ExplodingAtoms.fromJson(data..['id'] = doc.id);
    } catch (e, stack) {
      _logger.severe('Error in getGame: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ExplodingAtoms> createGame(ExplodingAtoms game) async {
    try {
      _logger.fine('Creating a new game...');
      final ExplodingAtomsInfos gameInfos = game.toGameInfos();

      final gameInfosRef =
          await _firestore.collection('gameInfos').add(gameInfos.toJson());
      _logger.fine('GameInfos created with id: ${gameInfosRef.id}');

      final gameRef = await _firestore.collection('games').add(game.toJson());
      _logger.fine('Game created with id: ${gameRef.id}');

      await gameRef.update({'gameInfosRef': gameInfosRef.id});
      _logger.fine('Game updated with gameInfosRef: ${gameInfosRef.id}');

      await gameInfosRef.update({'gameRef': gameRef.id});
      _logger.fine('GameInfos updated with gameRef: ${gameRef.id}');

      return game;
    } catch (e, stack) {
      _logger.severe('Error in createGame: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ExplodingAtoms> updateGame(ExplodingAtoms game) async {
    try {
      _logger.fine('Updating game with id: ${game.id}');
      if (game.id.isEmpty) {
        _logger.severe('Game id is null or empty, cannot update game.');
        throw Exception('Game id is null or empty');
      }

      await _firestore.collection('games').doc(game.id).update(game.toJson());
      _logger.fine('Game with id: ${game.id} updated successfully.');
      return game;
    } catch (e, stack) {
      _logger.severe('Error in updateGame: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ExplodingAtoms> deleteGame(String id) async {
    try {
      _logger.fine('Deleting game with id: $id');
      final doc = await _firestore.collection('games').doc(id).get();
      if (!doc.exists) {
        _logger.warning('Cannot delete game with id $id, it does not exist.');
        throw Exception('Game not found');
      }

      // On récupère les données avant de supprimer le document
      final data = doc.data();
      if (data == null) {
        _logger.warning(
            'Data was null for game id: $id, cannot return a valid Game object.');
        throw Exception('Game data was null');
      }

      await _firestore.collection('games').doc(id).delete();
      _logger.fine('Game with id: $id deleted successfully.');

      return ExplodingAtoms.fromJson(data..['id'] = doc.id);
    } catch (e, stack) {
      _logger.severe('Error in deleteGame: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<List<ExplodingAtomsInfos>> getAllGameInfos() async {
    try {
      _logger.fine('Fetching all game infos...');
      final querySnapshot = await _firestore.collection('gameInfos').get();
      final gameInfosList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ExplodingAtomsInfos.fromJson(data, id: doc.id);
      }).toList();
      _logger.fine('Fetched ${gameInfosList.length} game infos.');
      return gameInfosList;
    } catch (e, stack) {
      _logger.severe('Error in getAllGameInfos: $e', e, stack);
      rethrow;
    }
  }

  @override
  Stream<ExplodingAtoms> gameStream(String id) {
    try {
      _logger.fine('Listening to game updates for id: $id');

      return _firestore
          .collection('games')
          .doc(id)
          .snapshots()
          .map((docSnapshot) {
        if (!docSnapshot.exists) {
          _logger.warning('Game with id $id does not exist.');
          throw Exception('Game not found');
        }

        final data = docSnapshot.data();
        if (data == null) {
          _logger.severe('No data found for game with id: $id');
          throw Exception('Game data is null');
        }

        final game = ExplodingAtoms.fromJson(data..['id'] = docSnapshot.id);
        _logger.fine('Received update for game: ${game.id}');
        return game;
      }).handleError((error, stackTrace) {
        _logger.severe(
            'Error in gameStream for id $id: $error', error, stackTrace);
        throw error;
      });
    } catch (e, stack) {
      _logger.severe(
          'Failed to initialize gameStream for id $id: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ExplodingAtomsInfos> getGameInfos(String gameId) async {
    try {
      _logger.fine('Fetching game infos for game $gameId...');
      final doc = await _firestore.collection('gameInfos').doc(gameId).get();
      if (!doc.exists) {
        _logger.warning('Game infos for game $gameId not found.');
        throw Exception('Game infos not found');
      }
      final data = doc.data();
      if (data == null) {
        _logger.severe('Data is null for game infos with id: $gameId');
        throw Exception('Game infos data is null');
      }
      return ExplodingAtomsInfos.fromJson(data, id: doc.id);
    } catch (e, stack) {
      _logger.severe('Error in getGameInfos: $e', e, stack);
      rethrow;
    }
  }

  @override
  Future<ExplodingAtomsInfos> updateGameInfos(
      ExplodingAtomsInfos explodingAtomsInfos) async {
    try {
      _logger.fine('Updating game infos for game ${explodingAtomsInfos.id}...');
      await _firestore
          .collection('gameInfos')
          .doc(explodingAtomsInfos.id)
          .update(explodingAtomsInfos.toJson());
      _logger.fine('Game infos updated for game ${explodingAtomsInfos.id}.');

      return explodingAtomsInfos;
    } catch (e, stack) {
      _logger.severe('Error in updateGameInfos: $e', e, stack);
      rethrow;
    }
  }
}
