# Result Monad
This is a fork from [HankG/dart-result-monad](https://gitlab.com/HankG/dart-result-monad/) for which we are
grateful. I have added some features and fixed some bugs.

# Docs
A Dart implementation of the Result Monad found in Rust and other languages.
This models either success (ok) or failure (error) of operations to allow for
more expressive result generation and processing without using exceptions.

[This blog post](https://nequalsonelifestyle.com/2021/11/29/result-monads-in-dart-and-flutter/)
I wrote goes into the backgrounds of Result Monads and steps through the
various aspects of the implementation for this library.

## Features

* Result Monad with standard `ok` and `error` constructors
* Methods/properties for directly querying if it is encapsulating a success
  or failure result and to get those values
* `runCatching` and `runCatchingAsync` to encapsulate thrown exception objects into error Results
* `getValueOrElse` and `getErrorOrElse` methods to return a default value if
  it is not the respective desired monad
* `andThen`, `transform`, `andThenAsync`, `transformAsync` for chaining together
  operations with short-circuit capability
* `withResult` and `withResultAsync` for processing results in a pass-through capability with
  short-circuiting on thrown exceptions
* `withError` and `withErrorAsync` for processing errors in a pass-through capability with
  short-circuiting on thrown exceptions, including stacktrace information
* `mapValue`, `mapError`, `errorCast` methods for transforming success and failure types
* `match` method for performing different operations on a success or failure
  monad, with stacktrace information for errors
* `fold` method for transforming the monad into a new result type with different
  logic for success and error cases, including stacktrace information for errors
* Automatic stacktrace capture when using `runCatching` and `runCatchingAsync`

## Getting started

In the `pubspec.yaml` of your Dart/Flutter project, add the following dependency:

```yaml
dependencies:
  result_monad: ^2.5.0
```

In your source code add the following import:

```dart
import 'package:result_monad/result_monad.dart';
```

## Usage

Below is a simple example but see /example for feature rich versions:

```dart
import 'package:result_monad/result_monad.dart';

Result<double, String> invert(double value) {
  if (value == 0) {
    return Result.error('Cannot invert zero');
  }

  return Result.ok(1.0 / value);
}

void main() {
  // Prints 'Inverse is: 0.5'
  invert(2).match(
      onSuccess: (value) => print("Inverse is: $value"),
      onError: (error, stackTrace) => print(error));

  // Prints 'Cannot invert zero'
  invert(0).match(
      onSuccess: (value) => print("Inverse is: $value"),
      onError: (error, stackTrace) => print(error));
}
```

## Stacktrace Support

The Result monad now includes stacktrace support for error handling. This allows you to capture and access the stacktrace where an error occurred, making debugging easier.

```dart
// Create an error with a stacktrace
try {
  // Some code that might throw
  throw Exception('Something went wrong');
} catch (e, stackTrace) {
  return Result.error(e, stackTrace);
}

// Access the stacktrace in error handlers
result.match(
  onSuccess: (value) => print('Success: $value'),
  onError: (error, stackTrace) {
    print('Error: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  },
);

// Automatic stacktrace capture with runCatching
final result = runCatching(() {
  // Code that might throw
  return someRiskyOperation();
});
```

See the `example/stacktrace_example.dart` file for more examples of using stacktrace information.

## Additional information

This result monad implementation takes inspiration from the
[Rust result type](https://doc.rust-lang.org/std/result/index.html)
and the [Kotlin Result](https://github.com/michaelbull/kotlin-result)
implementation of the Result Monad.

The pub.dev package page [can be found here](https://pub.dev/packages/result_monad).