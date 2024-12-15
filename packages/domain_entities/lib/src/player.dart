import 'package:equatable/equatable.dart';
import 'package:key_value_storage/key_value_storage.dart'; // Pour comparer les listes

class Player extends Equatable {
  const Player({
    this.username = '',
    this.uid = '',
    this.charactersIds = const [],
    this.profilePictureUrl,
  });

  final String username;
  final String uid;
  final List<int> charactersIds;
  final String? profilePictureUrl;

  // Instance vide
  static final empty = Player();

  // Méthode pour créer une copie
  Player copyWith({
    String? username,
    String? uid,
    List<int>? charactersIds,
    String? profilePictureUrl,
  }) {
    return Player(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      charactersIds: charactersIds ?? List<int>.from(this.charactersIds),
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  // Sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'charactersIds': charactersIds,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Désérialisation depuis JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      username: json['username'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      charactersIds: (json['charactersIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [username, uid, charactersIds, profilePictureUrl];

  PlayerLM toLocalModel() {
    return PlayerLM(
      username: username,
      uid: uid,
      charactersIds: charactersIds,
      profilePictureUrl: profilePictureUrl,
    );
  }

  static fromLocalModel(PlayerLM? currentPlayer) {
    if (currentPlayer == null) {
      return Player.empty;
    }
    return Player(
      username: currentPlayer.username,
      uid: currentPlayer.uid,
      charactersIds: currentPlayer.charactersIds,
      profilePictureUrl: currentPlayer.profilePictureUrl,
    );
  }
}
