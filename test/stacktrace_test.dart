import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

void main() {
  group('Stacktrace Tests', () {
    test('Result.error should accept a stacktrace', () {
      final stackTrace = StackTrace.current;
      final result = Result.error('Error message', stackTrace);

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Error message'));
      expect(result.stackTrace, equals(stackTrace));
    });

    test('Result.error should have null stacktrace when not provided', () {
      final result = Result.error('Error message');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Error message'));
      expect(result.stackTrace, isNull);
    });

    test('runCatching should capture stacktrace from thrown exception', () {
      final result = runCatching(() {
        // This line number is important for the test below
        throw Exception('Test exception');
      });

      expect(result.isFailure, isTrue);
      expect(result.error, isA<Exception>());
      expect(result.stackTrace, isNotNull);

      // Verify the stacktrace contains this file and line number
      final stackTraceString = result.stackTrace.toString();
      expect(stackTraceString.contains('stacktrace_test.dart'), isTrue);

      // The line number should be close to the throw statement
      final fileLinePattern = RegExp(r'stacktrace_test.dart:(\d+)');
      final match = fileLinePattern.firstMatch(stackTraceString);
      expect(match, isNotNull);

      if (match != null) {
        final lineNumber = int.parse(match.group(1)!);
        // The line number should be close to the throw statement
        // We use a range because the exact line might change with edits
        expect(lineNumber, greaterThan(10));
        expect(lineNumber, lessThan(30));
      }
    });

    test('runCatchingAsync should capture stacktrace from thrown exception', () async {
      final result = await runCatchingAsync(() async {
        // This line number is important for the test below
        throw Exception('Test async exception');
      });

      expect(result.isFailure, isTrue);
      expect(result.error, isA<Exception>());
      expect(result.stackTrace, isNotNull);

      // Verify the stacktrace contains this file and line number
      final stackTraceString = result.stackTrace.toString();
      expect(stackTraceString.contains('stacktrace_test.dart'), isTrue);

      // The line number should be close to the throw statement
      final fileLinePattern = RegExp(r'stacktrace_test.dart:(\d+)');
      final match = fileLinePattern.firstMatch(stackTraceString);
      expect(match, isNotNull);

      if (match != null) {
        final lineNumber = int.parse(match.group(1)!);
        // The line number should be close to the throw statement
        // We use a range because the exact line might change with edits
        expect(lineNumber, greaterThan(35));
        expect(lineNumber, lessThan(60));
      }
    });

    test('withError should pass stacktrace to callback', () {
      bool stackTraceReceived = false;
      final stackTrace = StackTrace.current;

      Result.error('Error message', stackTrace).withError((error, st) {
        expect(error, equals('Error message'));
        expect(st, equals(stackTrace));
        stackTraceReceived = true;
      });

      expect(stackTraceReceived, isTrue);
    });

    test('withErrorAsync should pass stacktrace to callback', () async {
      bool stackTraceReceived = false;
      final stackTrace = StackTrace.current;

      await Result.error('Error message', stackTrace).withErrorAsync((error, st) async {
        expect(error, equals('Error message'));
        expect(st, equals(stackTrace));
        stackTraceReceived = true;
      });

      expect(stackTraceReceived, isTrue);
    });

    test('match should pass stacktrace to onError callback', () {
      bool stackTraceReceived = false;
      final stackTrace = StackTrace.current;

      Result.error('Error message', stackTrace).match(
        onSuccess: (value) => fail('Should not call onSuccess'),
        onError: (error, st) {
          expect(error, equals('Error message'));
          expect(st, equals(stackTrace));
          stackTraceReceived = true;
        },
      );

      expect(stackTraceReceived, isTrue);
    });

    test('fold should pass stacktrace to onError callback', () {
      bool stackTraceReceived = false;
      final stackTrace = StackTrace.current;

      final result = Result.error('Error message', stackTrace).fold(
        onSuccess: (value) => 'Success',
        onError: (error, st) {
          expect(error, equals('Error message'));
          expect(st, equals(stackTrace));
          stackTraceReceived = true;
          return 'Error';
        },
      );

      expect(stackTraceReceived, isTrue);
      expect(result, equals('Error'));
    });

    test('toString should include stacktrace for error results', () {
      final stackTrace = StackTrace.current;
      final result = Result.error('Error message', stackTrace);

      final stringRepresentation = result.toString();
      expect(stringRepresentation.contains('error(Error message)'), isTrue);
      expect(stringRepresentation.contains('StackTrace:'), isTrue);
      expect(stringRepresentation.contains(stackTrace.toString()), isTrue);
    });

    test('toString should not include stacktrace for success results', () {
      final result = Result.ok('Success message');

      final stringRepresentation = result.toString();
      expect(stringRepresentation, equals('ok(Success message)'));
      expect(stringRepresentation.contains('StackTrace:'), isFalse);
    });
  });
}
