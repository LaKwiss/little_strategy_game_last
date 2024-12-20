import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:lootbox_repository/lootbox_repository.dart';

part 'lootbox_provider_state.dart';

class LootboxProviderNotifier extends StateNotifier<LootboxProviderState> {
  final LootboxRepository _repository;
  final Logger _logger = Logger('LootboxProviderNotifier');

  LootboxProviderNotifier(this._repository)
      : super(LootboxProviderState.initial());

  Future<T> _safeExecute<T>(Future<T> Function() action) async {
    try {
      _setStateLoading();
      final result = await action();
      _setStateSuccess();
      return result;
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
      rethrow;
    }
  }

  /// Met l'état en mode chargement
  void _setStateLoading() {
    if (state.status != LootboxProviderStatus.loading) {
      state = state.copyWith(status: LootboxProviderStatus.loading);
    }
  }

  /// Met l'état en mode succès
  void _setStateSuccess() {
    state = state.copyWith(status: LootboxProviderStatus.success);
  }

  /// Gère les erreurs
  void _handleError(Object error, StackTrace stackTrace) {
    _logger.severe('Error: $error', error, stackTrace);
    state = state.copyWith(
      status: LootboxProviderStatus.error,
      error: error.toString(),
    );
  }

  /// Récupère les loots d'un utilisateur spécifique via `getLootFromUser`
  Future<List<Loot>> getLootFromUser(String username) async {
    return _safeExecute(() async {
      final loots = await _repository.getLootFromUser(username);
      state = state.copyWith(lootList: loots);
      return loots;
    });
  }

  /// Récupère les loots pour l'utilisateur actuellement connecté
  Future<void> fetchLootList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.displayName == null) {
      throw Exception('Utilisateur non connecté ou sans displayName.');
    }

    return _safeExecute(() async {
      final lootList = await _repository.getLootFromUser(user.displayName!);
      state = state.copyWith(lootList: lootList);
    });
  }

  /// Ajoute un loot à un utilisateur spécifique
  Future<Loot> addLootToUser(Loot loot, String username) async {
    return _safeExecute(() async {
      final addedLoot = await _repository.addLootToUser(loot, username);
      state = state.copyWith(lootList: [...state.lootList, addedLoot]);
      return addedLoot;
    });
  }

  /// Récupère un loot aléatoire
  Future<Loot> getRandomLoot() async {
    return _safeExecute(() async {
      return await _repository.getRandomLoot();
    });
  }

  /// Crée un nouveau loot
  Future<Loot> createLoot(Loot loot) async {
    return _safeExecute(() async {
      final newLoot = await _repository.addLoot(loot);
      state = state.copyWith(lootList: [...state.lootList, newLoot]);
      return newLoot;
    });
  }

  /// Met à jour un loot existant
  Future<Loot> updateLoot(Loot loot) async {
    return _safeExecute(() async {
      final updatedLoot = await _repository.updateLoot(loot);
      final updatedList = state.lootList.map((e) {
        return e.id == updatedLoot.id ? updatedLoot : e;
      }).toList();
      state = state.copyWith(lootList: updatedList);
      return updatedLoot;
    });
  }
}
