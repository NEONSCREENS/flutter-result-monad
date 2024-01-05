import 'dart:math' as math;

import 'package:result_monad/result_monad.dart';

enum MathError {
  divideByZero,
  undefinedResult,
}

Result<double, MathError> invert(double value) {
  if (value == 0) {
    return Result.error(MathError.divideByZero);
  }

  return Result.ok(1.0 / value);
}

Result<double, MathError> sqrt(double x) {
  if (x < 0) {
    return Result.error(MathError.undefinedResult);
  }

  return Result.ok(math.sqrt(x));
}

void main() {
  // Prints 'Inverse is: 0.5'
  invert(2).match(
    onSuccess: (value) => print("Inverse is: $value"),
    onError: (error) => print(error),
  );

  // Prints 'Cannot invert zero'
  invert(0).match(
    onSuccess: (value) => print("Inverse is: $value"),
    onError: (error) => print(error),
  );

  sqrt(4).match(
    onSuccess: (value) => print("Sqrt is: $value"),
    onError: (error) => print(error),
  );

  sqrt(-1).match(
    onSuccess: (value) => print("Sqrt is: $value"),
    onError: (error) => print('Error calculating sqrt(-1): $error'),
  );
}
