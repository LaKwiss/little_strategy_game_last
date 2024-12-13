abstract class RemoteStorageRepository {
  Future<List<String>> getProfilePictures();
  Future<List<String>> getLoginMethods();
  Future<List<String>> getImageUrls();
}
