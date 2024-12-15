import 'package:board_game/board_game.dart';
import 'package:key_value_storage/key_value_storage.dart';

class StateRepository {
  static const stateNode = 'state';

  StateRepository(this._keyValueStorage);

  final KeyValueStorage _keyValueStorage;

  Future<void> saveState(UserState userState) async {
    final box = await _keyValueStorage.stateBox;
    await box.put(stateNode, userState.toUserStateLM());
  }

  Future<UserState?> fetchState() async {
    final box = await _keyValueStorage.stateBox;
    final userStateLM = box.get(stateNode);
    return UserState.fromUserStateLM(userStateLM);
  }
}
