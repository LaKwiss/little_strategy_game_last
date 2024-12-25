import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool isLoading,
    @Default('') String error,
    User? user,
    @Default(<String>[]) List<String> profilePictures,
    @Default(<Player>[]) List<Player> players,
    Player? currentPlayer,
  }) = _UserState;
}
