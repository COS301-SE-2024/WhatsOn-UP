class SessionNotSetException implements Exception {
  final String message;
  SessionNotSetException(this.message);

  @override
  String toString() => 'SessionNotSetException: $message';
}

class JWTNotSetException implements Exception {
  final String message;
  JWTNotSetException({this.message = "JWT used in the user provider has not been set at this point"});

  @override
  String toString() => 'JWTNotSetException: $message';
}