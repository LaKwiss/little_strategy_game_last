import 'package:board_game/src/providers/user/key_value_storage_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_repository/state_repository.dart';

final stateRepositoryProvider = Provider<StateRepository>((ref) {
  return StateRepository(
    ref.watch(keyValueStorageProvider),
  );
});
