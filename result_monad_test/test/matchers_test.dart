import 'package:result_monad/result_monad.dart';
import 'package:result_monad_test/result_monad_test.dart';
import 'package:test/test.dart';

void main() {
  group('isOk', () {
    test('matches an Ok result', () {
      final result = Result<int, String>.ok(42);
      expect(result, isOk());
    });

    test('does not match an Error result', () {
      final result = Result<int, String>.error('fail');
      expect(result, isNot(isOk()));
    });

    test('matches Ok with expected value', () {
      final result = Result<String, int>.ok('hello');
      expect(result, isOk('hello'));
    });

    test('does not match Ok with wrong value', () {
      final result = Result<String, int>.ok('hello');
      expect(result, isNot(isOk('world')));
    });

    test('matches with generic type parameter', () {
      final result = Result<int, String>.ok(10);
      expect(result, isOk<int>());
    });

    test('does not match wrong generic type', () {
      final Result<dynamic, String> result = Result.ok('a string');
      expect(result, isNot(isOk<int>()));
    });

    test('is chainable with having for nested checks', () {
      final result = Result<List<int>, String>.ok([1, 2, 3]);
      expect(
        result,
        isOk<List<int>>().having((r) => r.value.length, 'length', 3),
      );
    });

    test('works with const results', () {
      const result = Result<int, String>.ok(0);
      expect(result, isOk(0));
    });
  });

  group('isError', () {
    test('matches an Error result', () {
      final result = Result<int, String>.error('fail');
      expect(result, isError());
    });

    test('does not match an Ok result', () {
      final result = Result<int, String>.ok(42);
      expect(result, isNot(isError()));
    });

    test('matches Error with expected value', () {
      final result = Result<int, String>.error('not found');
      expect(result, isError('not found'));
    });

    test('does not match Error with wrong value', () {
      final result = Result<int, String>.error('not found');
      expect(result, isNot(isError('timeout')));
    });

    test('matches with generic type parameter', () {
      final result = Result<int, String>.error('fail');
      expect(result, isError<String>());
    });

    test('does not match wrong generic type', () {
      final Result<int, dynamic> result = Result.error(42);
      expect(result, isNot(isError<String>()));
    });

    test('is chainable with having for nested checks', () {
      final result = Result<int, String>.error('connection timeout');
      expect(
        result,
        isError<String>().having(
          (r) => r.cause,
          'cause',
          contains('timeout'),
        ),
      );
    });

    test('works with const results', () {
      const result = Result<int, String>.error('err');
      expect(result, isError('err'));
    });

    test('preserves stacktrace access in having chain', () {
      final trace = StackTrace.current;
      final result = Result<int, String>.error('fail', trace);
      expect(
        result,
        isError<String>().having((r) => r.stackTrace, 'stackTrace', trace),
      );
    });
  });

  group('isOk and isError together', () {
    test('Ok and Error are mutually exclusive', () {
      final ok = Result<int, String>.ok(1);
      final err = Result<int, String>.error('e');

      expect(ok, isOk());
      expect(ok, isNot(isError()));
      expect(err, isError());
      expect(err, isNot(isOk()));
    });

    test('work with dynamic error type', () {
      final result = Result.ok(42);
      expect(result, isOk(42));
    });

    test('work with dynamic success type', () {
      final result = Result.error('oops');
      expect(result, isError('oops'));
    });
  });
}
