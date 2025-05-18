import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

// This class is used to test that the stacktrace points to the correct line
class ErrorThrower {
  // This method will throw an exception
  static Result<int, Exception> throwError() {
    // This line number is important for the test
    throw Exception('Test exception');
  }
  
  // This method will catch the exception and return a Result
  static Result<int, Exception> catchError() {
    try {
      return throwError();
    } catch (e, stackTrace) {
      return Result.error(Exception('Caught exception'), stackTrace);
    }
  }
  
  // This method will use runCatching to catch the exception
  static Result<int, dynamic> runCatchingError() {
    return runCatching(() {
      // This will call the method that throws
      return throwError();
    });
  }
}

void main() {
  group('Stacktrace Line Tests', () {
    test('Stacktrace from manually caught exception should point to the throw line', () {
      final result = ErrorThrower.catchError();
      
      expect(result.isFailure, isTrue);
      expect(result.error, isA<Exception>());
      expect(result.stackTrace, isNotNull);
      
      // Verify the stacktrace contains the file and line number of the throw
      final stackTraceString = result.stackTrace.toString();
      expect(stackTraceString.contains('stacktrace_line_test.dart'), isTrue);
      
      // The line number should be close to the throw statement in throwError
      final fileLinePattern = RegExp(r'stacktrace_line_test.dart:(\d+)');
      final matches = fileLinePattern.allMatches(stackTraceString).toList();
      
      // We should have at least one match
      expect(matches.isNotEmpty, isTrue);
      
      // Find the line number of the throw statement
      bool foundThrowLine = false;
      for (final match in matches) {
        final lineNumber = int.parse(match.group(1)!);
        // The throw is on line 8 (or close to it)
        if (lineNumber >= 7 && lineNumber <= 9) {
          foundThrowLine = true;
          break;
        }
      }
      
      expect(foundThrowLine, isTrue, reason: 'Stacktrace should contain the line where the exception was thrown');
    });
    
    test('Stacktrace from runCatching should point to the throw line', () {
      final result = ErrorThrower.runCatchingError();
      
      expect(result.isFailure, isTrue);
      expect(result.error, isA<Exception>());
      expect(result.stackTrace, isNotNull);
      
      // Verify the stacktrace contains the file and line number of the throw
      final stackTraceString = result.stackTrace.toString();
      expect(stackTraceString.contains('stacktrace_line_test.dart'), isTrue);
      
      // The line number should be close to the throw statement in throwError
      final fileLinePattern = RegExp(r'stacktrace_line_test.dart:(\d+)');
      final matches = fileLinePattern.allMatches(stackTraceString).toList();
      
      // We should have at least one match
      expect(matches.isNotEmpty, isTrue);
      
      // Find the line number of the throw statement
      bool foundThrowLine = false;
      for (final match in matches) {
        final lineNumber = int.parse(match.group(1)!);
        // The throw is on line 8 (or close to it)
        if (lineNumber >= 7 && lineNumber <= 9) {
          foundThrowLine = true;
          break;
        }
      }
      
      expect(foundThrowLine, isTrue, reason: 'Stacktrace should contain the line where the exception was thrown');
    });
  });
}
