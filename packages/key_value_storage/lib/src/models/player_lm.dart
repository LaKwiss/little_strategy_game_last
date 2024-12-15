import 'package:hive/hive.dart';

part 'player_lm.g.dart';

@HiveType(typeId: 1)
class PlayerLM {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String uid;

  @HiveField(2)
  final List<int> charactersIds;

  @HiveField(3)
  final String? profilePictureUrl;

  PlayerLM({
    this.username = '',
    this.uid = '',
    this.charactersIds = const [],
    this.profilePictureUrl,
  });

  static final empty = PlayerLM();

  PlayerLM copyWith({
    String? username,
    String? uid,
    List<int>? charactersIds,
    String? profilePictureUrl,
  }) {
    return PlayerLM(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      charactersIds: charactersIds ?? List<int>.from(this.charactersIds),
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'charactersIds': charactersIds,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory PlayerLM.fromJson(Map<String, dynamic> json) {
    return PlayerLM(
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
