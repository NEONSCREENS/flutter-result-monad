import 'dart:io';

import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

const delayMilliseconds = 100;

void main() {
  group('Test andThenAsync', () {
    test('Confirm basic flow', () async {
      final result = await Result.ok(1)
          .andThenAsync((p0) async => Result.ok(await ds(() => p0 + 2)));
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await Result.ok(1)
          .andThenAsync((p0) async => Result.ok(await ds(() => p0 + 2)))
          .andThenAsync((p0) async => Result.ok(p0.toString()));
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await Result<int, int>.ok(1)
          .andThenAsync((p0) async => Result.ok(await ds(() => p0 + 2)))
          .andThenAsync((p0) async => Result.error(errorText))
          .andThenAsync((p0) async => Result.ok(p0.toString()));
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await Result<String?, dynamic>.ok('Hello')
          .andThenAsync((s) async => Result.ok(s?.length))
          .andThenAsync((s) async => Result.ok(s == null));
      expect(result1.value, false);
      final result2 = await Result<String?, dynamic>.ok(null)
          .andThenAsync((s) async => Result.ok(s?.length))
          .andThenAsync((s) async => Result.ok(s == null));
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await Result<String?, dynamic>.ok('Hello')
          .andThenAsync((s) async => Result.ok('$s World'))
          .andThenAsync((s) async => Result.ok(s[s.length + 1]))
          .andThenAsync((s) async => Result.ok('Complete'));
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test transformAsync', () {
    test('Confirm basic flow', () async {
      final result =
          await Result.ok(1).transformAsync((p0) async => ds(() => p0 + 2));
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await Result.ok(1)
          .transformAsync((p0) async => ds(() => p0 + 2))
          .transformAsync((p0) async => p0.toString());
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await Result<int, int>.ok(1)
          .transformAsync((p0) async => ds(() => p0 + 2))
          .andThenAsync((p0) async => Result.error(errorText))
          .transformAsync((p0) async => p0.toString());
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await Result<String?, dynamic>.ok('Hello')
          .transformAsync((s) async => s?.length)
          .transformAsync((s) async => s == null);
      expect(result1.value, false);
      final result2 = await Result<String?, dynamic>.ok(null)
          .transformAsync((s) async => s?.length)
          .transformAsync((s) async => s == null);
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await Result<String?, dynamic>.ok('Hello')
          .transformAsync((s) async => '$s World')
          .transformAsync((s) async => s[s.length + 1])
          .transformAsync((s) async => 'Complete');
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test andThenSuccessAsync', () {
    test('Confirm basic flow', () async {
      final result = await Result.ok(1)
          .andThenSuccessAsync((p0) async => ds(() => p0 + 2));
      expect(result.isSuccess, true);
      expect(result.value, equals(3));
    });

    test('Confirm result type transformation flow', () async {
      final result = await Result.ok(1)
          .andThenSuccessAsync((p0) async => ds(() => p0 + 2))
          .andThenSuccessAsync((p0) async => p0.toString());
      expect(result.isSuccess, true);
      expect(result.value, equals('3'));
    });

    test('Confirm result error transformation flow', () async {
      const errorText = 'This is an error';
      final result = await Result<int, int>.ok(1)
          .andThenSuccessAsync((p0) async => ds(() => p0 + 2))
          .andThenAsync((p0) async => Result.error(errorText))
          .andThenSuccessAsync((p0) async => p0.toString());
      expect(result.isFailure, true);
      expect(result.error, equals(errorText));
    });

    test('Confirm result null propagation flow', () async {
      final result1 = await Result<String?, dynamic>.ok('Hello')
          .andThenSuccessAsync((s) async => s?.length)
          .andThenSuccessAsync((s) async => s == null);
      expect(result1.value, false);
      final result2 = await Result<String?, dynamic>.ok(null)
          .andThenSuccessAsync((s) async => s?.length)
          .andThenSuccessAsync((s) async => s == null);
      expect(result2.value, true);
    });

    test('Confirm result exception catching flow', () async {
      final result = await Result<String?, dynamic>.ok('Hello')
          .andThenSuccessAsync((s) async => '$s World')
          .andThenSuccessAsync((s) async => s[s.length + 1])
          .andThenSuccessAsync((s) async => 'Complete');
      expect(result.isFailure, true);
      expect(result.error, isA<RangeError>());
    });
  });

  group('Test withResultAsync', () {
    test('Test simple pass through', () async {
      var resultString1 = '';
      final result = await Result.ok('Success')
          .andThenSuccessAsync((p0) async => p0)
          .withResultAsync((value) async => resultString1 = value);
      expect(result.value, equals('Success'));
      expect(resultString1, equals('Success'));
    });
    test('Test error skips', () async {
      var resultString1 = 'Skipped';
      final result = await Result.error('Error')
          .andThenSuccessAsync((p0) async => p0)
          .withResultAsync((value) => resultString1 = value);
      expect(result.isFailure, equals(true));
      expect(resultString1, equals('Skipped'));
    });
    test('Test pass through mutation does not propagate', () async {
      final result = await Result.ok('Success')
          .andThenSuccessAsync((p0) async => p0)
          .withResultAsync((value) async => value = 'Hello');
      expect(result.value, equals('Success'));
    });
    test('Test exception thrown generates propagated error', () async {
      final result = await Result.ok('Success')
          .andThenSuccessAsync((p0) async => p0)
          .withResultAsync((value) async => throw Exception('Error'));
      expect(result.isFailure, equals(true));
      expect(result.error.message, equals('Error'));
    });
  });

  group('Test match', () {
    final expectedSuccess = 'This is a success';
    final expectedFailure = 'This is a failure';

    test('Regular types', () async {
      await Result.ok(expectedSuccess)
          .andThenSuccessAsync((p0) async => p0)
          .match(
              onSuccess: (value) => expect(value, equals(expectedSuccess)),
              onError: (error) => fail("Shouldn't execute this path"));

      await Result.error(expectedFailure)
          .andThenSuccessAsync((p0) async => p0)
          .match(
              onSuccess: (value) => fail("Shouldn't execute this path"),
              onError: (error) => expect(error, equals(expectedFailure)));
    });

    test('Nullable Types', () async {
      await Result<String?, String?>.ok(expectedSuccess)
          .andThenSuccessAsync((p0) async => p0)
          .match(
              onSuccess: (value) => expect(value, equals(expectedSuccess)),
              onError: (error) => fail("Shouldn't execute this path"));

      await Result<String?, String?>.error(expectedFailure)
          .andThenSuccessAsync((p0) async => p0)
          .match(
              onSuccess: (value) => fail("Shouldn't execute this path"),
              onError: (error) => expect(error, equals(expectedFailure)));
    });
  });

  group('Test fold', () {
    final expectedSuccess = 'This is a success';
    final expectedFailure = 100;

    test('Regular Types', () async {
      final successFolded = await Result<String, int>.ok(expectedSuccess)
          .andThenSuccessAsync((p0) async => p0)
          .fold(onSuccess: (value) => value, onError: (error) => 'error');
      expect(successFolded, equals(expectedSuccess));

      final failedFolded = await Result<String, int>.error(100)
          .andThenSuccessAsync((p0) async => p0)
          .fold(onSuccess: (value) => 0, onError: (error) => error);
      expect(failedFolded, equals(expectedFailure));
    });

    test('Nullable Types', () async {
      final successFolded = await Result<String?, int?>.ok(expectedSuccess)
          .andThenSuccessAsync((p0) async => p0)
          .fold(onSuccess: (value) => value, onError: (error) => 'error');
      expect(successFolded, equals(expectedSuccess));

      final failedFolded = await Result<String?, int?>.error(100)
          .andThenSuccessAsync((p0) async => p0)
          .fold(onSuccess: (value) => 0, onError: (error) => error);
      expect(failedFolded, equals(expectedFailure));
      expect(failedFolded, equals(expectedFailure));
    });
  });
}

Future<T> ds<T>(T Function() func) async {
  sleep(Duration(milliseconds: delayMilliseconds));
  return func();
}
