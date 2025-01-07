import 'package:flutter_test/flutter_test.dart';
import 'package:game_info_repository/game_info_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late GameInfoRepository repository;
  late FirebaseFirestore firestore;

  final testGame1 = ExplodingAtomsInfos(
    id: '1',
    gridRows: 6,
    gridCols: 6,
    currentPlayer: 1,
    totalPlayers: 2,
    turn: 1,
    totalAtoms: 0,
    state: 'PLAYING',
    title: 'Test Game 1',
    createdAt: DateTime(2024, 1, 1),
  );

  final testGame2 = ExplodingAtomsInfos(
    id: '2',
    gridRows: 8,
    gridCols: 8,
    currentPlayer: 2,
    totalPlayers: 4,
    turn: 5,
    totalAtoms: 10,
    state: 'FINISHED',
    title: 'Test Game 2',
    createdAt: DateTime(2024, 1, 2),
  );

  final invalidGame = ExplodingAtomsInfos(
    id: '3',
    gridRows: -1, // Invalid value
    gridCols: -1, // Invalid value
    currentPlayer: 1,
    totalPlayers: 2,
    turn: 1,
    totalAtoms: 0,
    state: '', // Invalid empty state
    title: '', // Invalid empty title
    createdAt: DateTime(2024, 1, 3),
  );

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = GameInfoRepository(firestore: firestore);
  });

  group('fetchAllGameInfos', () {
    test('should return sorted list of games when collection is not empty',
        () async {
      await firestore.collection('gameInfos').add(testGame1.toJson());
      await firestore.collection('gameInfos').add(testGame2.toJson());

      final result = await repository.fetchAllGameInfos();

      expect(result.length, 2);
      expect(result[0].createdAt, testGame1.createdAt);
      expect(result[1].createdAt, testGame2.createdAt);
    });

    test('should throw exception when collection is empty', () {
      expect(() => repository.fetchAllGameInfos(), throwsException);
    });

    test('should throw when document has invalid data', () async {
      // Missing required fields
      await firestore.collection('gameInfos').add({
        'gridRows': 6,
        'state': 'PLAYING',
        'createdAt': DateTime.now().toIso8601String(),
        // Missing other required fields
      });

      expect(() => repository.fetchAllGameInfos(), throwsException);
    });
  });

  group('addGame', () {
    test('should add game and return with new id', () async {
      final addedGame = await repository.addGame(testGame1);

      expect(addedGame.id, isNotEmpty);
      expect(addedGame.title, testGame1.title);
      expect(addedGame.state, testGame1.state);
      expect(addedGame.gridRows, testGame1.gridRows);
      expect(addedGame.gridCols, testGame1.gridCols);
      expect(addedGame.currentPlayer, testGame1.currentPlayer);
      expect(addedGame.totalPlayers, testGame1.totalPlayers);
      expect(addedGame.turn, testGame1.turn);
      expect(addedGame.totalAtoms, testGame1.totalAtoms);

      final doc =
          await firestore.collection('gameInfos').doc(addedGame.id).get();

      expect(doc.exists, true);
      expect(doc.data(), addedGame.toJson());
    });

    test('should throw when adding invalid game', () {
      expect(() => repository.addGame(invalidGame), throwsException);
    });
  });

  group('updateGame', () {
    test('should update existing game', () async {
      final addedGame = await repository.addGame(testGame1);
      final updates = {
        'title': 'Updated Title',
        'state': 'PAUSED',
      };

      final updatedGame = await repository.updateGame(addedGame.id, updates);

      expect(updatedGame.title, 'Updated Title');
      expect(updatedGame.state, 'PAUSED');

      final doc =
          await firestore.collection('gameInfos').doc(updatedGame.id).get();

      expect(doc.data(), updatedGame.toJson());
    });

    test('should throw when updating with empty id', () {
      expect(() => repository.updateGame('', {'state': 'FINISHED'}),
          throwsException);
    });

    test('should throw when updating non-existent game', () {
      expect(
        () => repository.updateGame('non-existent', {'state': 'FINISHED'}),
        throwsException,
      );
    });

    test('should throw when updating with invalid data', () async {
      final addedGame = await repository.addGame(testGame1);
      expect(
        () => repository.updateGame(addedGame.id, {'state': null}),
        throwsException,
      );
    });
  });

  group('deleteGame', () {
    test('should delete existing game and return deleted game info', () async {
      final addedGame = await repository.addGame(testGame1);
      final deletedGame = await repository.deleteGame(addedGame.id);

      expect(deletedGame.id, addedGame.id);
      expect(deletedGame.title, addedGame.title);

      final doc =
          await firestore.collection('gameInfos').doc(addedGame.id).get();

      expect(doc.exists, false);
    });

    test('should throw when deleting with empty id', () {
      expect(() => repository.deleteGame(''), throwsException);
    });

    test('should throw when deleting non-existent game', () {
      expect(() => repository.deleteGame('non-existent'), throwsException);
    });
  });

  group('getGameInfo', () {
    test('should return specific game by id', () async {
      final addedGame = await repository.addGame(testGame1);

      final result = await repository.getGameInfo(addedGame.id);

      expect(result.id, addedGame.id);
      expect(result.title, addedGame.title);
      expect(result.state, addedGame.state);
      expect(result.gridRows, addedGame.gridRows);
      expect(result.gridCols, addedGame.gridCols);
      expect(result.currentPlayer, addedGame.currentPlayer);
      expect(result.totalPlayers, addedGame.totalPlayers);
      expect(result.turn, addedGame.turn);
      expect(result.totalAtoms, addedGame.totalAtoms);
    });

    test('should throw on empty id', () {
      expect(() => repository.getGameInfo(''), throwsException);
    });

    test('should throw when game not found', () {
      expect(() => repository.getGameInfo('non-existent'), throwsException);
    });

    test('should throw when document has invalid data', () async {
      final docRef = firestore.collection('gameInfos').doc();
      await docRef.set({
        'gridRows': -1,
        'state': '',
        'createdAt': DateTime.now().toIso8601String(),
      });

      expect(() => repository.getGameInfo(docRef.id), throwsException);
    });
  });

  group('getGameInfosStream', () {
    test('should emit updated list when games change', () async {
      // Add initial game
      await repository.addGame(testGame1);

      // Create stream and listen
      final stream = repository.getGameInfosStream();

      expectLater(
        stream,
        emitsInOrder([
          // First emission with initial game
          predicate<List<ExplodingAtomsInfos>>((games) =>
              games.length == 1 && games.first.title == testGame1.title),
          // Second emission after adding another game
          predicate<List<ExplodingAtomsInfos>>((games) =>
              games.length == 2 &&
              games.any((g) => g.title == testGame2.title)),
        ]),
      );

      // Add second game to trigger stream update
      await repository.addGame(testGame2);
    });

    test('should emit error when document has invalid data', () async {
      await firestore.collection('gameInfos').add({
        'gridRows': 6,
        'state': 'PLAYING',
        'createdAt': DateTime.now().toIso8601String(),
        // Missing totalPlayers which is required
      });

      expect(
        repository.getGameInfosStream(),
        emitsError(isA<Exception>()),
      );
    });
  });
}
