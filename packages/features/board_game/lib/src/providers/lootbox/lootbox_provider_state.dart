import 'package:domain_entities/domain_entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lootbox_provider_state.freezed.dart';

enum LootboxProviderStatus { initial, loading, success, error }

@freezed
class LootboxProviderState with _$LootboxProviderState {
  const factory LootboxProviderState({
    required LootboxProviderStatus status,
    required List<Loot> lootList,
    String? error,
  }) = _LootboxProviderState;

  factory LootboxProviderState.initial() => const LootboxProviderState(
        status: LootboxProviderStatus.initial,
        lootList: [],
        error: null,
      );
}
