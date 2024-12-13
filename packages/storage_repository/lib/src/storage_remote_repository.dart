import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:storage_repository/src/storage_repository.dart';

class StorageRemoteRepository implements RemoteStorageRepository {
  final profilePicturesNode = 'profile_pictures';
  final loginMethodsNode = 'login_methods';
  final all = 'all';

  late FirebaseStorage _storageDatabase;

  StorageRemoteRepository(FirebaseStorage firebaseStorage) {
    _storageDatabase = firebaseStorage;
  }

  @override
  Future<List<String>> getImageUrls() async {
    try {
      final List<String> imageUrls = [];
      final ref = _storageDatabase.ref(all);
      final list = await ref.listAll().timeout(const Duration(seconds: 10));

      for (final item in list.items) {
        final url = await item.getDownloadURL();
        imageUrls.add(url);
      }
      return imageUrls;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting image urls: $e');
      }
      rethrow;
    }
  }

  @override
  Future<List<String>> getLoginMethods() async {
    try {
      final List<String> loginMethods = [];
      final ref = _storageDatabase.ref(loginMethodsNode);
      final list = await ref.listAll().timeout(const Duration(seconds: 10));

      for (final item in list.items) {
        final url = await item.getDownloadURL();
        loginMethods.add(url);
      }
      return loginMethods;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting login methods: $e');
      }
      rethrow;
    }
  }

  @override
  Future<List<String>> getProfilePictures() async {
    try {
      final List<String> profilePictures = [];
      final ref = _storageDatabase.ref(profilePicturesNode);
      final list = await ref.listAll().timeout(const Duration(seconds: 10));

      for (final item in list.items) {
        final url = await item.getDownloadURL();
        profilePictures.add(url);
      }
      return profilePictures;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting profile pictures: $e');
      }
      rethrow;
    }
  }
}
