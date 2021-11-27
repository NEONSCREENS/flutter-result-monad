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
}