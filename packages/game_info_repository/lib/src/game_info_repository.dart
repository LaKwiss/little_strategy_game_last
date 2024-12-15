import '../../game_info_repository.dart';

/// Repository to manage access to Firestore for ExplodingAtomsInfos.
class GameInfoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('GameInfoRepository');

  GameInfoRepository();

  /// Executes a Firestore operation safely and logs any errors.
  Future<T> _safeExecute<T>(Future<T> Function() action) async {
    try {
      _logger.info('Executing Firestore operation...');
      final result = await action();
      _logger.info('Firestore operation completed successfully.');
      return result;
    } catch (e, stackTrace) {
      _logger.severe('Firestore operation failed: $e', e, stackTrace);
      rethrow;
    }
  }

  /// Returns a stream of `ExplodingAtomsInfos` from the `gameInfos` collection.
  Stream<List<ExplodingAtomsInfos>> getGameInfosStream() {
    _logger.info('Listening to changes in the gameInfos collection...');
    return _firestore.collection('gameInfos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExplodingAtomsInfos.fromJson(doc.data(), id: doc.id);
      }).toList();
    });
  }

  /// Adds a new `ExplodingAtoms` game to the `gameInfos` collection.
  Future<void> addGame(ExplodingAtoms game) async {
    return await _safeExecute(() async {
      _logger.info('Adding a new game to the gameInfos collection.');
      await _firestore.collection('gameInfos').add(game.toJson());
      _logger.info('Game added successfully: ${game.toJson()}');
    });
  }

  /// Updates an existing game in the `gameInfos` collection.
  Future<void> updateGame(String id, Map<String, dynamic> updates) async {
    return await _safeExecute(() async {
      _logger.info('Updating game with ID $id.');
      await _firestore.collection('gameInfos').doc(id).update(updates);
      _logger.info('Game updated successfully: $updates');
    });
  }

  /// Deletes a game from the `gameInfos` collection.
  Future<void> deleteGame(String id) async {
    return await _safeExecute(() async {
      _logger.info('Deleting game with ID $id.');
      await _firestore.collection('gameInfos').doc(id).delete();
      _logger.info('Game deleted successfully.');
    });
  }

  /// Fetches all `ExplodingAtomsInfos` from the `gameInfos` collection as a one-time snapshot.
  Future<List<ExplodingAtomsInfos>> fetchAllGameInfos() async {
    return await _safeExecute(() async {
      _logger.info('Fetching all game infos as a one-time snapshot.');
      final snapshot = await _firestore.collection('gameInfos').get();
      final gameInfos = snapshot.docs.map((doc) {
        return ExplodingAtomsInfos.fromJson(doc.data(), id: doc.id);
      }).toList();
      _logger.info('Fetched ${gameInfos.length} game infos.');
      return gameInfos;
    });
  }
}
