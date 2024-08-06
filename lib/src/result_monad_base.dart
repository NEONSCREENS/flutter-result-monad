import '../result_monad.dart';

/// A shorthand type notation for Result futures
/// `FutureResult<int,String> func() async {}`
typedef FutureResult<T, E> = Future<Result<T, E>>;

/// The Result Monad type which will encapsulate a success (ok) value of type T
/// or a failure (error) value of type E
class Result<T, E> {
  late final T _value;
  late final E _error;
  final bool _isSuccess;

  /// Create a new Result of the expected error type with the error value
  /// `Result<int,String> getErrorValue() => Result.error('This is an error');`
  const Result.error(E error)
      : _error = error,
        _isSuccess = false;

  /// Create a new Result of the expected success type with the success value
  /// `Result<int,String> getSuccess() => Result.ok(10);`
  const Result.ok(T success)
      : _value = success,
        _isSuccess = true;

  /// Returns the error if it is a failure Result Monad otherwise throws
  /// [ResultMonadException]. It is best to check that it is a failure monad
  /// by calling [isFailure].
  E get error {
    if (isSuccess) {
      throw ResultMonadException.accessFailureOnSuccess();
    }

    return _error;
  }

  /// Returns true if the Result Monad has a failure value, false otherwise
  bool get isFailure => !_isSuccess;

  /// Returns true if the Result Monad has a success value, false otherwise
  bool get isSuccess => _isSuccess;

  /// Returns the value if it is a success Result Monad otherwise throws
  /// [ResultMonadException]. It is best to check that it is a success monad
  /// by calling [isSuccess].
  T get value {
    if (!isSuccess) {
      throw ResultMonadException.accessSuccessOnFailure();
    }

    return _value;
  }

  /// Executes the anonymous function passing the current value to it to support
  /// operation chaining.
  ///
  /// Example:
  /// ```dart
  /// return doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThen((r2) => r2.doSomething2())
  ///   .andThen((r3) => r3.doSomething3())
  /// ```
  Result<T2, dynamic> andThen<T2, E2>(Result<T2, E2> Function(T) thenFunction) {
    if (isSuccess) {
      try {
        return thenFunction(_value);
      } catch (e) {
        return Result.error(e);
      }
    }

    return Result.error(_error);
  }

  /// Executes the anonymous function passing the current value to it to support
  /// operation chaining. The function returns a non-Result value therefore
  /// this assumes that the operation is always a success. This is helpful for
  /// chaining functions that don't have result monads.
  ///
  /// Example:
  /// ```dart
  /// return doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .transform((r2) => r2.toString())
  ///   .andThen((r3) => r3.doSomething3())
  /// ```
  Result<T2, dynamic> transform<T2, E2>(T2 Function(T) thenFunction) {
    if (isSuccess) {
      try {
        return Result.ok(thenFunction(_value));
      } catch (e) {
        return Result.error(e);
      }
    }

    return Result.error(_error);
  }

  /// <b>NOTE: This is old syntax preserved for backward compatibility. Instead
  /// use the [transform] method</b>
  ///
  /// Executes the anonymous function passing the current value to it to support
  /// operation chaining. The function returns a non-Result value therefore
  /// this assumes that the operation is always a success. This is helpful for
  /// chaining functions that don't have result monads.
  ///
  /// Example:
  /// ```dart
  /// return doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThenSuccess((r2) => r2.doSomething2())
  ///   .andThen((r3) => r3.doSomething3())
  /// ```
  Result<T2, dynamic> andThenSuccess<T2, E2>(T2 Function(T) thenFunction) {
    return transform(thenFunction);
  }

  /// Executes the anonymous async function passed in on the current value. Due
  /// to Dart syntax peculiarities it may be cleaner to work with interim
  /// results.
  ///
  /// ```dart
  /// final asyncResult = await doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThen((r2) => r2.doSomething2())
  ///   .andThenAsync((r3) async  => r3.doSomething3())
  ///
  /// return asyncResult
  ///   .andThen((r4) => r4.doSomething4())
  ///   .andThen((r5) => r5.doSomething5())
  /// ```
  FutureResult<T2, dynamic> andThenAsync<T2, E2>(
      FutureResult<T2, E2> Function(T) thenFunction) async {
    if (isSuccess) {
      try {
        return await thenFunction(_value);
      } catch (e) {
        return Result.error(e);
      }
    }

    return Result.error(_error);
  }

