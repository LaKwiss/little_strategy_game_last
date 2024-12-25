import 'package:domain_entities/domain_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a player in the game with their profile information and inventory
@immutable
class Player extends Equatable {
  static const Player empty = Player();

  final String username;
  final List<String> inventory;
  final String? profilePictureUrl;
  final ProfileData? profileData;

  const Player({
    this.username = '',
    this.inventory = const [],
    this.profilePictureUrl,
    this.profileData,
  }) : assert(username.length <= 50, 'Username must be 50 chars or less');

  Player copyWith({
    String? username,
    List<String>? inventory,
    String? profilePictureUrl,
    ProfileData? profileData,
  }) =>
      Player(
        username: username ?? this.username,
        inventory: inventory ?? this.inventory,
        profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
        profileData: profileData ?? this.profileData,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'inventory': inventory,
        'profilePictureUrl': profilePictureUrl,
        'profileData': profileData?.toJson(),
      };

  factory Player.fromJson(Map<String, dynamic> json) {
    try {
      return Player(
        username: json['username'] as String? ?? '',
        inventory: (json['inventory'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        profilePictureUrl: json['profilePictureUrl'] as String?,
        profileData: json['profileData'] != null
            ? ProfileData.fromJson(json['profileData'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      return empty;
    }
  }

  @override
  List<Object?> get props => [
        username,
        inventory,
        profilePictureUrl,
        profileData,
      ];
}
