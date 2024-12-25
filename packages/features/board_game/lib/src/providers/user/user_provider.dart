import 'package:board_game/src/providers/user/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_remote_repository/user_remote_repository.dart';

part 'user_provider.g.dart';

@riverpod
UserRemoteRepository userRepository(Ref ref) {
  return UserRemoteRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    FirebaseAuth.instance,
  );
}

@riverpod
class UserNotifier extends _$UserNotifier {
  late final UserRemoteRepository _repository;
  late final Logger _logger;

  @override
  UserState build() {
    _repository = ref.watch(userRepositoryProvider);
    _logger = Logger('UserNotifier');
    return const UserState();
  }

  Future<T> _safeExecute<T>(Future<T> Function() action) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await action();
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e, stack) {
      _logger.severe('Operation failed', e, stack);
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> addPlayer(
    String email,
    String username,
    String credential,
  ) async {
    _validateEmail(email);
    username = await _validateAndRetrieveUsername(username, email);
    _validateCredential(credential);

    return _safeExecute(() async {
      await fetchAndSetPlayers();

      if (_isUsernameTaken(username)) {
        throw Exception('Username already exists');
      }

      final result = await _repository.addPlayer(email, username, credential);
      state = state.copyWith(currentPlayer: result);
    });
  }

  Future<void> fetchAndSetProfilePictures() async {
    return _safeExecute(() async {
      final pictures = await _repository.getAllProfilePictures();
      state = state.copyWith(profilePictures: pictures);
    });
  }

  Future<String?> signUp(
    String email,
    String username,
    String password,
  ) async {
    _validateEmail(email);
    _validateUsername(username);
    _validatePassword(password);
    return _safeExecute(
      () => _repository.addUser(email, username, password),
    );
  }

  Future<List<Player>> fetchAndSetPlayers() async {
    return _safeExecute(() async {
      final users = await _repository.getAllUsers();
      state = state.copyWith(players: users);
      return users;
    });
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    _validateEmail(email);
    _validatePassword(password);

    return _safeExecute(() async {
      // On se connecte
      await _repository.connectUser(email, password);
      // On récupère le username pour le stocker dans l’état
      final username = await findUsernameByEmail(email);
      state = state.copyWith(
        currentPlayer: Player(username: username, inventory: const []),
      );
    });
  }

  Future<void> setProfilePicture(String url) async {
    _validateUrl(url);
    return _safeExecute(() async {
      await _repository.setProfilePicture(url);
      // On recharge les images
      await fetchAndSetProfilePictures();
    });
  }

  Future<String> findUsernameByEmail(String email) async {
    _validateEmail(email);
    return _safeExecute(() => _repository.findUsernameByEmail(email));
  }

  Future<void> addReferenceEmailUsername(
    String email,
    String username,
  ) async {
    return _safeExecute(
      () => _repository.addReferenceEmailUsername(email, username),
    );
  }

  // -------------------------------
  //       Méthodes internes
  // -------------------------------
  void _validateEmail(String email) {
    if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      throw Exception('Invalid email format');
    }
  }

  Future<String> _validateAndRetrieveUsername(
    String username,
    String email,
  ) async {
    if (username.length >= 3) return username;
    final retrievedUsername = await findUsernameByEmail(email);
    if (retrievedUsername.isEmpty) {
      throw Exception('User not found');
    }
    return retrievedUsername;
  }

  void _validateCredential(String credential) {
    if (credential.isEmpty) throw Exception('Credential required');
  }

  void _validateUsername(String username) {
    if (username.length < 3) throw Exception('Username too short');
  }

  void _validatePassword(String password) {
    if (password.length < 6) throw Exception('Password too short');
  }

  void _validateUrl(String url) {
    if (!_isValidUrl(url)) throw Exception('Invalid URL');
  }

  bool _isUsernameTaken(String username) {
    return state.players
        .map((p) => p.username.toLowerCase())
        .contains(username.toLowerCase());
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri?.hasScheme == true && ['http', 'https'].contains(uri?.scheme);
  }
}
