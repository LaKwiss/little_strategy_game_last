part of 'storage_notifier.dart';

enum StorageStatus { initial, loading, loaded, error }

class StorageState extends Equatable {
  final List<String> profilePicturesUrl;
  final List<String> loginMethodsUrl;
  final List<String> imageUrls;
  final StorageStatus status;
  final String error;

  const StorageState({
    required this.profilePicturesUrl,
    required this.loginMethodsUrl,
    required this.imageUrls,
    required this.status,
    required this.error,
  });

  factory StorageState.initial() {
    return const StorageState(
      profilePicturesUrl: [],
      loginMethodsUrl: [],
      imageUrls: [],
      status: StorageStatus.initial,
      error: '',
    );
  }

  StorageState copyWith({
    List<String>? profilePicturesUrl,
    List<String>? loginMethodsUrl,
    List<String>? imageUrls,
    StorageStatus? status,
    String? error,
  }) {
    return StorageState(
      profilePicturesUrl: profilePicturesUrl ?? this.profilePicturesUrl,
      loginMethodsUrl: loginMethodsUrl ?? this.loginMethodsUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [profilePicturesUrl, loginMethodsUrl, imageUrls, status, error];
}
