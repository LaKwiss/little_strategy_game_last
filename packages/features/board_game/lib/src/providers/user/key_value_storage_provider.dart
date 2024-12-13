import 'package:key_value_storage/key_value_storage.dart';
import 'package:riverpod/riverpod.dart';

final keyValueStorageProvider = Provider<KeyValueStorage>((ref) {
  return KeyValueStorage();
});
