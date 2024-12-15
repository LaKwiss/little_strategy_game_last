import 'package:domain_entities/domain_entities.dart';
import 'package:state_repository/state_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_remote_repository/user_remote_repository.dart';

part 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final UserRemoteRepository repository;
  final StateRepository stateRepository;
  final Logger _logger = Logger('UserNotifier');

  UserNotifier(this.repository, this.stateRepository)
      : super(UserState.initial());

  /// Generalized method to safely execute actions and update state accordingly.
  Future<T> _safeExecute<T>(Future<T> Function() action) async {
    try {
      _setStateLoading();
      final result = await action();
      _setStateSuccess();
      await saveState();
      return result;
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
      rethrow;
    }
  }

  /// Updates the state to loading.
  void _setStateLoading() {
    state = state.copyWith(status: UserStateStatus.loading);
  }

  /// Updates the state to success.
  void _setStateSuccess() {
    state = state.copyWith(status: UserStateStatus.success);
  }

  /// Handles errors by logging and updating the state.
  void _handleError(Object error, StackTrace stackTrace) {
    _logger.severe('Error: $error', error, stackTrace);
    state = state.copyWith(
      status: UserStateStatus.error,
      errorMessage: error.toString(),
    );
  }

  /// Persists the current state to the repository.
  Future<void> saveState() async {
    await stateRepository.saveState(state);
  }

  Future<void> fetchState() async {
    final state = await stateRepository.fetchState();
    if (state != null) {
      this.state = state;
    }
  }

  /// Adds a player, validating inputs and ensuring no duplicate usernames.
  Future<Player> addPlayer(
      String email, String username, String credential) async {
    _validateEmail(email);
    username = await _validateAndRetrieveUsername(username, email);
    _validateCredential(credential);

    return await _safeExecute(() async {
      await fetchAndSetPlayers();
      if (_isUsernameTaken(username)) {
        throw Exception('Username already exists');
      }
      final result = await repository.addPlayer(email, username, credential);
      state = state.copyWith(currentPlayer: result);
      return result;
    });
  }

  /// Fetches all profile pictures and updates the state.
  Future<void> fetchAndSetProfilePictures() async {
    await _safeExecute(() async {
      final profilePictures = await repository.getAllProfilePictures();
      state = state.copyWith(profilePictures: profilePictures);
    });
  }

  /// Signs up a user, validating the provided inputs.
  Future<String?> signUp(String email, String username, String password) async {
    _validateEmail(email);
    _validateUsername(username);
    _validatePassword(password);

    return await _safeExecute(() async {
      return await repository.addUser(email, username, password);
    });
  }

  /// Fetches and sets all players, updating the state.
  Future<List<Player>> fetchAndSetPlayers() async {
    return await _safeExecute(() async {
      final users = await repository.getAllUsers();
      state = state.copyWith(players: users);
      return users;
    });
  }

  /// Logs in a user, validating the provided credentials.
  Future<String> login(String email, String password) async {
    _validateEmail(email);
    _validatePassword(password);

    _logger.info('Attempting login for email: $email');
    return await _safeExecute(() async {
      final credential = await repository.connectUser(email, password);
      final username = await findUsernameByEmail(email);
      state = state.copyWith(
        currentPlayer: Player(username: username, uid: credential),
      );
      return credential;
    });
  }

  /// Sets the profile picture for a user.
  Future<void> setProfilePicture(String url) async {
    _validateUrl(url);

    await _safeExecute(() async {
      await repository.setProfilePicture(url);
      await fetchAndSetProfilePictures();
    });
  }

  /// Finds the username associated with an email.
  Future<String> findUsernameByEmail(String email) async {
    _validateEmail(email);

    return await _safeExecute(() async {
      return await repository.findUsernameByEmail(email);
    });
  }

  /// Adds a reference between an email and username.
  Future<void> addReferenceEmailUsername(String email, String username) async {
    await _safeExecute(() async {
      await repository.addReferenceEmailUsername(email, username);
    });
  }

  /// Validates if the given email is in the correct format.
  void _validateEmail(String email) {
    if (email.isEmpty ||
        !RegExp(r'^[\w.-]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      throw Exception('Invalid email');
    }
  }

  /// Validates if the given username meets the requirements or retrieves it from the email.
  Future<String> _validateAndRetrieveUsername(
      String username, String email) async {
    if (username.isNotEmpty && username.length >= 3) return username;

    _logger.warning('Retrieving username for email: $email');
    final retrievedUsername = await findUsernameByEmail(email);
    if (retrievedUsername.isEmpty) {
      throw Exception('No user found');
    }
    return retrievedUsername;
  }

  /// Validates if the given credential is not empty.
  void _validateCredential(String credential) {
    if (credential.isEmpty) {
      throw Exception('Credential is required');
    }
  }

  /// Validates if the username meets requirements.
  void _validateUsername(String username) {
    if (username.isEmpty || username.length < 3) {
      throw Exception('Invalid username');
    }
  }

  /// Validates if the password meets the minimum length requirement.
  void _validatePassword(String password) {
    if (password.isEmpty || password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
  }

  /// Validates if the URL is well-formed.
  void _validateUrl(String url) {
    if (url.isEmpty || !_isValidUrl(url)) {
      throw Exception('Invalid URL');
    }
  }

  /// Checks if a username is already taken.
  bool _isUsernameTaken(String username) {
    return state.players
        .map((player) => player.username.toLowerCase())
        .contains(username.toLowerCase());
  }

  /// Checks if a URL is valid.
  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.isAbsolute &&
        (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }
}
