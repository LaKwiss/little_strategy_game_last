import 'package:board_game/src/providers/user/user_repository_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'user_notifier.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(userRepostioryProvider);
  return UserNotifier(repository);
});
