# Examples

The project ships with examples which you can find 
[here](https://gitlab.com/HankG/dart-result-monad/-/tree/main/example).

## Simple Usage

The simplest usage begins with defining the function return to be a 
Result Monad. The monad takes two types, the value type for when it
succeeds and an error type for if it fails. The value type is always
whatever the natural return of the function would be. The error type
can be literally anything. For more complex cases you may have a 
reusable object type. For cases where you use the `runCatching` 
method to wrap exception-generating code in a way that returns a 
Result monad it'll be whatever the `Exception` type that was thrown.
In the below case it is simply an error String. Since the monad 
can be queried for if it is encapsulating a success `isSuccess` or
failed `isFailure` options the type chosen is more for how the
developer decides to propagate their errors.

In the below case we aren't directly querying it but instead using
the `match` method to have two different code paths depending on
whether we are dealing with a succeeded or failed result. See
[the API documentation](https://pub.dev/documentation/result_monad/latest/)
for more details.

```dart
import 'package:result_monad/result_monad.dart';

Result<double, String> invert(double value) {
  if (value == 0) {
    return Result.error('Cannot invert zero');
  }

  return Result.ok(1.0/value);
}

void main() {
  // Prints 'Inverse is: 0.5'
  invert(2).match(
      onSuccess: (value) => print("Inverse is: $value"),
      onError: (error) => print(error));

  // Prints 'Cannot invert zero'
  invert(0).match(
      onSuccess: (value) => print("Inverse is: $value"),
      onError: (error) => print(error));
}```