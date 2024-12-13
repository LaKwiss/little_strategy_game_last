class GameNotFoundException implements Exception {
  GameNotFoundException(this.message);
  final String message;
}
