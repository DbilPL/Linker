class CacheException implements Exception {
  final String error;

  CacheException(this.error);
}

class ConnectionException implements Exception {
  final String error;

  ConnectionException(this.error);
}
