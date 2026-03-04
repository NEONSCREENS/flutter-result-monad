/// Test matchers and utilities for the result_monad package.
///
/// Provides [isOk] and [isError] matchers for expressive Result assertions
/// in tests.
///
/// ```dart
/// import 'package:result_monad_test/result_monad_test.dart';
///
/// expect(result, isOk());
/// expect(result, isOk(42));
/// expect(result, isOk<int>().having((r) => r.value, 'value', greaterThan(0)));
///
/// expect(result, isError());
/// expect(result, isError('not found'));
/// ```
library result_monad_test;

export 'src/matchers.dart';
