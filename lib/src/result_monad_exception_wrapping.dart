import '../result_monad.dart';

/// Allows library users to wrap potential exception throwing code in a way that
/// transforms thrown exception objects into a failure monad.
/// Runs the passed in function catching any thrown error objects and returning
/// it as a result monad.
///
/// If the function completes without throwing an exception its corresponding
/// value is returned. If an exception is thrown then an error monad will be
/// returned instead.
/// ```dart
/// final sizeResult = runCatching((){
///   final file = File(filename);
///   final stat = file.statsSync();
///   return stat.fileSize();
/// });
///
/// sizeResult.match(
///   (size) => print('File size: $size'),
///   (error) => print('Error accessing $filename: $error')
/// );
/// ```
///
Result<T, dynamic> runCatching<T>(Result<T, dynamic> Function() function) {
  try {
    return function();
  } catch (e) {
    return Result.error(e);
  }
}

/// Runs the passed in async function catching any thrown error objects and
/// returning it as a result monad.
///
/// If the function completes without throwing an exception its corresponding
/// value is returned. If an exception is thrown then an error monad will be
/// returned instead.
/// ```dart
/// final sizeResult = await runCatching(()async{
///   final file = File(filename);
///   final stat = await file.stats();
///   return stat.fileSize();
/// });
///
/// sizeResult.match(
///   (size) => print('File size: $size'),
///   (error) => print('Error accessing $filename: $error')
/// );
/// ```
///
FutureResult<T, dynamic> runCatchingAsync<T>(
    FutureResult<T, dynamic> Function() function) async {
  try {
    return await function();
  } catch (e) {
    return Result.error(e);
  }
}
