// Need to move into key_value_storage package

import 'package:board_game/board_game.dart';
import 'package:domain_entities/domain_entities.dart';

class UserState {
  final int status;
  final String? errorMessage;
  final Player? currentPlayer;
  final List<Player> players;
  final List<String> profilePictures;

  UserState({
    required this.status,
    this.errorMessage,
    this.currentPlayer,
    this.players = const [],
    this.profilePictures = const [],
  });

  static UserState fromUserState(UserState userState) {
    return UserState(
      status: userState.status,
      errorMessage: userState.errorMessage,
      currentPlayer: userState.currentPlayer,
      players: userState.players,
      profilePictures: userState.profilePictures,
    );
  }

  UserState toUserState() {
    return UserState(
      status: UserStateStatus.values[status].index,
      errorMessage: errorMessage,
      currentPlayer: currentPlayer,
      players: players,
      profilePictures: profilePictures,
    );
  }
}
