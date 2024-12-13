import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

class UserRemoteRepository {
  final String playersNode = 'users';

  final FirebaseFirestore _firestore;
  final FirebaseStorage _usersStorage;
  final FirebaseAuth _firebaseAuth;

  final Logger _log = Logger('UserRemoteRepository');

  UserRemoteRepository(
    this._firestore,
    this._usersStorage,
    this._firebaseAuth,
  );

  Future<List<Player>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection(playersNode).get();
      final users =
          snapshot.docs.map((doc) => Player.fromJson(doc.data())).toList();
      users.sort((a, b) => a.username.compareTo(b.username));
      _log.info('Fetched ${users.length} users from Firestore.');
      return users;
    } catch (e, stack) {
      _log.severe('Error getting users: $e', e, stack);
      rethrow;
    }
  }

  Future<List<String>> getAllProfilePictures() async {
    try {
      final profilePictures = <String>[];
      final ref = _usersStorage.ref("/profile_pictures");
      final list = await ref.listAll();

      for (final item in list.items) {
        final url = await item.getDownloadURL();
        profilePictures.add(url);
      }

      _log.info('Retrieved ${profilePictures.length} profile pictures.');
      return profilePictures;
    } catch (e, stack) {
      _log.severe('Error getting profile pictures: $e', e, stack);
      rethrow;
    }
  }

  Future<Player> addPlayer(String email, String username, String uid) async {
    try {
      if (username.isEmpty) {
        throw Exception('Username is required');
      }
      if (uid.isEmpty) {
        throw Exception('UID is required');
      }
      if (email.isEmpty) {
        throw Exception('Email is required');
      }

      final player =
          Player(username: username, uid: uid, charactersIds: const []);
      await _firestore
          .collection(playersNode)
          .doc(username)
          .set(player.toJson());
      _log.info('Player $username added successfully.');
      return player;
    } catch (e, stack) {
      _log.severe('Error adding player: $e', e, stack);
      rethrow;
    }
  }

  Future<String> addUser(String email, String username, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('User not created');
      }

      // Méthodes recommandées pour mettre à jour le profil
      await credential.user!.updateDisplayName(username);
      await credential.user!.updatePhotoURL('');

      _log.info('User $username created with UID ${credential.user!.uid}.');
      return credential.user!.uid;
    } catch (e, stack) {
      _log.severe('Error adding user: $e', e, stack);
      rethrow;
    }
  }

  Future<String> connectUser(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('User not found');
      }

      _log.info('User ${credential.user!.uid} connected successfully.');
      return credential.user!.uid;
    } catch (e, stack) {
      _log.severe('Error connecting user: $e', e, stack);
      rethrow;
    }
  }

  Future<String> setProfilePicture(String url) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No current user');
      }

      await currentUser.updatePhotoURL(url);
      await _firestore
          .collection(playersNode)
          .doc(currentUser.displayName)
          .update({'photoURL': url});

      _log.info('Profile picture updated for ${currentUser.displayName}.');
      return url;
    } catch (e, stack) {
      _log.severe('Error adding profile picture: $e', e, stack);
      rethrow;
    }
  }

  Future<Player> getPlayerByEmail(String email) {
    try {
      _log.info('Getting player by email: $email');
      return _firestore
          .collection(playersNode)
          .where('email', isEqualTo: email)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isEmpty) {
          throw Exception('Player not found');
        }
        return Player.fromJson(snapshot.docs.first.data());
      });
    } catch (e, stack) {
      _log.severe('Error getting player by email: $e', e, stack);
      rethrow;
    }
  }
}
