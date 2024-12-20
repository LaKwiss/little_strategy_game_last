import 'package:board_game/src/providers/lootbox/lootbox_repository_provider.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lootBoxStreamProvider = StreamProvider<List<Loot>>((ref) {
  final repository = ref.watch(lootBoxRepositoryProvider);
  return repository
      .lootStreamForUser(FirebaseAuth.instance.currentUser!.displayName!);
});
