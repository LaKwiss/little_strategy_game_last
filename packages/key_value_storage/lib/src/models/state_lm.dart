// Need to move into key_value_storage package
import 'package:hive/hive.dart';
import 'package:key_value_storage/src/models/models.dart';

part 'state_lm.g.dart';

@HiveType(typeId: 0)
class UserStateLM {
  @HiveField(0)
  final int status;

  @HiveField(1)
  final String? errorMessage;

  @HiveField(2)
  final PlayerLM? currentPlayer;

  @HiveField(3)
  final List<PlayerLM> players;

  @HiveField(4)
  final List<String> profilePictures;

  UserStateLM({
    required this.status,
    this.errorMessage,
    this.currentPlayer,
    this.players = const [],
    this.profilePictures = const [],
  });

  factory UserStateLM.fromJson(Map<String, dynamic> json) {
    return UserStateLM(
      status: json['status'],
      errorMessage: json['errorMessage'],
      currentPlayer: json['currentPlayer'],
      players: json['players'],
      profilePictures: json['profilePictures'],
    );
  }
}
