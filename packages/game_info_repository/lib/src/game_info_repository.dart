import 'dart:async';
import 'dart:developer' as developer;
import 'package:game_info_repository/game_info_repository.dart';
import './i_game_info_repository.dart';

/// Repository to manage access to Firestore for ExplodingAtomsInfos.
/// Implements proper error handling, logging, and follows SOLID principles.
class GameInfoRepository implements IGameInfoRepository {
  final FirebaseFirestore _firestore;

  /// Constructor with dependency injection for better testability
  GameInfoRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Private helper method to map Firestore documents to ExplodingAtomsInfos objects
  List<ExplodingAtomsInfos> _mapDocsToGameInfos(QuerySnapshot snapshot) {
    final gameInfosList = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (!_validateGameInfoData(data)) {
        developer.log('Game info with ID ${doc.id} has invalid data');
        throw Exception('Game info with ID ${doc.id} has invalid data');
      }
      return ExplodingAtomsInfos.fromJson(data, id: doc.id);
    }).toList();

    if (gameInfosList.isEmpty) {
      developer.log('No game infos available in the collection');
      throw Exception('No game infos available');
    }

    gameInfosList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return gameInfosList;
  }

  /// Validates the game info data structure
  bool _validateGameInfoData(Map<String, dynamic> data) {
    final requiredFields = [
      'createdAt',
      'state',
      'title',
      'totalPlayers',
      'currentPlayer',
      'gridRows',
      'gridCols',
      'turn',
      'totalAtoms'
    ];

    // Vérifier que tous les champs requis sont présents et non null
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        developer.log('Missing or null required field: $field');
        return false;
      }
    }

    // Vérifications supplémentaires pour les valeurs valides
    if (data['gridRows'] < 1 ||
        data['gridCols'] < 1 ||
        data['totalPlayers'] < 1 ||
        data['currentPlayer'] < 1 ||
        data['turn'] < 1) {
      developer.log('Invalid numeric values in game data');
      return false;
    }

    if (data['state'].toString().isEmpty || data['title'].toString().isEmpty) {
      developer.log('Empty string values in game data');
      return false;
    }

    return true;
  }

  @override
  Future<ExplodingAtomsInfos> addGame(ExplodingAtomsInfos gameInfo) async {
    final gameData = gameInfo.toJson();
    if (!_validateGameInfoData(gameData)) {
      throw Exception('Invalid game data');
    }

    final docRef = _firestore.collection('gameInfos').doc();
    final gameInfoWithId = gameInfo.copyWith(id: docRef.id);

    await docRef.set(gameInfoWithId.toJson()).onError((error, stackTrace) {
      developer.log('Error adding game info to collection',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to add game info: $error');
    });

    return gameInfoWithId;
  }

  @override
  Future<ExplodingAtomsInfos> updateGame(
      String id, Map<String, dynamic> updates) async {
    if (id.isEmpty) {
      developer.log('Game ID cannot be empty');
      throw Exception('Invalid game ID');
    }

    // Récupérer le document actuel
    final currentDoc = await _firestore.collection('gameInfos').doc(id).get();
    if (!currentDoc.exists) {
      throw Exception('Game not found');
    }

    // Fusionner les mises à jour avec les données actuelles
    final currentData = currentDoc.data() as Map<String, dynamic>;
    final updatedData = Map<String, dynamic>.from(currentData)..addAll(updates);

    // Valider les données fusionnées
    if (!_validateGameInfoData(updatedData)) {
      throw Exception('Invalid update data');
    }

    await _firestore
        .collection('gameInfos')
        .doc(id)
        .update(updates)
        .onError((error, stackTrace) {
      developer.log('Error updating game with ID $id',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to update game: $error');
    });

    return await getGameInfo(id);
  }

  @override
  Stream<List<ExplodingAtomsInfos>> getGameInfosStream() {
    return _firestore
        .collection('gameInfos')
        .snapshots()
        .handleError((error, stackTrace) {
      developer.log('Error in game infos stream',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to stream game infos: $error');
    }).map((snapshot) => _mapDocsToGameInfos(snapshot));
  }

  @override
  Future<ExplodingAtomsInfos> deleteGame(String id) async {
    if (id.isEmpty) {
      developer.log('Game ID cannot be empty');
      throw Exception('Invalid game ID');
    }

    final gameInfo = await getGameInfo(id);

    await _firestore
        .collection('gameInfos')
        .doc(id)
        .delete()
        .onError((error, stackTrace) {
      developer.log('Error deleting game with ID $id',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to delete game: $error');
    });

    developer.log('Successfully deleted game with ID $id');
    return gameInfo;
  }

  @override
  Future<List<ExplodingAtomsInfos>> fetchAllGameInfos() async {
    final snapshot = await _firestore
        .collection('gameInfos')
        .get()
        .onError((error, stackTrace) {
      developer.log('Error fetching all game infos',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to fetch game infos: $error');
    });

    return _mapDocsToGameInfos(snapshot);
  }

  @override
  Future<ExplodingAtomsInfos> getGameInfo(String id) async {
    if (id.isEmpty) {
      developer.log('Game ID cannot be empty');
      throw Exception('Invalid game ID');
    }

    final snapshot = await _firestore
        .collection('gameInfos')
        .doc(id)
        .get()
        .onError((error, stackTrace) {
      developer.log('Error fetching game with ID $id',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to fetch game: $error');
    });

    if (!snapshot.exists) {
      developer.log('Game with ID $id not found');
      throw Exception('Game not found');
    }

    final data = snapshot.data()!;
    if (!_validateGameInfoData(data)) {
      developer.log('Game with ID $id has invalid data');
      throw Exception('Invalid game data');
    }

    return ExplodingAtomsInfos.fromJson(data, id: snapshot.id);
  }
}
