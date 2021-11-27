/// Exception type for Result Monad specific exceptions (such as getting the
/// success value when the Result contained is a failure.
class ResultMonadException implements Exception {
  final String message;

  /// Standard constructor with message to propagate
  ResultMonadException(this.message);

  /// Generates a standard exception for when a user accessed the success value on a monad wrapping a failure
  ResultMonadException.accessSuccessOnFailure()
      : message = 'Attempted to pull a success value from a failure monad';

  /// Generates a standard exception for when a user accesse the error value on a monad wrapping a success
  ResultMonadException.accessFailureOnSuccess()
      : message = 'Attempted to pull a failure value from a success monad';

  @override
  String toString() {
    return 'ResultMonadException{message: $message}';
  }
}
