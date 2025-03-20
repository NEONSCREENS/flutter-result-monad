import 'package:result_monad/result_monad.dart';
import 'package:test/test.dart';

void main() {
  test('Test runCatching with success', () {
    var counter = 0;
    var count = 10;
    final success = runCatching(() {
      for (var c = 0; c < count; c++) {
        counter++;
      }
      return Result.ok(counter);
    });
    expect(counter, equals(count));
    expect(success.isSuccess, true);
    expect(success.value, equals(count));
  });

  test('Test runCatching with exception', () {
    final values = [1, 2, 3, 4];
    final failure = runCatching(() {
      var sum = 0;
      for (var i = 0; i <= values.length; i++) {
        sum += values[i];
      }
      return Result.ok(sum);
    });
    expect(failure.isError, true);
    expect(failure.error is RangeError, true);
  });

  test('Test runCatching with exception async', () async {
    var counter = 0;
    var count = 10;

    final success = await runCatchingAsync(() async {
      for (var c = 0; c < count; c++) {
        counter++;
      }
      return Result.ok(counter);
    });
    expect(counter, equals(count));
    expect(success.isSuccess, true);
    expect(success.value, equals(count));
  });

  test('Test runCatching with exception async', () async {
    final values = [1, 2, 3, 4];
    final failure = await runCatchingAsync(() async {
      var sum = 0;
      for (var i = 0; i <= values.length; i++) {
        sum += values[i];
      }
      return Result.ok(sum);
    });
    expect(failure.isError, true);
    expect(failure.error is RangeError, true);
  });
  //test real async operations
}
