part of 'lootbox_notifier.dart';

enum LootboxProviderStatus { initial, loading, success, error }

class LootboxProviderState extends Equatable {
  final LootboxProviderStatus status;
  final List<Loot> lootList;
  final bool isError;
  final String error;

  const LootboxProviderState({
    this.status = LootboxProviderStatus.initial,
    this.lootList = const [],
    this.isError = false,
    this.error = '',
  });

  LootboxProviderState copyWith({
    LootboxProviderStatus? status,
    List<Loot>? lootList,
    bool? isError,
    String? error,
  }) {
    return LootboxProviderState(
      status: status ?? this.status,
      lootList: lootList ?? this.lootList,
      isError: isError ?? this.isError,
      error: error ?? this.error,
    );
  }

  static LootboxProviderState initial() {
    return LootboxProviderState();
  }

  @override
  List<Object?> get props => [lootList, isError, error];
}
