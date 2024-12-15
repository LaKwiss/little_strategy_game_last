part of 'user_notifier.dart';

enum UserStateStatus { initial, loading, success, error }

class UserState extends Equatable {
  final UserStateStatus status;
  final String? errorMessage;
  final Player? currentPlayer;
  final List<Player> players;
  final List<String> profilePictures;

  const UserState({
    required this.status,
    this.errorMessage,
    this.currentPlayer,
    this.players = const [],
    this.profilePictures = const [],
  });

  factory UserState.initial() {
    return const UserState(status: UserStateStatus.initial);
  }

  UserState copyWith({
    UserStateStatus? status,
    String? errorMessage,
    Player? currentPlayer,
    List<Player>? players,
    List<String>? profilePictures,
  }) {
    return UserState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      players: players ?? this.players,
      profilePictures: profilePictures ?? this.profilePictures,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        currentPlayer,
        players,
        profilePictures,
      ];

  UserStateLM toUserStateLM() {
    return UserStateLM(
      status: status.index,
      errorMessage: errorMessage,
      currentPlayer: currentPlayer?.toLocalModel() ?? PlayerLM.empty,
      players: players.map((e) => e.toLocalModel()).toList(),
      profilePictures: profilePictures,
    );
  }

  static UserState fromUserStateLM(UserStateLM? userStateLM) {
    if (userStateLM == null) {
      return UserState.initial();
    }
    return UserState(
      status: UserStateStatus.values[userStateLM.status],
      errorMessage: userStateLM.errorMessage,
      currentPlayer: Player.fromLocalModel(userStateLM.currentPlayer),
      players: userStateLM.players
          .map<Player>((e) => Player.fromLocalModel(e))
          .toList(),
      profilePictures: userStateLM.profilePictures,
    );
  }
}
