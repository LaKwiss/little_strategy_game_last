import 'package:board_game/src/providers/game/game_repository_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'game_notifier.dart';

final gameStateProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return GameNotifier(repository);
});
