import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:lootbox_repository/src/i_lootbox_repository.dart';

class LootboxRepository implements ILootboxRepository {
  final FirebaseFirestore _firestore;
  final Random _random;

  LootboxRepository({
    FirebaseFirestore? firestore,
    Random? random,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _random = random ?? Random();

  /// Private helper method to map Firestore documents to Loot objects
  List<Loot> _mapDocsToLoot(QuerySnapshot snapshot) {
    final lootList = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['name'] == null || data['name'].isEmpty) {
        developer.log('Loot item with ID ${doc.id} has a null name');
        throw Exception('Loot item with ID ${doc.id} has a null name');
      }
      return Loot.fromJson(data, doc.id);
    }).toList();

    if (lootList.isEmpty) {
      developer.log('No loot available in the collection');
      throw Exception('No loot available');
    }

    lootList.sort((a, b) => a.name.compareTo(b.name));
    return lootList;
  }

  /// Private helper method to validate username
  void _validateUsername(String username) {
    if (username.isEmpty) {
      developer.log('Username cannot be null or empty');
      throw Exception('Invalid username');
    }
  }

  @override
  Future<List<Loot>> getAllLoot() async {
    final snapshot = await _firestore
        .collection('lootbox')
        .get()
        .onError((error, stackTrace) {
      developer.log('Error fetching all loot',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to fetch loot: $error');
    });

    return _mapDocsToLoot(snapshot);
  }

  @override
  Future<Loot> addLootToUser(Loot loot, String username) async {
    _validateUsername(username);

    final userLootCollection =
        _firestore.collection('users').doc(username).collection('lootbox');
    final docRef = userLootCollection.doc();
    final lootWithId = loot.copyWith(id: docRef.id);

    await docRef.set(lootWithId.toJson()).onError((error, stackTrace) {
      developer.log('Error adding loot to user $username',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to add loot: $error');
    });

    return lootWithId;
  }

  @override
  Future<List<Loot>> getUserLoot(String username) async {
    _validateUsername(username);

    final snapshot = await _firestore
        .collection('users')
        .doc(username)
        .collection('lootbox')
        .get()
        .onError((error, stackTrace) {
      developer.log('Error fetching loot for user $username',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to fetch user loot: $error');
    });

    return _mapDocsToLoot(snapshot);
  }

  @override
  Future<Loot> getRandomLoot() async {
    final snapshot = await _firestore
        .collection('lootbox')
        .get()
        .onError((error, stackTrace) {
      developer.log('Error fetching loot for random selection',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to fetch loot: $error');
    });

    final lootList = _mapDocsToLoot(snapshot);

    final totalWeight = lootList.fold(0.0, (sum, loot) => sum + loot.weight);
    if (totalWeight <= 0) {
      developer.log('Invalid loot weights');
      throw Exception('Invalid loot weights');
    }

    final randomValue = _random.nextDouble() * totalWeight;
    double cumulativeWeight = 0.0;

    for (final loot in lootList) {
      cumulativeWeight += loot.weight;
      if (randomValue <= cumulativeWeight) {
        return loot;
      }
    }

    developer.log('Failed to select a random loot');
    throw Exception('Failed to select a random loot');
  }

  @override
  Future<Loot> addLoot(Loot loot) async {
    final docRef = _firestore.collection('lootbox').doc();
    final lootWithId = loot.copyWith(id: docRef.id);

    await docRef.set(lootWithId.toJson()).onError((error, stackTrace) {
      developer.log('Error adding loot to global collection',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to add loot: $error');
    });

    return lootWithId;
  }

  @override
  Future<Loot> updateLoot(Loot loot) async {
    await _firestore
        .collection('lootbox')
        .doc(loot.id)
        .update(loot.toJson())
        .onError((error, stackTrace) {
      developer.log('Error updating loot with ID ${loot.id}',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to update loot: $error');
    });

    return loot;
  }

  @override
  Future<Loot> getLoot(String lootId) async {
    if (lootId.isEmpty) {
      developer.log('Loot ID cannot be null or empty');
      throw Exception('Invalid loot ID');
    }

    final snapshot = await _firestore
        .collection('lootbox')
        .doc(lootId)
        .get()
        .onError((error, stackTrace) {
      developer.log('Error fetching loot with ID $lootId',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to fetch loot: $error');
    });

    if (!snapshot.exists) {
      developer.log('Loot with ID $lootId not found');
      throw Exception('Loot not found');
    }

    final data = snapshot.data()!;
    if (data['name'] == null) {
      developer.log('Loot item with ID $lootId has a null name');
      throw Exception('Loot item with ID $lootId has a null name');
    }

    return Loot.fromJson(data, snapshot.id);
  }

  @override
  Stream<List<Loot>> lootStreamForUser(String username) {
    _validateUsername(username);

    return _firestore
        .collection('users')
        .doc(username)
        .collection('lootbox')
        .snapshots()
        .handleError((error, stackTrace) {
      developer.log('Error in loot stream for user $username',
          error: error, stackTrace: stackTrace);
      throw Exception('Failed to stream loot: $error');
    }).map((snapshot) => _mapDocsToLoot(snapshot));
  }
}
