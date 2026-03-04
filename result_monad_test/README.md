# result_monad_test

Test matchers for the [result_monad](https://github.com/NEONSCREENS/flutter-result-monad) package. Provides `isOk` and `isError` matchers for expressive `Result` assertions.

Pure Dart — works with both `package:test` and `package:flutter_test`.

## Install

```yaml
dev_dependencies:
  result_monad_test: ^1.0.0
```

## Usage

```dart
import 'package:result_monad/result_monad.dart';
import 'package:result_monad_test/result_monad_test.dart';
import 'package:test/test.dart';

void main() {
  test('basic matchers', () {
    final ok = Result<int, String>.ok(42);
    final err = Result<int, String>.error('not found');

    // Type check only
    expect(ok, isOk());
    expect(err, isError());

    // Value/cause equality
    expect(ok, isOk(42));
    expect(err, isError('not found'));

    // Generic type narrowing
    expect(ok, isOk<int>());
    expect(err, isError<String>());

    // Chained assertions via .having()
    expect(ok, isOk<int>().having((r) => r.value, 'value', greaterThan(0)));
    expect(err, isError<String>().having((r) => r.cause, 'cause', contains('not')));
  });
}
```

### `isOk<T>([Object? expected])`

Returns a `TypeMatcher<Ok<T, dynamic>>`. `T` is the **success** type.

| Call | Asserts |
|------|---------|
| `isOk()` | Result is `Ok` |
| `isOk(42)` | Result is `Ok` with `value == 42` |
| `isOk<int>()` | Result is `Ok<int, dynamic>` |

### `isError<E>([Object? expected])`

Returns a `TypeMatcher<Error<dynamic, E>>`. `E` is the **error** type.

| Call | Asserts |
|------|---------|
| `isError()` | Result is `Error` |
| `isError('fail')` | Result is `Error` with `cause == 'fail'` |
| `isError<String>()` | Result is `Error<dynamic, String>` |
