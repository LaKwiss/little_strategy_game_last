import 'package:domain_entities/domain_entities.dart';

abstract class GameRepository {
  Future<List<ExplodingAtoms>> getAllGames();
  Future<ExplodingAtoms> getGame(String id);
  Future<ExplodingAtoms> createGame(ExplodingAtoms game);
  Future<ExplodingAtoms> updateGame(ExplodingAtoms game);
  Future<ExplodingAtoms> deleteGame(String id);
  Future<List<ExplodingAtomsInfos>> getAllGameInfos();
  Stream<ExplodingAtoms> gameStream(String id);

  Future<ExplodingAtomsInfos> getGameInfos(String gameId);
  Future<ExplodingAtomsInfos> updateGameInfos(ExplodingAtomsInfos gameInfos);
}
