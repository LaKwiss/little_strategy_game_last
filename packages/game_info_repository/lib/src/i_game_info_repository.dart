import 'package:game_info_repository/game_info_repository.dart';
import 'package:game_info_repository/src/models/exploding_atoms_infos.dart';

/// Abstract interface for the game info repository
abstract class IGameInfoRepository {
  Stream<List<ExplodingAtomsInfos>> getGameInfosStream();
  Future<ExplodingAtomsInfos> addGame(ExplodingAtomsInfos gameInfo);
  Future<ExplodingAtomsInfos> updateGame(
      String id, Map<String, dynamic> updates);
  Future<ExplodingAtomsInfos> deleteGame(String id);
  Future<List<ExplodingAtomsInfos>> fetchAllGameInfos();
  Future<ExplodingAtomsInfos> getGameInfo(String id);
}
