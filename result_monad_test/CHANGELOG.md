## 1.0.0

- Initial release
- `isOk<T>()` matcher — asserts `Result` is `Ok`, optional value equality, generic type narrowing
- `isError<E>()` matcher — asserts `Result` is `Error`, optional cause equality, generic type narrowing
- Pure Dart — depends on `package:matcher`, not `flutter_test`
- Compatible with both `package:test` and `package:flutter_test`