  /// Executes the anonymous async function passed in on the current value. Due
  /// to Dart syntax peculiarities it may be cleaner to work with interim
  /// results.The function returns a non-Result value therefore
  //  this assumes that the operation is always a success. This is helpful for
  //  chaining functions that don't have result monads.
  ///
  /// ```dart
  /// final asyncResult = await doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThen((r2) => r2.doSomething2())
  ///   .transform((r3) async  => r3.toString())
  ///
  /// return asyncResult
  ///   .andThen((r4) => r4.doSomething4())
  ///   .andThen((r5) => r5.doSomething5())
  /// ```
  FutureResult<T2, dynamic> transformAsync<T2, E2>(
      Future<T2> Function(T) thenFunction) async {
    if (isSuccess) {
      try {
        final result = await thenFunction(_value);
        return Result.ok(result);
      } catch (e) {
        return Result.error(e);
      }
    }

    return Result.error(_error);
  }

  /// <b>NOTE: This is old syntax preserved for backward compatibility. Instead
  /// use the [transformAsync] method</b>
  ///
  /// Executes the anonymous async function passed in on the current value. Due
  /// to Dart syntax peculiarities it may be cleaner to work with interim
  /// results.The function returns a non-Result value therefore
  //  this assumes that the operation is always a success. This is helpful for
  //  chaining functions that don't have result monads.
  ///
  /// ```dart
  /// final asyncResult = await doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThen((r2) => r2.doSomething2())
  ///   .andThenSuccessAsync((r3) async  => r3.toString())
  ///
  /// return asyncResult
  ///   .andThen((r4) => r4.doSomething4())
  ///   .andThen((r5) => r5.doSomething5())
  /// ```
  FutureResult<T2, dynamic> andThenSuccessAsync<T2, E2>(
      Future<T2> Function(T) thenFunction) async {
    if (isSuccess) {
      try {
        final result = await thenFunction(_value);
        return Result.ok(result);
      } catch (e) {
        return Result.error(e);
      }
    }

    return Result.error(_error);
  }

  /// Maps (folds) the result into a new type consistent across both the
  /// success and failure conditions.
  ///
  /// ```dart
  /// // Mock function
  /// Result<File, FileAccessError> open(String filename) ...
  /// ...
  ///
  /// final size = File.open(filename)
  ///  .fold(
  ///    onSuccess: (file) => file.stat().fileSize(),
  ///    onError: (error) => 0
  ///  );
  /// ```
  ///
  T2 fold<T2>(
      {required T2 Function(T value) onSuccess,
      required T2 Function(E error) onError}) {
    if (isSuccess) {
      return onSuccess(_value);
    }

    return onError(_error);
  }

  /// Returns the error value *if* the monad is wrapping a failure or return
  /// the specified default value.
  ///
  /// ```dart
  /// final Result<int,String> result = obj.doSomething();
  /// final error = result.getErrorOrElse(()=>'No error found');
  /// ```
  E getErrorOrElse(E Function() orElse) => isFailure ? _error : orElse();

  /// Returns the success value *if* the monad is wrapping a success or return
  /// the specified default value.
  ///
  /// ```dart
  /// final Result<int,String> result = obj.doSomething();
  /// final value = result.getValueOrElse(()=>-1);;
  /// ```
  T getValueOrElse(T Function() orElse) => isSuccess ? _value : orElse();

  /// Maps from a monad from one error type to another. This is useful for
  /// transforming from error mappings between APIs etc.
  ///
  ///
  /// ```dart
  /// final Result<int, Exception> result1 = obj.doSomething();
  /// final Result<int, String> result2 = result1.mapError((exception) => exception.message);
  /// ```
  Result<T, E2> mapError<E2>(E2 Function(E error) mapFunction) {
    if (isSuccess) {
      return Result.ok(_value);
    }

    final newError = mapFunction(_error);
    return Result.error(newError);
  }

  /// Maps from an error monad with one return type to another. This is for
  /// cases where you know you got an error result of the same type that you
  /// want to propagate up but whose success type is different.
  ///
  ///
  /// ```dart
  /// Result<int,String> someFunction1 () {...}
  ///
  /// Result<String,String> someFunction2() {
  ///   final result1 = someFunction1();
  ///   if (resul1.isFailure) {
  ///     return result1.errorCast();
  ///   }
  ///
  ///   ...
  /// }
  /// ```
  Result<T2, E> errorCast<T2>() {
    if (isSuccess) {
      throw ResultMonadException.accessSuccessOnFailure();
    }

    return Result.error(_error);
  }

