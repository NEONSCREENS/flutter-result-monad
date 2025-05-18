import 'package:result_monad/result_monad.dart';

/// This example demonstrates how to use the stacktrace information
/// with the Result monad's error handling functions.

// Example of manually creating an error without a stacktrace
Result<int, String> divideNumbers(int a, int b) {
  if (b == 0) {
    return Result.error('Cannot divide by zero');
  }
  return Result.ok(a ~/ b);
}

// Example of manually creating an error with a stacktrace
Result<int, String> divideNumbersWithStacktrace(int a, int b) {
  if (b == 0) {
    // Capture the current stacktrace when creating the error
    return Result.error('Cannot divide by zero', StackTrace.current);
  }
  return Result.ok(a ~/ b);
}

// Example of catching an exception and preserving its stacktrace
Result<int, Exception> causeException() {
  try {
    // This will cause a RangeError
    final list = [1, 2, 3];
    return Result.ok(list[10]);
  } catch (e, stackTrace) {
    // Capture both the exception and the stacktrace
    return Result.error(Exception('Index out of range'), stackTrace);
  }
}

void main() {
  print('Example 1: Error without stacktrace - Using withError');
  divideNumbers(10, 0).withError((error, stackTrace) {
    print('Error: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    } else {
      print('No stacktrace available');
    }
  });

  print('\nExample 2: Error with stacktrace - Using withError');
  divideNumbersWithStacktrace(10, 0).withError((error, stackTrace) {
    print('Error: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    } else {
      print('No stacktrace available');
    }
  });

  print('\nExample 3: Error without stacktrace - Using match');
  divideNumbers(10, 0).match(
    onSuccess: (value) => print('Result: $value'),
    onError: (error, stackTrace) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      } else {
        print('No stacktrace available');
      }
    },
  );

  print('\nExample 4: Error with stacktrace - Using match');
  divideNumbersWithStacktrace(10, 0).match(
    onSuccess: (value) => print('Result: $value'),
    onError: (error, stackTrace) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      } else {
        print('No stacktrace available');
      }
    },
  );

  print('\nExample 5: Error without stacktrace - Using fold');
  final result1 = divideNumbers(10, 0).fold(
    onSuccess: (value) => 'Success: $value',
    onError: (error, stackTrace) => 'Error: $error${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}',
  );
  print(result1);

  print('\nExample 6: Error with stacktrace - Using fold');
  final result2 = divideNumbersWithStacktrace(10, 0).fold(
    onSuccess: (value) => 'Success: $value',
    onError: (error, stackTrace) => 'Error: $error${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}',
  );
  print(result2);

  print('\nExample 7: Caught exception with stacktrace');
  causeException().match(
    onSuccess: (value) => print('Result: $value'),
    onError: (error, stackTrace) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      } else {
        print('No stacktrace available');
      }
    },
  );

  print('\nExample 8: Using runCatching to automatically capture stacktrace');
  final caughtResult = runCatching(() {
    final list = [1, 2, 3];
    return Result.ok(list[10]);
  });

  caughtResult.match(
    onSuccess: (value) => print('Result: $value'),
    onError: (error, stackTrace) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      } else {
        print('No stacktrace available');
      }
    },
  );

  print('\nExample 9: Using runCatchingAsync to automatically capture stacktrace');
  runCatchingAsync(() async {
    await Future.delayed(Duration(milliseconds: 100));
    final list = [1, 2, 3];
    return Result.ok(list[10]);
  }).then((result) {
    result.match(
      onSuccess: (value) => print('Result: $value'),
      onError: (error, stackTrace) {
        print('Error: $error');
        if (stackTrace != null) {
          print('StackTrace: $stackTrace');
        } else {
          print('No stacktrace available');
        }
      },
    );
  });
}
