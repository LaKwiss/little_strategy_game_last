import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storage_repository/storage_repository.dart';

part 'storage_state.dart';

class StorageNotifier extends StateNotifier<StorageState> {
  final RemoteStorageRepository remoteRepository;

  StorageNotifier({required this.remoteRepository})
      : super(StorageState.initial());

  Future<void> loadProfilePictures() async {
    state = state.copyWith(status: StorageStatus.loading);
    try {
      final profilePictures = await remoteRepository.getProfilePictures();
      state = state.copyWith(
        profilePicturesUrl: profilePictures,
        status: StorageStatus.loaded,
      );
    } catch (error) {
      state =
          state.copyWith(status: StorageStatus.error, error: error.toString());
    }
  }

  Future<void> loadLoginMethods() async {
    state = state.copyWith(status: StorageStatus.loading);
    try {
      final loginMethods = await remoteRepository.getLoginMethods();
      state = state.copyWith(
        loginMethodsUrl: loginMethods,
        status: StorageStatus.loaded,
      );
      log('Login methods loaded: ${state.loginMethodsUrl}');
    } catch (error) {
      state =
          state.copyWith(status: StorageStatus.error, error: error.toString());
    }
  }

  Future<void> loadImageUrls() async {
    state = state.copyWith(status: StorageStatus.loading);
    try {
      final imageUrls = await remoteRepository.getImageUrls();
      state = state.copyWith(
        imageUrls: imageUrls,
        status: StorageStatus.loaded,
      );
    } catch (error) {
      state =
          state.copyWith(status: StorageStatus.error, error: error.toString());
    }
  }
}
