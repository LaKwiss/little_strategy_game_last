import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_repository/game_repository.dart';
import 'package:riverpod/riverpod.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRemoteRepository(
    FirebaseFirestore.instance,
  );
});
