part of 'lootbox_notifier.dart';

enum LootboxProviderStatus { initial, loading, success, error }

class LootboxProviderState {
  final LootboxProviderStatus status;
  final List<Loot> lootList;
  final String? error;

  LootboxProviderState({
    required this.status,
    required this.lootList,
    this.error,
  });

  factory LootboxProviderState.initial() {
    return LootboxProviderState(
      status: LootboxProviderStatus.initial,
      lootList: [],
      error: null,
    );
  }

  LootboxProviderState copyWith({
    LootboxProviderStatus? status,
    List<Loot>? lootList,
    String? error,
  }) {
    return LootboxProviderState(
      status: status ?? this.status,
      lootList: lootList ?? this.lootList,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'LootboxProviderState(status: $status, lootList: ${lootList.length}, error: $error)';
  }
}
