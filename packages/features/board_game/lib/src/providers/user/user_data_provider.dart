import 'package:board_game/board_game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [authProvider] est le Provider de l'utilisateur connecté, si l'utilisateur n'est pas connecté, la valeur est `null`
final authProvider = StreamProvider<User?>((ref) {
  final userRemoteRepository = ref.watch(userRepostioryProvider);
  return userRemoteRepository.authStateChanges();
});
