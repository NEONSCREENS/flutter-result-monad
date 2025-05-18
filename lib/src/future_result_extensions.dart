import '../result_monad.dart';

/// Extension methods on Future<Result> objects to provide the same
/// operations that exist on the Result object for async method chaining
extension FutureResultExtension<T, E> on Future<Result<T, E>> {
  /// See documentation for [Result.andThen] method.
  FutureResult<T2, dynamic> andThen<T2, E2>(
          Result<T2, E2> Function(T) thenFunction) async =>
      (await this).andThen(thenFunction);

  /// See documentation for [Result.andThenAsync] method.
  FutureResult<T2, dynamic> andThenAsync<T2, E2>(
          FutureResult<T2, E2> Function(T) thenFunction) async =>
      (await this).andThenAsync(thenFunction);

  /// See documentation for [Result.errorCast] method.
  FutureResult<T2, E> errorCast<T2>() async => (await this).errorCast();

  /// See documentation for [Result.mapError] method.
  FutureResult<T, E2> mapError<E2>(E2 Function(E error) mapFunction) async =>
      (await this).mapError(mapFunction);

  /// See documentation for [Result.mapValue] method.
  FutureResult<T2, E> mapValue<T2>(T2 Function(T value) mapFunction) async =>
      (await this).mapValue(mapFunction);

  /// See documentation for [Result.transform] method.
  FutureResult<T2, dynamic> transform<T2, E2>(
          T2 Function(T) thenFunction) async =>
      (await this).transform(thenFunction);

  /// See documentation for [Result.transformAsync] method.
  FutureResult<T2, dynamic> transformAsync<T2, E2>(
          Future<T2> Function(T) thenFunction) async =>
      (await this).transformAsync(thenFunction);

  /// <b>NOTE: This is old syntax preserved for backward compatibility. Instead
  /// use the [transform] method.</b>
  ///
  /// See documentation for [Result.andThenSuccess]
  FutureResult<T2, dynamic> andThenSuccess<T2, E2>(
          T2 Function(T) thenFunction) async =>
      (await this).transform(thenFunction);

  /// <b>NOTE: This is old syntax preserved for backward compatibility. Instead
  /// use the [transformAsync] method.</b>
  ///
  /// See documentation for [Result.andThenSuccessAsync]
  FutureResult<T2, dynamic> andThenSuccessAsync<T2, E2>(
      Future<T2> Function(T) thenFunction) async {
    return transformAsync(thenFunction);
  }

  /// See documentation for the [Result.withResult] method.
  FutureResult<T, dynamic> withResult(Function(T) withFunction) async =>
      (await this).withResult(withFunction);

  /// See documentation for the [Result.withResultAsync] method.
  FutureResult<T, dynamic> withResultAsync(
          Future<void> Function(T) withFunction) async =>
      (await this).withResultAsync(withFunction);

  /// See documentation for the [Result.withError] method.
  FutureResult<T, dynamic> withError(Function(E, StackTrace?) withFunction) async =>
      (await this).withError(withFunction);

  /// See documentation for the [Result.withErrorAsync] method.
  FutureResult<T, dynamic> withErrorAsync(
          Future<void> Function(E, StackTrace?) withFunction) async =>
      (await this).withErrorAsync(withFunction);

  /// See documentation for the [Result.match] method.
  Future<void> match(
          {required Function(T value) onSuccess,
          required Function(E error, StackTrace? stackTrace) onError}) async =>
      (await this).match(
        onSuccess: onSuccess,
        onError: onError,
      );

  /// See documentation for the [Result.fold] method.
  Future<T2> fold<T2>(
          {required T2 Function(T value) onSuccess,
          required T2 Function(E error, StackTrace? stackTrace) onError}) async =>
      (await this).fold(
        onSuccess: onSuccess,
        onError: onError,
      );
}
