import 'package:game_info_repository/game_info_repository.dart';

final gameInfosRepositoryProvider = Provider<GameInfoRepository>((ref) {
  return GameInfoRepository();
});
