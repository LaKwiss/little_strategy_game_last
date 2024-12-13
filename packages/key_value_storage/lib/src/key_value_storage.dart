import 'package:key_value_storage/key_value_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class KeyValueStorage {
  static const bookBoxKey = 'state';

  KeyValueStorage({@visibleForTesting HiveInterface? hive})
      : _hive = hive ?? Hive {
    try {
      _hive.registerAdapter(UserStateLMAdapter());
    } catch (_) {
      throw Exception(
          'Vous ne pouvez avoir qu\'une seule instance de  [KeyValueStorage]');
    }
  }

  final HiveInterface _hive;

  Future<Box<UserStateLM>> get stateBox =>
      _openHiveBox<UserStateLM>(bookBoxKey);

  Future<Box<T>> _openHiveBox<T>(String boxKey) async {
    if (!_hive.isBoxOpen(boxKey)) {
      return await _hive.openBox<T>(boxKey);
    }
    return _hive.box<T>(boxKey);
  }
}
