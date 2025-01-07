import 'package:domain_entities/domain_entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lootbox_repository/lootbox_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'dart:math';

class MockRandom extends Mock implements Random {}

void main() {
  late LootboxRepository repository;
  late FirebaseFirestore firestore;
  late MockRandom mockRandom;

  final testLoot1 = Loot(
    id: '1',
    type: 'weapon',
    name: 'Test Sword',
    reference: 'test_sword',
    weight: 10.0,
  );

  final testLoot2 = Loot(
    id: '2',
    type: 'armor',
    name: 'Test Shield',
    reference: 'test_shield',
    weight: 5.0,
  );

  final commonLoot = Loot(
    id: '3',
    type: 'weapon',
    name: 'Common',
    reference: 'common_weapon',
    weight: 80.0,
  );

  final rareLoot = Loot(
    id: '4',
    type: 'weapon',
    name: 'Rare',
    reference: 'rare_weapon',
    weight: 20.0,
  );

  final invalidLoot = Loot(
    id: '5',
    type: 'weapon',
    name: 'Invalid',
    reference: 'invalid_weapon',
    weight: -1.0,
  );

  setUp(() {
    firestore = FakeFirebaseFirestore();
    mockRandom = MockRandom();
    repository = LootboxRepository(
      firestore: firestore,
      random: mockRandom,
    );
  });

  group('getAllLoot', () {
    test('should return sorted list of loot when collection is not empty',
        () async {
      await firestore.collection('lootbox').add(testLoot1.toJson());
      await firestore.collection('lootbox').add(testLoot2.toJson());

      final result = await repository.getAllLoot();

      expect(result.length, 2);
      expect(result[0].name, testLoot2.name);
      expect(result[1].name, testLoot1.name);
    });

    test('should throw exception when collection is empty', () {
      expect(() => repository.getAllLoot(), throwsException);
    });

    test('should throw when document has null name', () async {
      await firestore.collection('lootbox').add({
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getAllLoot(), throwsException);
    });

    test('should throw when document has empty name', () async {
      await firestore.collection('lootbox').add({
        'name': '',
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getAllLoot(), throwsA(isA<Exception>()));
    });
  });

  group('addLootToUser', () {
    test('should add loot and return with new id', () async {
      final addedLoot = await repository.addLootToUser(testLoot1, 'testUser');

      expect(addedLoot.id, isNotEmpty);
      expect(addedLoot.name, testLoot1.name);
      expect(addedLoot.type, testLoot1.type);
      expect(addedLoot.reference, testLoot1.reference);
      expect(addedLoot.weight, testLoot1.weight);

      final doc = await firestore
          .collection('users')
          .doc('testUser')
          .collection('lootbox')
          .doc(addedLoot.id)
          .get();

      expect(doc.exists, true);
      expect(doc.data(), addedLoot.toJson());
    });

    test('should throw on empty username', () {
      expect(() => repository.addLootToUser(testLoot1, ''), throwsException);
    });
  });

  group('getUserLoot', () {
    test('should return user loot sorted by name', () async {
      await repository.addLootToUser(testLoot1, 'testUser');
      await repository.addLootToUser(testLoot2, 'testUser');

      final result = await repository.getUserLoot('testUser');

      expect(result.length, 2);
      expect(result[0].name, testLoot2.name);
      expect(result[1].name, testLoot1.name);
    });

    test('should throw on empty username', () {
      expect(() => repository.getUserLoot(''), throwsException);
    });

    test('should throw when user has no loot', () {
      expect(() => repository.getUserLoot('nonexistentUser'), throwsException);
    });

    test('should throw when document has null name', () async {
      await firestore
          .collection('users')
          .doc('testUser')
          .collection('lootbox')
          .add({
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getUserLoot('testUser'), throwsException);
    });

    test('should throw when document has empty name', () async {
      await firestore
          .collection('users')
          .doc('testUser')
          .collection('lootbox')
          .add({
        'name': '',
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getUserLoot('testUser'), throwsException);
    });
  });

  group('getRandomLoot', () {
    test('should select common loot with 50% random value', () async {
      await firestore.collection('lootbox').add(commonLoot.toJson());
      await firestore.collection('lootbox').add(rareLoot.toJson());

      when(() => mockRandom.nextDouble()).thenReturn(0.5);

      final result = await repository.getRandomLoot();

      expect(result.name, 'Common');
      verify(() => mockRandom.nextDouble()).called(1);
    });

    test('should select rare loot with 90% random value', () async {
      await firestore.collection('lootbox').add(commonLoot.toJson());
      await firestore.collection('lootbox').add(rareLoot.toJson());

      when(() => mockRandom.nextDouble()).thenReturn(0.9);

      final result = await repository.getRandomLoot();

      expect(result.name, 'Rare');
    });

    test('should throw when weights are invalid', () async {
      await firestore.collection('lootbox').add(invalidLoot.toJson());

      expect(() => repository.getRandomLoot(), throwsException);
    });

    test('should throw when collection is empty', () {
      expect(() => repository.getRandomLoot(), throwsException);
    });

    test('should throw when document has null name', () async {
      await firestore.collection('lootbox').add({
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getRandomLoot(), throwsException);
    });

    test('should throw when document has empty name', () async {
      await firestore.collection('lootbox').add({
        'name': '',
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getRandomLoot(), throwsException);
    });
  });

  group('addLoot', () {
    test('should add loot to global collection', () async {
      final addedLoot = await repository.addLoot(testLoot1);

      expect(addedLoot.id, isNotEmpty);
      expect(addedLoot.name, testLoot1.name);

      final doc = await firestore.collection('lootbox').doc(addedLoot.id).get();

      expect(doc.exists, true);
      expect(doc.data(), addedLoot.toJson());
    });
  });

  group('updateLoot', () {
    test('should update existing loot', () async {
      final addedLoot = await repository.addLoot(testLoot1);
      final updatedLoot = addedLoot.copyWith(name: 'Updated Sword');

      final result = await repository.updateLoot(updatedLoot);

      expect(result.name, 'Updated Sword');

      final doc = await firestore.collection('lootbox').doc(result.id).get();

      expect(doc.data(), result.toJson());
    });

    test('should throw when updating non-existent loot', () {
      final nonExistentLoot = testLoot1.copyWith(id: 'non-existent');
      expect(() => repository.updateLoot(nonExistentLoot), throwsException);
    });
  });

  group('getLoot', () {
    test('should return specific loot by id', () async {
      final addedLoot = await repository.addLoot(testLoot1);

      final result = await repository.getLoot(addedLoot.id);

      expect(result.id, addedLoot.id);
      expect(result.name, addedLoot.name);
      expect(result.type, addedLoot.type);
      expect(result.reference, addedLoot.reference);
      expect(result.weight, addedLoot.weight);
    });

    test('should throw on empty id', () {
      expect(() => repository.getLoot(''), throwsException);
    });

    test('should throw when loot not found', () {
      expect(() => repository.getLoot('non-existent'), throwsException);
    });

    test('should throw when document has null name', () async {
      final docRef = firestore.collection('lootbox').doc();
      await docRef.set({
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      });

      expect(() => repository.getLoot(docRef.id), throwsException);
    });
  });

  group('lootStreamForUser', () {
    test('should throw on empty username', () {
      expect(() => repository.lootStreamForUser('').listen((event) {}),
          throwsException);
    });

    test('should emit error when document has invalid data', () async {
      final invalidData = {
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      };

      await firestore
          .collection('users')
          .doc('testUser')
          .collection('lootbox')
          .add(invalidData);

      expect(
        repository.lootStreamForUser('testUser'),
        emitsError(isA<Exception>()),
      );
    });

    test('should emit error when document has empty name', () async {
      final invalidData = {
        'name': '',
        'type': 'weapon',
        'reference': 'ref',
        'weight': 1.0,
      };

      await firestore
          .collection('users')
          .doc('testUser')
          .collection('lootbox')
          .add(invalidData);

      expect(
        repository.lootStreamForUser('testUser'),
        emitsError(isA<Exception>()),
      );
    });
  });
}
