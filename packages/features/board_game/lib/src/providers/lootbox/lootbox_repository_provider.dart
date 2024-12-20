import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lootbox_repository/lootbox_repository.dart';

final lootBoxRepositoryProvider = Provider<LootboxRepository>((ref) {
  return LootboxRepository();
});
