import 'package:domain_entities/domain_entities.dart';
import 'package:state_repository/state_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<T> safeExecute<T>(Future<T> Function() action) async {
    try {
      state = state.copyWith(status: UserStateStatus.loading);
      final result = await action();
      state = state.copyWith(status: UserStateStatus.success);
      await saveState();
      return result;
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      state = state.copyWith(
        status: UserStateStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> saveState() async {}

  Future<Player> addPlayer(
      String email, String username, String credential) async {
    if (email.isEmpty ||
        !RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      throw Exception('Invalid email');
    }
    if (username.isEmpty || username.length < 3) {
      throw Exception('Invalid username');
    }
    if (credential.isEmpty) {
      throw Exception('Credential is required');
    }

    Logger('ProfilePicture').severe('Fetching profile pictures');

    return await safeExecute(() async {
      await fetchAndSetPlayers();
      if (state.players
          .map((e) => e.username.toLowerCase())
          .contains(username.toLowerCase())) {
        throw Exception('Username already exists');
      }
      final result = await repository.addPlayer(email, username, credential);
      state = state.copyWith(currentPlayer: result);
      return result;
    });
  }

  Future<void> fetchAndSetProfilePictures() async {
    await safeExecute(() async {
      final List<String> profilePictures =
          await repository.getAllProfilePictures();
      state = state.copyWith(profilePictures: profilePictures);
    });
  }

  Future<String?> addUser(
      String email, String username, String password) async {
    if (email.isEmpty || !isEmail(email)) {
      throw Exception('Invalid email');
    }
    if (username.isEmpty || username.length < 3) {
      throw Exception('Invalid username');
    }
    if (password.isEmpty || password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    return await safeExecute(() async {
      return await repository.addUser(email, username, password);
    });
  }

  Future<List<Player>> fetchAndSetPlayers() async {
    return await safeExecute(() async {
      final List<Player> users = await repository.getAllUsers();
      state = state.copyWith(players: users);
      return users;
    });
  }

  Future<String> login(String email, String password) async {
    if (email.isEmpty || !isEmail(email)) {
      const errorMsg = 'Adresse email invalide.';
      _logger
          .warning('Tentative de connexion avec un email invalide: "$email"');
      state = state.copyWith(
        status: UserStateStatus.error,
        errorMessage: errorMsg,
      );
      return Future.error(errorMsg);
    }

    if (password.isEmpty || password.length < 6) {
      const errorMsg = 'Le mot de passe doit contenir au moins 6 caractères.';
      _logger.warning('Tentative de connexion avec un mot de passe invalide.');
      state = state.copyWith(
        status: UserStateStatus.error,
        errorMessage: errorMsg,
      );
      return Future.error(errorMsg);
    }

    _logger.info('Tentative de connexion pour l\'email: $email');
    return await safeExecute(() async {
      final credential = await repository.connectUser(email, password);
      final currentUser = FirebaseAuth.instance.currentUser;
      state = state.copyWith(currentUser: currentUser);
      _logger
          .info('Connexion réussie pour l\'utilisateur: ${currentUser?.uid}');
      return credential;
    });
  }

  Future<void> setProfilePicture(String url) async {
    if (url.isEmpty || !isValidUrl(url)) {
      throw Exception('Invalid URL');
    }

    await safeExecute(() async {
      await repository.setProfilePicture(url);
      await fetchAndSetProfilePictures();
    });
  }

  bool isEmail(String email) {
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      return false;
    }
    return true;
  }

  bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.isAbsolute &&
        (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }
}
