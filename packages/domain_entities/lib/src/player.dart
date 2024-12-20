import 'package:equatable/equatable.dart';

class Player extends Equatable {
  const Player({
    this.username = '',
    this.inventory = const [],
    this.profilePictureUrl,
  });

  final String username;
  final List<String> inventory;
  final String? profilePictureUrl;

  // Instance vide
  static final empty = Player();

  // Méthode pour créer une copie
  Player copyWith({
    String? username,
    List<String>? inventory,
    String? profilePictureUrl,
  }) {
    return Player(
      username: username ?? this.username,
      inventory: inventory ?? this.inventory,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  // Sérialisation vers JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'charactersIds': inventory,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Désérialisation depuis JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      username: json['username'] as String? ?? '',
      inventory: json['inventory'] != null
          ? List<String>.from(json['inventory'] as List)
          : [],
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [username, inventory, profilePictureUrl];
}
