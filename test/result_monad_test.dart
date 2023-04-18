import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

void main() {
  group('Test success monad', () {
    test('Test create success', () {
      const resultValue = 'Awesome';
      final success = Result.ok('Awesome');
      expect(success.isSuccess, true);
      expect(success.isFailure, false);
      expect(success.value, resultValue);
      expect(() => success.error, throwsA(isA<ResultMonadException>()));
    });

    test('Test create with nullable type', () {
      final success = Result<String?, dynamic>.ok(null);
      expect(success.isSuccess, true);
      expect(success.isFailure, false);
      expect(success.value, null);
      expect(() => success.error, throwsA(isA<ResultMonadException>()));
    });

    test('Test create with implicit nullable type', () {
      final success = Result.ok(null);
      expect(success.isSuccess, true);
      expect(success.isFailure, false);
      expect(success.value, null);
      expect(() => success.error, throwsA(isA<ResultMonadException>()));
    });
  });

  group('Test failure monad', () {
    test('Test create error', () {
      const errorValue = 'Error';
      final failure = Result.error(errorValue);
      expect(failure.isFailure, true);
      expect(failure.isSuccess, false);
      expect(failure.error, errorValue);
      expect(() => failure.value, throwsA(isA<ResultMonadException>()));
    });

    test('Test create with nullable type', () {
      final failure = Result<String?, dynamic>.error(null);
      expect(failure.isFailure, true);
      expect(failure.isSuccess, false);
      expect(failure.error, null);
      expect(() => failure.value, throwsA(isA<ResultMonadException>()));
    });

    test('Test create with implicit nullable type', () {
      final failure = Result.error(null);
      expect(failure.isFailure, true);
      expect(failure.isSuccess, false);
      expect(failure.error, null);
      expect(() => failure.value, throwsA(isA<ResultMonadException>()));
    });
  });

  group('Test success value accessor', () {
    test('Test getting value from success', () {
      const resultValue = 'Awesome';
      final success = Result.ok('Awesome');
      expect(success.value, resultValue);
    });

    test('Test success value accessor with nullable type', () {
      final success = Result<String?, dynamic>.ok(null);
      expect(success.value, null);
    });

    test('Test failed attempt at get value from failure', () {
      expect(() => Result.error('Something went wrong').value,
          throwsA(isA<ResultMonadException>()));
    });
  });

  group('Test failure value accessor', () {
    test('Test getting error from failure', () {
      const resultValue = 'Something Wrong';
      final failure = Result.error('Something Wrong');
      expect(failure.error, resultValue);
    });

    test('Test getting error from failure with nullable type', () {
      final failure = Result<String?, dynamic>.error(null);
      expect(failure.error, null);
      expect(() => failure.value, throwsA(isA<ResultMonadException>()));
    });

    test('Test failed attempt at get error value from success', () {
      expect(() => Result.ok('It Worked!').error,
          throwsA(isA<ResultMonadException>()));
    });
  });

  group('Test getValueOrElse', () {
    test('Test getValueOrElse on failure', () {
      final failure = Result.error('This is a failure');
      const elseResponse = 'I guess it failed';
      expect(failure.getValueOrElse(() => elseResponse), equals(elseResponse));
    });

    test('Test getValueOrElse on failure with nullable', () {
      final failure = Result<String?, String?>.error('This is a failure');
      const elseResponse = 'I guess it failed';
      expect(failure.getValueOrElse(() => elseResponse), equals(elseResponse));
      expect(failure.getValueOrElse(() => null), equals(null));
    });

    test('Test getValueOrElse on success', () {
      final success = Result.ok('It worked!');
      const elseResponse = 'I guess it failed';
      expect(success.getValueOrElse(() => elseResponse), equals('It worked!'));
    });

    test('Test getValueOrElse on success with nullable', () {
      final success = Result<String?, String?>.ok(null);
      const elseResponse = 'I guess it failed';
      expect(success.getValueOrElse(() => elseResponse), equals(null));
      expect(success.getValueOrElse(() => null), equals(null));
    });
  });

  group('Test getErrorOrElse', () {
    test('Test getErrorOrElse on failure', () {
      final failure = Result.error('This is a failure');
      const elseResponse = 'Did not have an error';
      expect(failure.getErrorOrElse(() => elseResponse),
          equals('This is a failure'));
    });

    test('Test getErrorOrElse on failure with nullable', () {
      final failure = Result<String?, String?>.error(null);
      const elseResponse = 'Did not have an error';
      expect(failure.getErrorOrElse(() => elseResponse), equals(null));
      expect(failure.getErrorOrElse(() => null), equals(null));
    });

    test('Test getErrorOrElse on success', () {
      final success = Result.ok('It worked');
      const elseResponse = 'Did not have an error';
      expect(success.getErrorOrElse(() => elseResponse),
          equals('Did not have an error'));
    });

    test('Test getErrorOrElse on success with nullable', () {
      final success = Result<String?, String?>.ok('It worked');
      const elseResponse = 'Did not have an error';
      expect(success.getErrorOrElse(() => elseResponse),
          equals('Did not have an error'));
      expect(success.getErrorOrElse(() => null), equals(null));
    });
  });

  group('Test match', () {
    test('Regular types', () {
      final success = Result<String, String>.ok('This is a success');
      success.match(
          onSuccess: (value) => expect(value, equals(success.value)),
          onError: (error) => fail("Shouldn't execute this path"));

      final failure = Result<String, String>.error('This is a failure');
      failure.match(
          onSuccess: (value) => fail("Shouldn't execute this path"),
          onError: (error) => expect(error, equals(failure.error)));
    });

    test('Nullable Types', () {
      final success = Result<String?, String?>.ok('This is a success');
      success.match(
          onSuccess: (value) => expect(value, equals(success.value)),
          onError: (error) => fail("Shouldn't execute this path"));

      final failure = Result<String?, String?>.error('This is a failure');
      failure.match(
          onSuccess: (value) => fail("Shouldn't execute this path"),
          onError: (error) => expect(error, equals(failure.error)));
    });
  });

  group('Test fold', () {
    test('Regular Types', () {
      final success = Result<String, int>.ok('It worked!');
      final successFolded = success.fold(
          onSuccess: (value) => value, onError: (error) => 'error');
      expect(successFolded, equals(success.value));

      final failed = Result<String, int>.error(100);
      final failedFolded =
          failed.fold(onSuccess: (value) => 0, onError: (error) => error);
      expect(failedFolded, equals(failed.error));
    });

    test('Nullable Types', () {
      final success = Result<String?, int?>.ok('It worked!');
      final successFolded = success.fold(
        onSuccess: (value) => value,
        onError: (error) => 'error',
      );
      expect(successFolded, equals(success.value));

      final failed = Result<String?, int?>.error(100);
      final failedFolded = failed.fold(
        onSuccess: (value) => 0,
        onError: (error) => error,
      );
      expect(failedFolded, equals(failed.error));
    });
  });

  // simpler 'and then' tests
  group('Test andThen', () {
    test('Test chaining through to end', () async {
      final result = Result.ok('Success')
          .andThen((value) => Result.ok(value.length))
          .andThen((value) => Result.ok('Original string length: $value'));
      expect(result.value, equals('Original string length: 7'));
    });

    test('Test chaining through to end with nullable type', () async {
      final result = Result<String?, int>.ok('Success')
          .andThen((value) => Result.ok(value?.length ?? -1))
          .andThen((value) => Result.ok('Original string length: $value'));
      expect(result.value, equals('Original string length: 7'));

      final result2 = Result<String?, int>.ok(null)
          .andThen((value) => Result.ok(value?.length ?? -1))
          .andThen((value) => Result.ok('Original string length: $value'));
      expect(result2.value, equals('Original string length: -1'));
    });

    test('Test starting with failure', () async {
      final initial = Result.error('failed!');
      final result = initial
          .andThen((value) => Result.ok(value.length))
          .andThen((value) => Result.ok('Original string length: $value'));
      expect(result.error, equals(initial.error));
    });

    test('Test chaining with short circuit', () async {
      final result = Result.ok('Success')
          .andThen((value) => Result.error('error'))
          .andThen((value) => Result.ok('Original string length: $value'));
      expect(result.error, equals('error'));
    });

    test('Test chaining with exception shortCut', () async {
      final arr = [1, 2, 3];
      final result = Result.ok('Success')
          .andThen((value) => Result.ok(arr[arr.length + 1]))
          .andThen((value) => Result.ok('$value'));
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test andThenSuccess', () {
    test('Test chaining through to end', () async {
      final result = Result.ok('Success')
          .andThenSuccess((value) => value.length)
          .andThenSuccess((value) => 'Original string length: $value');
      expect(result.value, equals('Original string length: 7'));
    });

    test('Test chaining through to end with nullable type', () async {
      final result = Result<String?, int>.ok('Success')
          .andThenSuccess((value) => value?.length ?? -1)
          .andThenSuccess((value) => 'Original string length: $value');
      expect(result.value, equals('Original string length: 7'));

      final result2 = Result<String?, int>.ok(null)
          .andThenSuccess((value) => value?.length ?? -1)
          .andThenSuccess((value) => 'Original string length: $value');
      expect(result2.value, equals('Original string length: -1'));
    });

    test('Test starting with failure', () async {
      final initial = Result.error('failed!');
      final result = initial
          .andThenSuccess((value) => value.length)
          .andThenSuccess((value) => 'Original string length: $value');
      expect(result.error, equals(initial.error));
    });

    test('Test chaining with short circuit', () async {
      final result = Result.ok('Success')
          .andThen((value) => Result.error('error'))
          .andThenSuccess((value) => 'Original string length: $value');
      expect(result.error, equals('error'));
    });

    test('Test chaining with exception shortcut', () async {
      final arr = [1, 2, 3];
      final result = Result.ok('Success')
          .andThenSuccess((value) => arr[arr.length + 1])
          .andThenSuccess((value) => '$value');
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test andThenAsync', () {
    test('Test success result', () async {
      final result = await (await Result.ok('Success')
              .andThenAsync((value) async => Result.ok(value.length)))
          .andThenAsync(
              (value) async => Result.ok('Original string length: $value'));
      expect(result.value, equals('Original string length: 7'));
    });

    test('Test success result with nullable', () async {
      final result = await (await Result<String?, int>.ok('Success')
              .andThenAsync((value) async => Result.ok(value?.length ?? -1)))
          .andThenAsync(
              (value) async => Result.ok('Original string length: $value'));
      expect(result.value, equals('Original string length: 7'));

      final result2 = await (await Result<String?, int>.ok(null)
              .andThenAsync((value) async => Result.ok(value?.length ?? -1)))
          .andThenAsync(
              (value) async => Result.ok('Original string length: $value'));
      expect(result2.value, equals('Original string length: -1'));
    });

    test('Test starting with failure', () async {
      final initial = Result.error('failed!');
      final result =
          await initial.andThenAsync((value) async => Result.ok(value.length));
      expect(result.error, equals(initial.error));
    });

    test('Test chaining with short circuit', () async {
      final result = await (await Result.ok('Success')
              .andThenAsync((value) async => Result.error('error')))
          .andThenAsync(
              (value) async => Result.ok('Original string length: $value'));
      expect(result.error, equals('error'));
    });

    test('Test chaining with exception short circuit', () async {
      final result = await (await Result.ok('Success')
              .andThenAsync((value) async => throw FormatException()))
          .andThenAsync(
              (value) async => Result.ok('Original string length: $value'));
      expect(result.isFailure, true);
      expect(result.error, isA<FormatException>());
    });
  });

  group('Test andThenSuccessAsync', () {
    test('Test success result', () async {
      final result = await (await Result.ok('Success')
              .andThenSuccessAsync((value) async => value.length))
          .andThenSuccessAsync(
              (value) async => 'Original string length: $value');
      expect(result.value, equals('Original string length: 7'));
    });

    test('Test success result with nullable', () async {
      final result = await (await Result<String?, int>.ok('Success')
              .andThenSuccessAsync((value) async => value?.length ?? -1))
          .andThenSuccessAsync(
              (value) async => 'Original string length: $value');
      expect(result.value, equals('Original string length: 7'));

      final result2 = await (await Result<String?, int>.ok(null)
              .andThenSuccessAsync((value) async => value?.length ?? -1))
          .andThenSuccessAsync(
              (value) async => 'Original string length: $value');
      expect(result2.value, equals('Original string length: -1'));
    });

    test('Test starting with failure', () async {
      final initial = Result.error('failed!');
      final result =
          await initial.andThenSuccessAsync((value) async => value.length);
      expect(result.error, equals(initial.error));
    });

    test('Test chaining with short circuit', () async {
      final result = await (await Result.ok('Success')
              .andThenAsync((value) async => Result.error('error')))
          .andThenSuccessAsync(
              (value) async => 'Original string length: $value');
      expect(result.error, equals('error'));
    });

    test('Test chaining with exception short circuit', () async {
      final result = await (await Result.ok('Success')
              .andThenSuccessAsync((value) async => throw FormatException()))
          .andThenSuccessAsync(
              (value) async => 'Original string length: $value');
      expect(result.isFailure, true);
      expect(result.error, isA<FormatException>());
    });
  });

  group('Test mapError', () {
    test('Test mapping of error same type', () {
      final error1 = Result.error('error');
      final error2 = error1.mapError((error) => 'error2');
      expect(error2.error, equals('error2'));
    });

    test('Test mapping of error same type nullable', () {
      final error1 = Result<String, String?>.error('error');
      final error2 = error1.mapError((error) => 'error2');
      expect(error2.error, equals('error2'));
    });

    test('Test mapping of error different type', () {
      final error1 = Result.error('error');
      final error2 = error1.mapError((error) => error.length);
      expect(error2.error, equals(5));
    });

    test('Test mapping of error different type nullable', () {
      final error1 = Result<String, String?>.error(null);
      final error2 = error1.mapError((error) => error?.length);
      expect(error2.error, equals(null));
    });

    test('Test mapping of success type', () {
      final success = Result.ok('Success!');
      final mapped = success.mapError((error) => 'error2');
      expect(mapped.value, equals(success.value));
    });

    test('Test mapping of success type nullable', () {
      final success = Result<String?, String?>.ok(null);
      final mapped = success.mapError((error) => 'error2');
      expect(mapped.value, equals(success.value));
    });

    test('Test mapping different success type', () {
      final result1 = Result<int, String>.error('An int error');
      final Result<String, String> result2 = result1.errorCast();
      expect(result2.error, equals(result2.error));
    });
  });

  group('Test mapValue', () {
    test('Test mapping of value same type', () {
      final success = Result.ok('Success!');
      final success2 = success.mapValue((value) => 'Success2!');
      expect(success2.value, equals('Success2!'));
    });

    test('Test mapping of value same type nullable', () {
      final success = Result<String?, int>.ok(null);
      final success2 = success.mapValue((value) => 'Success2!');
      expect(success2.value, equals('Success2!'));
    });

    test('Test mapping of value different type', () {
      final success = Result.ok('Success!');
      final success2 = success.mapValue((value) => value.length);
      expect(success2.value, equals(8));
    });

    test('Test mapping of value different type nullable', () {
      final success = Result<String?, String>.ok(null);
      final success2 = success.mapValue((value) => value?.length);
      expect(success2.value, equals(null));
    });

    test('Test mapping of error type', () {
      final error = Result.error('error');
      final mapped = error.mapValue((value) => 'Success2!');
      expect(mapped.error, equals(error.error));
    });

    test('Test mapping of error type', () {
      final error = Result<String?, String?>.error(null);
      final mapped = error.mapValue((value) => 'Success2!');
      expect(mapped.error, equals(error.error));
    });
  });

  group('Test withResult', () {
    test('Test simple pass through', () {
      var resultString1 = '';
      final result =
          Result.ok('Success').withResult((value) => resultString1 = value);
      expect(result.value, equals('Success'));
      expect(resultString1, equals('Success'));
    });
    test('Test error skips', () {
      var resultString1 = 'Skipped';
      final result =
          Result.error('Error').withResult((value) => resultString1 = value);
      expect(result.isFailure, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () {
      final result =
          Result.ok('Success').withResult((value) => value = 'Hello');
      expect(result.value, equals('Success'));
    });
    test('Test exception thrown generates propagated error', () {
      final result =
          Result.ok('Success').withResult((value) => throw Exception('Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('Error'));
    });
  });

  group('Test withResultAsync', () {
    test('Test simple pass through', () async {
      var resultString1 = '';
      final result = await Result.ok('Success')
          .withResultAsync((value) async => resultString1 = value);
      expect(result.value, equals('Success'));
      expect(resultString1, equals('Success'));
    });
    test('Test error skips', () async {
      var resultString1 = 'Skipped';
      final result = await Result.error('Error')
          .withResultAsync((value) => resultString1 = value);
      expect(result.isFailure, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () async {
      final result = await Result.ok('Success')
          .withResultAsync((value) async => value = 'Hello');
      expect(result.value, equals('Success'));
    });
    test('Test exception thrown generates propagated error', () async {
      final result = await Result.ok('Success')
          .withResultAsync((value) async => throw Exception('Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('Error'));
    });
  });

  group('Test to string', () {
    test('Regular Types', () {
      expect(Result.ok(10).toString(), equals('ok(10)'));
      expect(Result.error(10).toString(), equals('error(10)'));
    });

    test('Nullable Types', () {
      expect(Result.ok(null).toString(), equals('ok(null)'));
      expect(Result.error(null).toString(), equals('error(null)'));
    });
  });
}
