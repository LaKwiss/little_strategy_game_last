part of 'user_notifier.dart';

enum UserStateStatus { initial, loading, success, error }

class UserState extends Equatable {
  final UserStateStatus status;
  final String? errorMessage;
  final Player? currentPlayer;
  final List<Player> players;
  final List<String> profilePictures;
  final User? currentUser;

  const UserState({
    required this.status,
    this.errorMessage,
    this.currentPlayer,
    this.players = const [],
    this.profilePictures = const [],
    this.currentUser,
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
    User? currentUser,
  }) {
    return UserState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      players: players ?? this.players,
      profilePictures: profilePictures ?? this.profilePictures,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        currentPlayer,
        players,
        profilePictures,
        currentUser,
      ];

  UserStateLM toUserStateLM() {
    return UserStateLM(
      status: status.index,
      errorMessage: errorMessage,
      currentPlayer: currentPlayer,
      players: players,
      profilePictures: profilePictures,
    );
  }
}