  /// Maps from a monad from one result type to another. This is useful for
  /// transforming from error mappings between APIs etc.
  ///
  ///
  /// ```dart
  /// final Result<User, Error> serviceResult = service.getUser(id);
  /// final Result<String, Error> addressResult = user.mapValue((user)=>user.address);
  /// ```
  Result<T2, E> mapValue<T2>(T2 Function(T value) mapFunction) {
    if (isFailure) {
      return Result.error(_error);
    }
    final newValue = mapFunction(_value);
    return Result.ok(newValue);
  }

  /// A mechanism for executing functions on a result monad for each of the two conditions
  /// result.match(
  ///   onSuccess: (value) => log.finest('Result: $value');
  ///   onError: (error) => log.severe('Error getting result: $error');
  /// )
  void match(
      {required Function(T value) onSuccess,
      required Function(E error) onError}) {
    if (isSuccess) {
      onSuccess(_value);
      return;
    }

    onError(_error!);
  }

  /// Executes the anonymous function passing the current success value to it to support
  /// operation chaining but as a pass-through process. The original result object
  /// is automatically passed on to the next chain *unchanged* nor is it possible
  /// to pass on a new result type like with the "andThen" methods.
  ///
  /// Example:
  /// ```dart
  /// return doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .withResult((r2) => print(r2))
  ///   .andThen((r2) => r2.doSomething3())
  /// ```
  Result<T, dynamic> withResult(Function(T) withFunction) {
    if (isSuccess) {
      try {
        withFunction(_value);
      } catch (e) {
        return Result.error(e);
      }
    }

    return this;
  }

  /// Executes the anonymous function passing the current success value to it to support
  /// operation chaining but as a pass-through process. The original result object
  /// is automatically passed on to the next chain *unchanged* nor is it possible
  /// to pass on a new result type like with the "andThen" methods.
  ///
  /// Example:
  /// ```dart
  /// return doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .withResultAsync((r2) => print(r2))
  ///   .andThen((r2) => r2.doSomething3())
  /// ```
  FutureResult<T, dynamic> withResultAsync(
      Future<void> Function(T) withFunction) async {
    if (isSuccess) {
      try {
        await withFunction(_value);
      } catch (e) {
        return Result.error(e);
      }
    }

    return this;
  }

  /// Executes the anonymous function passing the current error value to it to support
  /// operation chaining but as a pass-through process. The original result object
  /// is automatically passed on to the next chain *unchanged* nor is it possible
  /// to pass on a new result type like with the "andThen" methods. This is generally
  /// intended to be used at the end of a chain for reporting errors but can be used
  /// anywhere within it. If an error result hasn't been generated by that time
  /// then this won't do anything.
  ///
  /// Example:
  /// ```dart
  /// return doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThen((r2) => r2.doSomething3())
  ///   .withError((error) => print('Something went wrong! $error');
  /// ```
  Result<T, dynamic> withError(Function(E) withFunction) {
    if (isFailure) {
      try {
        withFunction(_error);
      } catch (e) {
        return Result.error(e);
      }
    }

    return this;
  }

  /// Executes the anonymous function passing the current error value to it to support
  /// operation chaining but as a pass-through process. The original result object
  /// is automatically passed on to the next chain *unchanged* nor is it possible
  /// to pass on a new result type like with the "andThen" methods. This is generally
  /// intended to be used at the end of a chain for reporting errors but can be used
  /// anywhere within it. If an error result hasn't been generated by that time
  /// then this won't do anything.
  ///
  /// Example:
  /// ```dart
  /// return await doSomething()
  ///   .andThen((r1) => r1.doSomething1())
  ///   .andThen((r2) => r2.doSomething3())
  ///   .withErrorAsync((error) async => print('Something went wrong! $error');
  /// ```
  FutureResult<T, dynamic> withErrorAsync(
      Future<void> Function(E) withFunction) async {
    if (isFailure) {
      try {
        await withFunction(_error);
      } catch (e) {
        return Result.error(e);
      }
    }

    return this;
  }

  @override
  String toString() {
    return isSuccess ? 'ok($_value)' : 'error($_error)';
  }
}
