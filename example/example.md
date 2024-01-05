# Examples

The project ships with examples which you can find
[here](https://gitlab.com/HankG/dart-result-monad/-/tree/main/example).

## Simple Usage

The simplest usage begins with defining the function return to be a
Result Monad. The monad takes two types, the value type for when it
succeeds and an error type for if it fails. The value type is always
whatever the natural return of the function would be. The error type
can be literally anything. For example:

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
      onError: (error) => print(error));

  // Prints 'Cannot invert zero'
  invert(0).match(
      onSuccess: (value) => print("Inverse is: $value"),
      onError: (error) => print(error));
}
```

## Using Error Objects

For more complex cases you may have a reusable error object type that 
can be passed around. In the above example that could be as simple as:

```dart
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

```

## Putting It All Together

For cases where you use the `runCatching`
method to wrap exception-generating code in a way that returns a
Result monad it'll be whatever the `Exception` type that was thrown.
In the above case it is simply an error String. Since the monad
can be queried for if it is encapsulating a success `isSuccess` or
failed `isFailure` options the type chosen is more for how the
developer decides to propagate their errors.

In the above cases we aren't directly querying it but instead using
the `match` method to have two different code paths depending on
whether we are dealing with a succeeded or failed result. In the more
complex example below we are instead using `withError` and `withResult`
to accomplish a similar result instead. See[the API documentation](https://pub.dev/documentation/result_monad/latest/)
for more details.

```dart
import 'dart:io';

import 'package:result_monad/result_monad.dart';

enum ErrorEnum { environment, fileAccess }

void main(List<String> arguments) {
  final stringToWrite = 'Data written to the temp file ${DateTime.now()}';
  final tmpFileResult = getTempFile()
      .withResult((file) => print('Temp file: ${file.path}'))
      .withError((error) => print('Error getting temp file: $error'));

  // Probably would check if failure and stop here normally but want to show
  // that even starting with an error Result Monad flows correctly.
  final writtenSuccessfully = tmpFileResult
      .withResult((file) => file.writeAsStringSync(stringToWrite))
      .transform((file) => file.readAsStringSync())
      .fold(onSuccess: (text) => text == stringToWrite, onError: (_) => false);

  print('Successfully wrote to temp file? $writtenSuccessfully');
}

Result<File, ErrorEnum> getTempFile(
    {String prefix = '', String suffix = '.tmp'}) {
  final tmpName = '$prefix${DateTime.now().millisecondsSinceEpoch}$suffix';
  return getTempFolder()
      .transform((tempFolder) => '$tempFolder${Platform.pathSeparator}$tmpName')
      .transform((tmpPath) => File(tmpPath))
      .mapError((error) => error is ErrorEnum ? error : ErrorEnum.fileAccess);
}

Result<String, ErrorEnum> getTempFolder() {
  String folderName = '';
  if (Platform.isMacOS || Platform.isWindows) {
    final varName = Platform.isMacOS ? 'TMPDIR' : 'TEMP';
    final tempDirPathFromEnv = Platform.environment[varName];
    if (tempDirPathFromEnv != null) {
      folderName = tempDirPathFromEnv;
    } else {
      return Result.error(ErrorEnum.environment);
    }
  } else if (Platform.isLinux) {
    folderName = '/tmp';
  } else {
    return Result.error(ErrorEnum.environment);
  }

  if (folderName.isEmpty) {
    return Result.error(ErrorEnum.environment);
  }

  final Result<bool, dynamic> canWriteResult = runCatching(() {
    if (!Directory(folderName).existsSync()) {
      return Result.ok(false);
    }

    final testFilePath =
        '$folderName${Platform.pathSeparator}${DateTime.now().millisecondsSinceEpoch}.tmp';
    final tmpFile = File(testFilePath);
    tmpFile.writeAsStringSync('test');
    tmpFile.deleteSync();

    return Result.ok(true);
  });

  return canWriteResult
      .andThen<String, ErrorEnum>((canWrite) =>
          canWrite ? Result.ok(folderName) : Result.error(ErrorEnum.fileAccess))
      .mapError((_) => ErrorEnum.fileAccess);
}
```