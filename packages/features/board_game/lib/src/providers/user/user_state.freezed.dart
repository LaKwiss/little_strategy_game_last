// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserState {
  bool get isLoading => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  List<String> get profilePictures => throw _privateConstructorUsedError;
  List<Player> get players => throw _privateConstructorUsedError;
  Player? get currentPlayer => throw _privateConstructorUsedError;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStateCopyWith<UserState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
  @useResult
  $Res call(
      {bool isLoading,
      String error,
      User? user,
      List<String> profilePictures,
      List<Player> players,
      Player? currentPlayer});
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = null,
    Object? user = freezed,
    Object? profilePictures = null,
    Object? players = null,
    Object? currentPlayer = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      profilePictures: null == profilePictures
          ? _value.profilePictures
          : profilePictures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      players: null == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      currentPlayer: freezed == currentPlayer
          ? _value.currentPlayer
          : currentPlayer // ignore: cast_nullable_to_non_nullable
              as Player?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStateImplCopyWith<$Res>
    implements $UserStateCopyWith<$Res> {
  factory _$$UserStateImplCopyWith(
          _$UserStateImpl value, $Res Function(_$UserStateImpl) then) =
      __$$UserStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String error,
      User? user,
      List<String> profilePictures,
      List<Player> players,
      Player? currentPlayer});
}

/// @nodoc
class __$$UserStateImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateImpl>
    implements _$$UserStateImplCopyWith<$Res> {
  __$$UserStateImplCopyWithImpl(
      _$UserStateImpl _value, $Res Function(_$UserStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = null,
    Object? user = freezed,
    Object? profilePictures = null,
    Object? players = null,
    Object? currentPlayer = freezed,
  }) {
    return _then(_$UserStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      profilePictures: null == profilePictures
          ? _value._profilePictures
          : profilePictures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      players: null == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      currentPlayer: freezed == currentPlayer
          ? _value.currentPlayer
          : currentPlayer // ignore: cast_nullable_to_non_nullable
              as Player?,
    ));
  }
}

/// @nodoc

class _$UserStateImpl implements _UserState {
  const _$UserStateImpl(
      {this.isLoading = false,
      this.error = '',
      this.user,
      final List<String> profilePictures = const <String>[],
      final List<Player> players = const <Player>[],
      this.currentPlayer})
      : _profilePictures = profilePictures,
        _players = players;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String error;
  @override
  final User? user;
  final List<String> _profilePictures;
  @override
  @JsonKey()
  List<String> get profilePictures {
    if (_profilePictures is EqualUnmodifiableListView) return _profilePictures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_profilePictures);
  }

  final List<Player> _players;
  @override
  @JsonKey()
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final Player? currentPlayer;

  @override
  String toString() {
    return 'UserState(isLoading: $isLoading, error: $error, user: $user, profilePictures: $profilePictures, players: $players, currentPlayer: $currentPlayer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality()
                .equals(other._profilePictures, _profilePictures) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.currentPlayer, currentPlayer) ||
                other.currentPlayer == currentPlayer));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      error,
      user,
      const DeepCollectionEquality().hash(_profilePictures),
      const DeepCollectionEquality().hash(_players),
      currentPlayer);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStateImplCopyWith<_$UserStateImpl> get copyWith =>
      __$$UserStateImplCopyWithImpl<_$UserStateImpl>(this, _$identity);
}

abstract class _UserState implements UserState {
  const factory _UserState(
      {final bool isLoading,
      final String error,
      final User? user,
      final List<String> profilePictures,
      final List<Player> players,
      final Player? currentPlayer}) = _$UserStateImpl;

  @override
  bool get isLoading;
  @override
  String get error;
  @override
  User? get user;
  @override
  List<String> get profilePictures;
  @override
  List<Player> get players;
  @override
  Player? get currentPlayer;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStateImplCopyWith<_$UserStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
