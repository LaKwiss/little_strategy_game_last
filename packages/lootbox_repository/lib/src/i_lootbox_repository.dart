import 'package:domain_entities/domain_entities.dart';

/// Abstract interface for the lootbox repository
abstract class ILootboxRepository {
  Future<List<Loot>> getAllLoot();
  Future<Loot> addLootToUser(Loot loot, String username);
  Future<List<Loot>> getUserLoot(String username);
  Future<Loot> getRandomLoot();
  Future<Loot> addLoot(Loot loot);
  Future<Loot> updateLoot(Loot loot);
  Future<Loot> getLoot(String lootId);
  Stream<List<Loot>> lootStreamForUser(String username);
}
