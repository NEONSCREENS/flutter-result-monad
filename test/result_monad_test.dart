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
    });
  });

  group('Test failure monad', () {
    test('Test create error', () {
      const errorValue = 'Error';
      final failure = Result.error(errorValue);
      expect(failure.isFailure, true);
      expect(failure.isSuccess, false);
      expect(failure.error, errorValue);
    });
  });

  group('Test success value accessor', () {
    test('Test getting value from success', () {
      const resultValue = 'Awesome';
      final success = Result.ok('Awesome');
      expect(success.value, resultValue);
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

    test('Test getValueOrElse on success', () {
      final failure = Result.ok('It worked!');
      const elseResponse = 'I guess it failed';
      expect(failure.getValueOrElse(() => elseResponse), equals('It worked!'));
    });
  });

  group('Test getErrorOrElse', () {
    test('Test getErrorOrElse on failure', () {
      final failure = Result.error('This is a failure');
      const elseResponse = 'Did not have an error';
      expect(failure.getErrorOrElse(() => elseResponse),
          equals('This is a failure'));
    });

    test('Test getErrorOrElse on success', () {
      final failure = Result.ok('It worked');
      const elseResponse = 'Did not have an error';
      expect(failure.getErrorOrElse(() => elseResponse),
          equals('Did not have an error'));
    });
  });

  test('Test match', () {
    final success = Result.ok('This is a success');
    success.match(
        onSuccess: (value) => expect(value, equals(success.value)),
        onError: (error) => fail("Shouldn't execute this path"));

    final failure = Result.error('This is a failure');
    failure.match(
        onSuccess: (value) => fail("Shouldn't execute this path"),
        onError: (error) => expect(error, equals(failure.error)));
  });

  test('Test fold', () {
    final success = Result<String, int>.ok('It worked!');
    final successFolded = success.fold(
        onSuccess: (value) => success.value, onError: (error) => 'error');
    expect(successFolded, equals(success.value));

    final failed = Result<String, int>.error(100);
    final failedFolded =
        failed.fold(onSuccess: (value) => 0, onError: (error) => error);
    expect(failedFolded, equals(failed.error));
  });

  // simpler 'and then' tests
  group('Test andThen', () {
    test('Test chaining through to end', () async {
      final result = Result.ok('Success')
          .andThen((value) => Result.ok(value.length))
          .andThen((value) => Result.ok('Original string length: $value'));
      expect(result.value, equals('Original string length: 7'));
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
  });

  group('Test andThenAsync', () {
    test('Test success result', () async {
      final result = await (await Result.ok('Success')
              .andThenAsync((value) async => Result.ok(value.length)))
          .andThenAsync(
              (value) async => Result.ok('Original string length: $value'));
      expect(result.value, equals('Original string length: 7'));
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

  group('Test mapError', () {
    test('Test mapping of error same type', () {
      final error1 = Result.error('error');
      final error2 = error1.mapError((error) => 'error2');
      expect(error2.error, equals('error2'));
    });

    test('Test mapping of error different type', () {
      final error1 = Result.error('error');
      final error2 = error1.mapError((error) => error.length);
      expect(error2.error, equals(5));
    });

    test('Test mapping of success type', () {
      final success = Result.ok('Success!');
      final mapped = success.mapError((error) => 'error2');
      expect(mapped.value, equals(success.value));
    });
  });

  group('Test mapValue', () {
    test('Test mapping of value same type', () {
      final success = Result.ok('Success!');
      final success2 = success.mapValue((value) => 'Success2!');
      expect(success2.value, equals('Success2!'));
    });
    test('Test mapping of value different type', () {
      final success = Result.ok('Success!');
      final success2 = success.mapValue((value) => value.length);
      expect(success2.value, equals(8));
    });
    test('Test mapping of error type', () {
      final error = Result.error('error');
      final mapped = error.mapValue((value) => 'Success2!');
      expect(mapped.error, equals(error.error));
    });
  });

  test('Test to string', () {
    expect(Result.ok(10).toString(), equals('ok(10)'));
    expect(Result.error(10).toString(), equals('error(10)'));
  });
}
