import 'package:board_game/board_game.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:riverpod/riverpod.dart';

final gameStreamProvider =
    StreamProvider.family<ExplodingAtoms, String>((ref, gameId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.gameStream(gameId);
});
