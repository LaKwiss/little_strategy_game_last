import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storage_repository/storage_repository.dart';

final remoteStorageRepositoryProvider =
    Provider<RemoteStorageRepository>((ref) {
  return StorageRemoteRepository(
    FirebaseStorage.instance,
  );
});
