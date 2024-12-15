import 'package:board_game/src/providers/game/game_infos_repository_provider.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameInfosStreamProvider =
    StreamProvider<List<ExplodingAtomsInfos>>((ref) {
  final repository = ref.watch(gameInfosRepositoryProvider);
  return repository.getGameInfosStream();
});
