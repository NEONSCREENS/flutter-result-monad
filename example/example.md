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