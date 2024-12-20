import 'package:board_game/src/providers/lootbox/lootbox_notifier.dart';
import 'package:board_game/src/providers/lootbox/lootbox_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lootboxProvider =
    StateNotifierProvider<LootboxProviderNotifier, LootboxProviderState>((ref) {
  LootboxProviderNotifier lootboxProviderNotifier =
      LootboxProviderNotifier(ref.read(lootBoxRepositoryProvider));
  return lootboxProviderNotifier;
});
