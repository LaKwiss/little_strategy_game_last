import 'package:board_game/src/providers/storage/storage_notifier.dart';
import 'package:board_game/src/providers/storage/remote_storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageProvider =
    StateNotifierProvider<StorageNotifier, StorageState>((ref) {
  StorageNotifier storageNotifier = StorageNotifier(
    remoteRepository: ref.watch(remoteStorageRepositoryProvider),
  );
  return storageNotifier;
});
