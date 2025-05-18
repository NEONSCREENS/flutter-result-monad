import 'dart:io';

import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

const delayMilliseconds = 100;

FutureResult<T, dynamic> buildFutureSuccess<T>(T v) async => Result.ok(v);

FutureResult<dynamic, E> buildFutureError<E>(E e) async => Result.error(e);

void main() {
  group('Test andThen', () {
    test('Confirm basic flow', () async {
      final result = await buildFutureSuccess(1).andThen(
        (p0) => Result.ok(p0 + 2),
      );
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await buildFutureSuccess(1)
          .andThen((p0) => Result.ok(p0 + 2))
          .andThen((p0) => Result.ok(p0.toString()));
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await buildFutureSuccess(1)
          .andThen((p0) => Result.ok(p0 + 2))
          .andThen((p0) => Result.error(errorText))
          .andThen((p0) => Result.ok(p0.toString()));
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await buildFutureSuccess<String?>('Hello')
          .andThen((s) => Result.ok(s?.length))
          .andThen((s) => Result.ok(s == null));
      expect(result1.value, false);
      final result2 = await buildFutureSuccess<String?>(null)
          .andThen((s) => Result.ok(s?.length))
          .andThen((s) => Result.ok(s == null));
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await buildFutureSuccess<String?>('Hello')
          .andThen((s) => Result.ok('$s World'))
          .andThen((s) => Result.ok(s[s.length + 1]))
          .andThen((s) => Result.ok('Complete'));
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test andThenAsync', () {
    test('Confirm basic flow', () async {
      final result = await buildFutureSuccess(1)
          .andThenAsync((p0) async => Result.ok(await ds(() => p0 + 2)));
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await buildFutureSuccess(1)
          .andThenAsync((p0) async => Result.ok(await ds(() => p0 + 2)))
          .andThenAsync((p0) async => Result.ok(p0.toString()));
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await buildFutureSuccess(1)
          .andThenAsync((p0) async => Result.ok(await ds(() => p0 + 2)))
          .andThenAsync((p0) async => Result.error(errorText))
          .andThenAsync((p0) async => Result.ok(p0.toString()));
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await buildFutureSuccess<String?>('Hello')
          .andThenAsync((s) async => Result.ok(s?.length))
          .andThenAsync((s) async => Result.ok(s == null));
      expect(result1.value, false);
      final result2 = await buildFutureSuccess<String?>(null)
          .andThenAsync((s) async => Result.ok(s?.length))
          .andThenAsync((s) async => Result.ok(s == null));
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await buildFutureSuccess<String?>('Hello')
          .andThenAsync((s) async => Result.ok('$s World'))
          .andThenAsync((s) async => Result.ok(s[s.length + 1]))
          .andThenAsync((s) async => Result.ok('Complete'));
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test transform', () {
    test('Confirm basic flow', () async {
      final result = await buildFutureSuccess(1).transform((p0) => p0 + 2);
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await buildFutureSuccess(1)
          .transform((p0) => p0 + 2)
          .transform((p0) => p0.toString());
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await buildFutureSuccess(1)
          .transform((p0) => p0 + 2)
          .andThen((p0) => Result.error(errorText))
          .transform((p0) => p0.toString());
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await buildFutureSuccess<String?>('Hello')
          .transform((s) => s?.length)
          .transform((s) => s == null);
      expect(result1.value, false);
      final result2 = await buildFutureSuccess<String?>(null)
          .transform((s) => s?.length)
          .transform((s) => s == null);
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await buildFutureSuccess('Hello')
          .transform((s) => '$s World')
          .transform((s) => s[s.length + 1])
          .transform((s) => 'Complete');
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test transformAsync', () {
    test('Confirm basic flow', () async {
      final result = await buildFutureSuccess(1)
          .transformAsync((p0) async => ds(() => p0 + 2));
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await buildFutureSuccess(1)
          .transformAsync((p0) async => ds(() => p0 + 2))
          .transformAsync((p0) async => p0.toString());
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await buildFutureSuccess(1)
          .transformAsync((p0) async => ds(() => p0 + 2))
          .andThenAsync((p0) async => Result.error(errorText))
          .transformAsync((p0) async => p0.toString());
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await buildFutureSuccess<String?>('Hello')
          .transformAsync((s) async => s?.length)
          .transformAsync((s) async => s == null);
      expect(result1.value, false);
      final result2 = await buildFutureSuccess<String?>(null)
          .transformAsync((s) async => s?.length)
          .transformAsync((s) async => s == null);
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await buildFutureSuccess('Hello')
          .transformAsync((s) async => '$s World')
          .transformAsync((s) async => s[s.length + 1])
          .transformAsync((s) async => 'Complete');
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test andThenSuccess', () {
    test('Confirm basic flow', () async {
      final result = await buildFutureSuccess(1).andThenSuccess((p0) => p0 + 2);
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await buildFutureSuccess(1)
          .andThenSuccess((p0) => p0 + 2)
          .andThenSuccess((p0) => p0.toString());
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await buildFutureSuccess(1)
          .andThenSuccess((p0) => p0 + 2)
          .andThen((p0) => Result.error(errorText))
          .andThenSuccess((p0) => p0.toString());
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await buildFutureSuccess<String?>('Hello')
          .andThenSuccess((s) => s?.length)
          .andThenSuccess((s) => s == null);
      expect(result1.value, false);
      final result2 = await buildFutureSuccess<String?>(null)
          .andThenSuccess((s) => s?.length)
          .andThenSuccess((s) => s == null);
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await buildFutureSuccess('Hello')
          .andThenSuccess((s) => '$s World')
          .andThenSuccess((s) => s[s.length + 1])
          .andThenSuccess((s) => 'Complete');
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test andThenSuccessAsync', () {
    test('Confirm basic flow', () async {
      final result = await buildFutureSuccess(1)
          .andThenSuccessAsync((p0) async => ds(() => p0 + 2));
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await buildFutureSuccess(1)
          .andThenSuccessAsync((p0) async => ds(() => p0 + 2))
          .andThenSuccessAsync((p0) async => p0.toString());
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await buildFutureSuccess(1)
          .andThenSuccessAsync((p0) async => ds(() => p0 + 2))
          .andThenAsync((p0) async => Result.error(errorText))
          .andThenSuccessAsync((p0) async => p0.toString());
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await buildFutureSuccess<String?>('Hello')
          .andThenSuccessAsync((s) async => s?.length)
          .andThenSuccessAsync((s) async => s == null);
      expect(result1.value, false);
      final result2 = await buildFutureSuccess<String?>(null)
          .andThenSuccessAsync((s) async => s?.length)
          .andThenSuccessAsync((s) async => s == null);
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await buildFutureSuccess('Hello')
          .andThenSuccessAsync((s) async => '$s World')
          .andThenSuccessAsync((s) async => s[s.length + 1])
          .andThenSuccessAsync((s) async => 'Complete');
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test mapError', () {
    test('Test mapping of error same type', () async {
      final error =
          await buildFutureError('error').mapError((error) => 'error2');
      expect(error.error, equals('error2'));
    });

    test('Test mapping of error same type nullable', () async {
      final error =
          await buildFutureError('error').mapError((error) => 'error2');
      expect(error.error, equals('error2'));
    });

    test('Test mapping of error different type', () async {
      final error =
          await buildFutureError('error').mapError((error) => error.length);
      expect(error.error, equals(5));
    });

    test('Test mapping of error different type nullable', () async {
      final error = await buildFutureError<String?>(null)
          .mapError((error) => error?.length);
      expect(error.error, equals(null));
    });

    test('Test mapping of success type', () async {
      const successValue = 'Success!';
      final mapped =
          await buildFutureSuccess(successValue).mapError((error) => 'error2');
      expect(mapped.value, equals(successValue));
    });

    test('Test mapping of success type nullable', () async {
      final mapped =
          await buildFutureSuccess<String?>(null).mapError((error) => 'error2');
      expect(mapped.value, equals(null));
    });

    test('Test mapping different success type', () async {
      const errorValue = 'An int error';
      final FutureResult<dynamic, String> resultFuture =
          buildFutureError('An int error');
      final FutureResult<String, String> result = resultFuture.errorCast();
      expect((await result).error, equals(errorValue));
    });

    test('Test fails when trying to map a success type with errorCast', () {
      final result1 = buildFutureSuccess(1);
      expect(() async => await result1.errorCast(),
          throwsA(isA<ResultMonadException>()));
    });
  });

  group('Test mapValue', () {
    test('Test mapping of value same type', () async {
      final success =
          await buildFutureSuccess('Success!').mapValue((value) => 'Success2!');
      expect(success.value, equals('Success2!'));
    });

    test('Test mapping of value same type nullable', () async {
      final success = await buildFutureSuccess<String?>(null)
          .mapValue((value) => 'Success2!');
      expect(success.value, equals('Success2!'));
    });

    test('Test mapping of value different type', () async {
      final success = await buildFutureSuccess('Success!')
          .mapValue((value) => value.length);
      expect(success.value, equals(8));
    });

    test('Test mapping of value different type nullable', () async {
      final success = await buildFutureSuccess<String?>(null)
          .mapValue((value) => value?.length);
      expect(success.value, equals(null));
    });

    test('Test mapping of error type', () async {
      const errorValue = 'error';
      final mapped =
          await buildFutureError(errorValue).mapValue((value) => 'Success2!');
      expect(mapped.error, equals(errorValue));
    });

    test('Test mapping of error type', () async {
      final String? errorValue = null;
      final mapped =
          await buildFutureError(errorValue).mapValue((value) => 'Success2!');
      expect(mapped.error, equals(errorValue));
    });
  });

  group('Test withResult', () {
    test('Test simple pass through', () async {
      var resultString1 = '';
      final result = await buildFutureSuccess('Success')
          .withResult((value) => resultString1 = value);
      expect(result.value, equals('Success'));
      expect(resultString1, equals('Success'));
    });
    test('Test error skips', () async {
      var resultString1 = 'Skipped';
      final result = await buildFutureError('Error')
          .withResult((value) => resultString1 = value);
      expect(result.isFailure, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () async {
      final result = await buildFutureSuccess('Success')
          .withResult((value) => value = 'Hello');
      expect(result.value, equals('Success'));
    });
    test('Test exception thrown generates propagated error', () async {
      final result = await buildFutureSuccess('Success')
          .withResult((value) => throw Exception('Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('Error'));
    });
  });

  group('Test withResultAsync', () {
    test('Test simple pass through', () async {
      var resultString1 = '';
      final result = await buildFutureSuccess('Success')
          .withResultAsync((value) async => resultString1 = value);
      expect(result.value, equals('Success'));
      expect(resultString1, equals('Success'));
    });
    test('Test error skips', () async {
      var resultString1 = 'Skipped';
      final result = await buildFutureError('Error')
          .withResultAsync((value) => resultString1 = value);
      expect(result.isFailure, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () async {
      final result = await buildFutureSuccess('Success')
          .withResultAsync((value) async => value = 'Hello');
      expect(result.value, equals('Success'));
    });
    test('Test exception thrown generates propagated error', () async {
      final result = await buildFutureSuccess('Success')
          .withResultAsync((value) async => throw Exception('Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('Error'));
    });
  });

  group('Test withError', () {
    test('Test simple pass through', () async {
      var resultString1 = '';
      final result = await buildFutureError('Error')
          .withError((value, _) => resultString1 = value);
      expect(result.error, equals('Error'));
      expect(resultString1, equals('Error'));
    });
    test('Test success skips', () async {
      var resultString1 = 'Skipped';
      final result = await buildFutureSuccess('Success')
          .withError((value, _) => resultString1 = value);
      expect(result.isSuccess, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () async {
      final result =
          await buildFutureError('Error').withError((value, _) => value = 'Hello');
      expect(result.error, equals('Error'));
    });
    test('Test exception thrown generates propagated error or new type',
        () async {
      final result = await buildFutureError('Error')
          .withError((value, _) => throw Exception('New Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('New Error'));
    });
  });

  group('Test withErrorAsync', () {
    test('Test simple pass through', () async {
      var resultString1 = '';
      final result = await buildFutureError('Error')
          .withErrorAsync((value, _) async => resultString1 = value);
      expect(result.error, equals('Error'));
      expect(resultString1, equals('Error'));
    });
    test('Test success skips', () async {
      var resultString1 = 'Skipped';
      final result = await buildFutureSuccess('Success')
          .withErrorAsync((value, _) async => resultString1 = value);
      expect(result.isSuccess, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () async {
      final result = await buildFutureError('Error')
          .withErrorAsync((value, _) async => value = 'Hello');
      expect(result.error, equals('Error'));
    });
    test('Test exception thrown generates propagated error or new type',
        () async {
      final result = await buildFutureError('Error')
          .withErrorAsync((value, _) async => throw Exception('New Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('New Error'));
    });
  });

  group('Test match', () {
    final expectedSuccess = 'This is a success';
    final expectedFailure = 'This is a failure';

    test('Regular types', () async {
      await buildFutureSuccess(expectedSuccess).match(
          onSuccess: (value) => expect(value, equals(expectedSuccess)),
          onError: (error, _) => fail("Shouldn't execute this path"));

      await buildFutureError(expectedFailure).match(
          onSuccess: (value) => fail("Shouldn't execute this path"),
          onError: (error, _) => expect(error, equals(expectedFailure)));
    });

    test('Nullable Types', () async {
      await buildFutureSuccess(expectedSuccess).match(
          onSuccess: (value) => expect(value, equals(expectedSuccess)),
          onError: (error, _) => fail("Shouldn't execute this path"));

      await buildFutureError(expectedFailure).match(
          onSuccess: (value) => fail("Shouldn't execute this path"),
          onError: (error, _) => expect(error, equals(expectedFailure)));
    });
  });

  group('Test fold', () {
    final expectedSuccess = 'This is a success';
    final expectedFailure = 100;

    test('Regular Types', () async {
      final successFolded = await buildFutureSuccess(expectedSuccess)
          .fold(onSuccess: (value) => value, onError: (error, stack) => 'error');
      expect(successFolded, equals(expectedSuccess));

      final failedFolded = await buildFutureError(100)
          .fold(onSuccess: (value) => 0, onError: (error, stack) => error);
      expect(failedFolded, equals(expectedFailure));
    });

    test('Nullable Types', () async {
      final successFolded = await buildFutureSuccess(expectedSuccess)
          .andThenSuccessAsync((p0) async => p0)
          .fold(onSuccess: (value) => value, onError: (error, stack) => 'error');
      expect(successFolded, equals(expectedSuccess));

      final failedFolded = await buildFutureError(100)
          .andThenSuccessAsync((p0) async => p0)
          .fold(onSuccess: (value) => 0, onError: (error, stack) => error);
      expect(failedFolded, equals(expectedFailure));
      expect(failedFolded, equals(expectedFailure));
    });
  });
}

Future<T> ds<T>(T Function() func) async {
  sleep(Duration(milliseconds: delayMilliseconds));
  return func();
}
