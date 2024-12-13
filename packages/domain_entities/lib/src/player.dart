import 'package:collection/collection.dart'; // Pour comparer les listes

class Player {
  Player({
    this.username = '',
    this.uid = '',
    this.charactersIds = const [],
    this.profilePictureUrl,
  });

  String username;
  String uid;
  List<int> charactersIds;
  String? profilePictureUrl;

  // Instance vide
  static final empty = Player();

  // Opérateur d'égalité
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.username == username &&
        other.uid == uid &&
        const ListEquality<int>().equals(other.charactersIds, charactersIds) &&
        other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        uid.hashCode ^
        const ListEquality<int>().hash(charactersIds) ^
        profilePictureUrl.hashCode;
  }

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
}
