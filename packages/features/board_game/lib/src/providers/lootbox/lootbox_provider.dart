import 'package:board_game/src/providers/lootbox/lootbox_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lootboxProvider =
    StateNotifierProvider<LootboxProviderNotifier, LootboxProviderState>((ref) {
  LootboxProviderNotifier lootboxProviderNotifier = LootboxProviderNotifier();
  return lootboxProviderNotifier;
});
