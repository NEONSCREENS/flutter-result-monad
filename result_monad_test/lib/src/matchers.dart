import 'package:matcher/matcher.dart';
import 'package:result_monad/result_monad.dart';

/// Matches a [Result] that is [Ok].
///
/// Without argument — asserts only that the result is Ok:
///   expect(result, isOk());
///
/// With [expected] — also asserts value equality:
///   expect(result, isOk(42));
///
/// Chainable with `.having()` for nested checks:
///   expect(result, isOk<int>()
///       .having((r) => r.value, 'value', greaterThan(0)));
TypeMatcher<Ok<T, dynamic>> isOk<T>([Object? expected]) {
  final matcher = isA<Ok<T, dynamic>>();
  if (expected != null) {
    return matcher.having((r) => r.value, 'value', expected);
  }
  return matcher;
}

/// Matches a [Result] that is [Error].
///
/// Without argument — asserts only that the result is Error:
///   expect(result, isError());
///
/// With [expected] — also asserts error equality:
///   expect(result, isError('not found'));
///
/// Chainable with `.having()` for nested checks:
///   expect(result, isError<String>()
///       .having((r) => r.cause, 'cause', contains('timeout')));
TypeMatcher<Error<dynamic, T>> isError<T>([Object? expected]) {
  final matcher = isA<Error<dynamic, T>>();
  if (expected != null) {
    return matcher.having((r) => r.cause, 'error', expected);
  }
  return matcher;
}
