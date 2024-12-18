import 'package:domain_entities/domain_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:lootbox_repository/lootbox_repository.dart';

part 'lootbox_provider_state.dart';

class LootboxProviderNotifier extends StateNotifier<LootboxProviderState> {
  final LootboxRepository _repository = LootboxRepository();
  LootboxProviderNotifier() : super(LootboxProviderState.initial());
  final Logger _logger = Logger('LootboxProviderNotifier');

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

  /// Updates the state to loading.
  void _setStateLoading() {
    state = state.copyWith(status: LootboxProviderStatus.loading);
  }

  /// Updates the state to success.
  void _setStateSuccess() {
    state = state.copyWith(status: LootboxProviderStatus.success);
  }

  /// Handles errors by logging and updating the state.
  void _handleError(Object error, StackTrace stackTrace) {
    _logger.severe('Error: $error', error, stackTrace);
    state = state.copyWith(
      status: LootboxProviderStatus.error,
      error: error.toString(),
    );
  }

  /// Fetches all lootboxes from the repository.
  Future<List<Loot>> fetchAllLootboxes() async {
    return _safeExecute(() async {
      final loots = await _repository.getAllLoot();
      state = state.copyWith(lootList: loots);
      return loots;
    });
  }

  /// Fetches all lootboxes from the repository for a specific user.
  Future<List<Loot>> fetchUserLootboxes(String username) async {
    return _safeExecute(() async {
      final loots = await _repository.getUserLoot(username);
      state = state.copyWith(lootList: loots);
      return loots;
    });
  }

  Future<Loot> getRandomLoot() async {
    return _safeExecute(() async {
      final loot = await _repository.getRandomLoot();
      return loot;
    });
  }

  Future<Loot> createLoot(Loot loot) async {
    return _safeExecute(() async {
      final newLoot = await _repository.addLoot(loot);
      state = state.copyWith(lootList: [...state.lootList, newLoot]);
      return newLoot;
    });
  }
}
