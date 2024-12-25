import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents user profile data including images and theme preferences
@immutable
class ProfileData extends Equatable {
  /// Default profile picture URL
  static const _defaultProfilePicture = 'https://picsum.photos/150/150';

  /// Default banner image URL
  static const _defaultBanner = 'https://picsum.photos/800/200';

  /// Default background color (blue shade 50)
  static const _defaultBackgroundColor = Color(0xFFE3F2FD);

  /// Main profile picture URL
  final String profilePictureUrl;

  /// Banner/cover image URL
  final String bannerUrl;

  /// Theme background color
  final Color backgroundColor;

  /// Collection of additional profile pictures
  final List<String> profilePictures;

  /// Creates a [ProfileData] instance
  /// Validates that profile picture URLs are non-empty
  ProfileData({
    required this.profilePictureUrl,
    required this.bannerUrl,
    required this.backgroundColor,
    required this.profilePictures,
  }) : assert(
          profilePictures.every((url) => url.isNotEmpty),
          'Profile picture URLs cannot be empty',
        );

  /// Creates initial [ProfileData] with default values
  factory ProfileData.initial() => ProfileData(
        profilePictureUrl: _defaultProfilePicture,
        bannerUrl: _defaultBanner,
        backgroundColor: _defaultBackgroundColor,
        profilePictures: const [],
      );

  /// Creates a copy with optionally updated fields
  ProfileData copyWith({
    String? profilePictureUrl,
    String? bannerUrl,
    Color? backgroundColor,
    List<String>? profilePictures,
  }) =>
      ProfileData(
        profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
        bannerUrl: bannerUrl ?? this.bannerUrl,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        profilePictures: profilePictures ?? this.profilePictures,
      );

  /// Creates [ProfileData] from JSON, returns initial data if parsing fails
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    try {
      return ProfileData(
        profilePictureUrl:
            json['profilePictureUrl'] as String? ?? _defaultProfilePicture,
        bannerUrl: json['bannerUrl'] as String? ?? _defaultBanner,
        backgroundColor: JsonColor.fromJson(
            json['backgroundColor'] as Map<String, dynamic>? ??
                _defaultBackgroundColor.toJson()),
        profilePictures: (json['profilePictures'] as List<dynamic>?)
                ?.map((e) => e as String)
                .where((url) => url.isNotEmpty)
                .toList() ??
            const [],
      );
    } catch (e) {
      return ProfileData.initial();
    }
  }

  /// Converts to JSON format
  Map<String, dynamic> toJson() => {
        'profilePictureUrl': profilePictureUrl,
        'bannerUrl': bannerUrl,
        'backgroundColor': backgroundColor.toJson(),
        'profilePictures': profilePictures,
      };

  @override
  List<Object?> get props => [
        profilePictureUrl,
        bannerUrl,
        backgroundColor,
        profilePictures,
      ];

  @override
  bool get stringify => true;
}

extension JsonColor on Color {
  /// Converts the Color object into a JSON-compatible Map.
  Map<String, int> toJson() => {
        'red': r.toInt(),
        'green': g.toInt(),
        'blue': b.toInt(),
        'alpha': a.toInt(),
      };

  /// Creates a Color object from a JSON Map.
  static Color fromJson(Map<String, dynamic> json) {
    // Validate and parse input values
    final alpha = _validateColorComponent(json['alpha'], 'alpha');
    final red = _validateColorComponent(json['red'], 'red');
    final green = _validateColorComponent(json['green'], 'green');
    final blue = _validateColorComponent(json['blue'], 'blue');

    return Color.fromARGB(alpha, red, green, blue);
  }

  /// Validates a color component value (0-255) from the JSON Map.
  static int _validateColorComponent(dynamic value, String name) {
    if (value == null) {
      throw ArgumentError('$name cannot be null');
    }
    if (value is! int) {
      throw ArgumentError('$name must be an integer');
    }
    if (value < 0 || value > 255) {
      throw RangeError.range(value, 0, 255, name);
    }
    return value;
  }
}
