import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

void main() {
  group('Test ResultMonadException', () {
    group('Test predefined constructors', () {
      test('Test accessFailureOnSuccess', () {
        final exception = ResultMonadException.accessFailureOnSuccess();
        expect(exception.message,
            equals('Attempted to pull a failure value from a success monad'));
      });

      test('Test accessSuccessOnFailure', () {
        final exception = ResultMonadException.accessSuccessOnFailure();
        expect(exception.message,
            equals('Attempted to pull a success value from a failure monad'));
      });
    });

    test('Test normal constructor', () {
      final msg = 'Error Message';
      final exception = ResultMonadException(msg);
      expect(exception.message, equals(msg));
    });

    test('Test toString()', () {
      final msg = 'Error Message';
      final expected = 'ResultMonadException{message: $msg}';
      final exception = ResultMonadException(msg);
      expect(exception.toString(), equals(expected));
    });
  });
}
