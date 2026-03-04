import 'package:result_monad/result_monad.dart';
import 'package:result_monad_test/result_monad_test.dart';
import 'package:test/test.dart';

void main() {
  test('isOk matches success results', () {
    final result = Result<int, String>.ok(42);

    expect(result, isOk());
    expect(result, isOk(42));
    expect(result, isOk<int>());
    expect(result, isOk<int>().having((r) => r.value, 'value', greaterThan(0)));
  });

  test('isError matches failure results', () {
    final result = Result<int, String>.error('not found');

    expect(result, isError());
    expect(result, isError('not found'));
    expect(result, isError<String>());
    expect(
      result,
      isError<String>().having((r) => r.cause, 'cause', contains('not')),
    );
  });
}
