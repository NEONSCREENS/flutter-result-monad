## 2.5.0
- Added stacktrace support to error handling functions
- Updated `withError`, `withErrorAsync`, `match`, and `fold` to include stacktrace parameter
- Added automatic stacktrace capture in `runCatching` and `runCatchingAsync`
- Added stacktrace example in `example/stacktrace_example.dart`
- Added comprehensive tests to verify stacktrace capture and propagation
- Added tests to verify that stacktraces correctly point to the line that threw the exception

## 2.4.0
- Allow const constructors

## 2.3.2

- Tweak to documentation headers to avoid lint error

## 2.3.1

- Tweak to README to include `withError` and `withErrorAsync`

## 2.3.0

- Examples and documentation updates for the new syntax.
- Add to `FutureResult`: `andThen`, `errorCast`, `mapError`, `mapValue`, `withResult`, `withError`, `match`, `fold`
- Add `withError` to Result and `withError` and `withErrorAsync` to `FutureResult`

## 2.1.0

- Add pass through methods `withResult` and `withResultAsync` on Result and Future extension method

## 2.0.2

- Add exception catching on `addThen` and `addThenSuccess` and FutureResult extension methods.

## 2.0.1

- Tweaks to the README only.

## 2.0.0

- Allow nullable types for success and failure types
- Add `andThenSuccess` and `andThenSuccessAsync` methods for allowing returning results without explicit `Result.ok`
  wrapping to allow more concise syntax
- Add extension methods on `FutureResult` to make async chaining syntax much more concise
- Add `errorCast` method for when need to pass up an error Result with the same error type with different success type.

## 1.0.2

- Tweaks to API documentation
- Added temp file "intermediate" level example and added it to `example.md` as well

## 1.0.1

- Added an `example.md` file for pub.dev.

## 1.0.0

- Initial version.
