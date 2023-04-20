/// Illustrates are more real world comprehensive use of the library with
/// an example of a function that returns a temporary file in the OS
/// specified temporary directory and then attempting to write into that file.
///
///
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
