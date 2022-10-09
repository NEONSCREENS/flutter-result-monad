import '../result_monad.dart';

extension FutureResultExtension<T, E> on Future<Result<T, E>> {
  FutureResult<T2, E2> andThenAsync<T2, E2>(
      FutureResult<T2, E2> Function(T) thenFunction) async {
    final thisResult = await this;
    if (thisResult.isFailure) {
      return Result.error(thisResult.error as E2);
    }

    return thenFunction(thisResult.value);
  }

  FutureResult<T2, E2> andThenSuccessAsync<T2, E2>(
      Future<T2> Function(T) thenFunction) async {
    final thisResult = await this;
    if (thisResult.isFailure) {
      return Result.error(thisResult.error as E2);
    }

    final returnResult = await thenFunction(thisResult.value);
    return Result.ok(returnResult);
  }

  Future<void> match(
      {required Function(T value) onSuccess,
      required Function(E error) onError}) async {
    final thisResult = await this;
    thisResult.match(
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  Future<T2> fold<T2>(
      {required T2 Function(T value) onSuccess,
      required T2 Function(E error) onError}) async {
    final thisResult = await this;
    return thisResult.fold(
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
