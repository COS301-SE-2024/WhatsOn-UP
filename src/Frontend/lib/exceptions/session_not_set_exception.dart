class SessionNotSetException implements Exception {
  final String message;
  SessionNotSetException(this.message);

  @override
  String toString() => 'SessionNotSetException: $message';
}