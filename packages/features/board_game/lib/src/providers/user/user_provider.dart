import 'package:board_game/src/providers/user/state_repository_provider.dart';
import 'package:board_game/src/providers/user/user_repository_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'user_notifier.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(userRepostioryProvider);
  final stateRepository = ref.watch(stateRepositoryProvider);
  return UserNotifier(repository, stateRepository);
});
