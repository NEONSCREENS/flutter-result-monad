import 'dart:async';
import '../result_monad.dart';

/// Extension methods on Future<Result> objects to provide the same
/// operations that exist on the Result object for async method chaining
extension FutureResultExtension<T, E> on Future<Result<T, E>> {
  /// See documentation for [Result.andThen] method.
  FutureResult<T2, dynamic> andThen<T2, E2>(
      Result<T2, E2> Function(T) thenFunction) {
    return then((result) => result.andThen(thenFunction));
  }

  /// See documentation for [Result.andThenAsync] method.
  FutureResult<T2, dynamic> andThenAsync<T2, E2>(
      FutureResult<T2, E2> Function(T) thenFunction) {
    return then((result) => result.andThenAsync(thenFunction));
  }

  /// See documentation for [Result.errorCast] method.
  FutureResult<T2, E> errorCast<T2>() {
    return then((result) => result.errorCast<T2>());
  }

  /// See documentation for [Result.mapError] method.
  FutureResult<T, E2> mapError<E2>(E2 Function(E error) mapFunction) {
    return then((result) => result.mapError(mapFunction));
  }

  /// See documentation for [Result.mapValue] method.
  FutureResult<T2, E> mapValue<T2>(T2 Function(T value) mapFunction) {
    return then((result) => result.mapValue(mapFunction));
  }

  /// See documentation for [Result.transform] method.
  FutureResult<T2, dynamic> transform<T2, E2>(T2 Function(T) thenFunction) {
    return then((result) => result.transform(thenFunction));
  }

  /// See documentation for [Result.transformAsync] method.
  FutureResult<T2, dynamic> transformAsync<T2, E2>(
      Future<T2> Function(T) thenFunction) {
    return then((result) => result.transformAsync(thenFunction));
  }

  /// <b>NOTE: This is old syntax preserved for backward compatibility. Instead
  /// use the [transform] method.</b>
  ///
  /// See documentation for [Result.andThenSuccess]
  FutureResult<T2, dynamic> andThenSuccess<T2, E2>(
      T2 Function(T) thenFunction) {
    return transform(thenFunction);
  }

  /// <b>NOTE: This is old syntax preserved for backward compatibility. Instead
  /// use the [transformAsync] method.</b>
  ///
  /// See documentation for [Result.andThenSuccessAsync]
  FutureResult<T2, dynamic> andThenSuccessAsync<T2, E2>(
      Future<T2> Function(T) thenFunction) {
    return transformAsync(thenFunction);
  }

  /// See documentation for the [Result.withResult] method.
  FutureResult<T, dynamic> withResult(Function(T) withFunction) {
    return then((result) => result.withResult(withFunction));
  }

  /// See documentation for the [Result.withResultAsync] method.
  FutureResult<T, dynamic> withResultAsync(
      Future<void> Function(T) withFunction) {
    return then((result) => result.withResultAsync(withFunction));
  }

  /// See documentation for the [Result.withError] method.
  FutureResult<T, dynamic> withError(Function(E, StackTrace?) withFunction) {
    return then((result) => result.withError(withFunction));
  }

  /// See documentation for the [Result.withErrorAsync] method.
  FutureResult<T, dynamic> withErrorAsync(
      Future<void> Function(E, StackTrace?) withFunction) {
    return then((result) => result.withErrorAsync(withFunction));
  }

  /// See documentation for the [Result.match] method.
  Future<void> match(
      {required Function(T value) onSuccess,
      required Function(E error, StackTrace? stackTrace) onError}) {
    return then(
        (result) => result.match(onSuccess: onSuccess, onError: onError));
  }

  /// See documentation for the [Result.fold] method.
  Future<T2> fold<T2>(
      {required T2 Function(T value) onSuccess,
      required T2 Function(E error, StackTrace? stackTrace) onError}) {
    return then(
        (result) => result.fold(onSuccess: onSuccess, onError: onError));
  }
}
