import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:logging/logging.dart';

class LootboxRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('LootboxRepository');

  LootboxRepository();

  /// Exécution sécurisée des opérations avec gestion des erreurs
  Future<T> _safeExecute<T>(
      Future<T> Function() operation, String operationName) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      _logger.severe('Error during $operationName', e, stackTrace);
      rethrow;
    }
  }

  /// Récupère tous les loots disponibles (collection globale)
  Future<List<Loot>> getAllLoot() async {
    return _safeExecute(() async {
      final snapshot = await _firestore.collection('lootbox').get();
      return snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    }, 'getAllLoot');
  }

  /// Ajoute un loot pour un utilisateur spécifique dans une sous-collection
  Future<Loot> addLootToUser(Loot loot, String username) async {
    return _safeExecute(() async {
      final userLootCollection =
          _firestore.collection('users').doc(username).collection('lootbox');

      final docRef = userLootCollection.doc();
      final lootWithId = loot.copyWith(id: docRef.id);

      await docRef.set(lootWithId.toJson());
      return lootWithId;
    }, 'addLootToUser');
  }

  /// Récupère les loots d'un utilisateur spécifique
  Future<List<Loot>> getUserLoot(String username) async {
    return _safeExecute(() async {
      final snapshot = await _firestore
          .collection('users')
          .doc(username)
          .collection('lootbox')
          .get();
      return snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    }, 'getUserLoot');
  }

  /// Récupère un loot aléatoire basé sur les poids
  Future<Loot> getRandomLoot() async {
    return _safeExecute(() async {
      final snapshot = await _firestore.collection('lootbox').get();
      final lootList = snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList();

      if (lootList.isEmpty) {
        throw Exception('Aucun loot disponible');
      }

      final totalWeight = lootList.fold(0.0, (sum, loot) => sum + loot.weight);
      if (totalWeight <= 0) {
        throw Exception('Les poids des loots ne sont pas valides');
      }

      final randomValue = Random().nextDouble() * totalWeight;
      double cumulativeWeight = 0.0;

      for (final loot in lootList) {
        cumulativeWeight += loot.weight;
        if (randomValue <= cumulativeWeight) {
          return loot;
        }
      }

      throw Exception('Impossible de sélectionner un loot');
    }, 'getRandomLoot');
  }

  /// Ajoute un loot global dans la collection "lootbox"
  Future<Loot> addLoot(Loot loot) async {
    return _safeExecute(() async {
      final docRef = _firestore.collection('lootbox').doc();
      final lootWithId = loot.copyWith(id: docRef.id);

      await docRef.set(lootWithId.toJson());
      return lootWithId;
    }, 'addLoot');
  }

  /// Met à jour un loot existant dans la collection globale
  Future<Loot> updateLoot(Loot loot) async {
    return _safeExecute(() async {
      await _firestore.collection('lootbox').doc(loot.id).update(loot.toJson());
      return loot;
    }, 'updateLoot');
  }

  /// Récupère les loots d'un utilisateur basé sur Firestore (exemple via username)
  Future<List<Loot>> getLootFromUser(String username) async {
    return _safeExecute(() async {
      final snapshot = await _firestore
          .collection('users')
          .doc(username)
          .collection('lootbox')
          .get();
      return snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    }, 'getLootFromUser');
  }

  /// Récupère un loot spécifique via son ID
  Future<Loot> getLoot(String lootId) async {
    return _safeExecute(() async {
      final snapshot = await _firestore.collection('lootbox').doc(lootId).get();
      if (!snapshot.exists) {
        throw Exception('Loot introuvable avec l\'ID $lootId');
      }
      return Loot.fromJson(snapshot.data()!, snapshot.id);
    }, 'getLoot');
  }

  /// Stream des loots pour un utilisateur (mise à jour en temps réel)
  Stream<List<Loot>> lootStreamForUser(String username) {
    return _firestore
        .collection('users')
        .doc(username)
        .collection('lootbox')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Loot.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}
