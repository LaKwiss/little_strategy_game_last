import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:logging/logging.dart';

class LootboxRepository {
  final String lootboxCollection = 'lootbox';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('LootboxRepository');

  LootboxRepository();

  Future<T> _safeExecute<T>(
      Future<T> Function() operation, String operationName) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      _logger.severe('Error during $operationName', e, stackTrace);
      rethrow; // rethrow to allow higher-level handling if necessary
    }
  }

  Future<List<Loot>> getAllLoot() async {
    return await _safeExecute(() async {
      final snapshot = await _firestore.collection(lootboxCollection).get();
      final lootboxes = snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList();
      lootboxes.sort((a, b) => a.name.compareTo(b.name));
      return lootboxes;
    }, 'getAllLoot');
  }

  Future<List<Loot>> getUserLoot(String userId) async {
    return await _safeExecute(() async {
      final snapshot = await _firestore
          .collection(lootboxCollection)
          .where('userId', isEqualTo: userId)
          .get();
      final lootboxes = snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList();
      lootboxes.sort((a, b) => a.name.compareTo(b.name));
      return lootboxes;
    }, 'getUserLoot');
  }

  Future<Loot> addLoot(Loot loot) async {
    loot.copyWith(id: _firestore.collection(lootboxCollection).id);
    await _safeExecute(() async {
      await _firestore.collection(lootboxCollection).add(loot.toJson()).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Timeout while adding loot'));
    }, 'addLoot');
    return loot;
  }

  Future<Loot> addLootToUser(Loot loot, String username) async {
    loot.copyWith(id: _firestore.collection(lootboxCollection).id);
    await _safeExecute(() async {
      await _firestore.collection(lootboxCollection).add(loot.toJson()).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Timeout while adding loot'));
    }, 'addLootToUser');
    return loot;
  }

  Future<Loot> getRandomLoot() async {
    return await _safeExecute(() async {
      final snapshot = await _firestore.collection(lootboxCollection).get();
      final lootList = snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList();

      if (lootList.isEmpty) {
        throw Exception('Aucun loot disponible');
      }

      double totalWeight = lootList.fold(
        0.0,
        (sum, loot) => sum + loot.weight,
      );

      final random = Random().nextDouble() * totalWeight;

      double cumulativeWeight = 0.0;
      for (final loot in lootList) {
        cumulativeWeight += loot.weight;
        if (random <= cumulativeWeight) {
          return loot;
        }
      }

      throw Exception('Impossible de sélectionner un loot');
    }, 'getRandomLoot');
  }
}
