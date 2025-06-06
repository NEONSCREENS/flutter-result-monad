import 'package:result_monad/result_monad.dart';

final t = Duration(milliseconds: 100);

Future<void> main() async {
  print('Simplified Async Syntax Example');

  print('Showing result propagation');
  await Result.ok(await ds(() => 1))
      .andThenAsync((y) async => Result.ok(await ds(() => y + 1)))
      .transformAsync((y) async => ds(() => List.generate(y, (index) => index)))
      .withResult((y) => print('Has ${y.length} elements'))
      .transformAsync((y) async => ds(() => y.toString()))
      .match(
        onSuccess: (value) => print('Succeeded! $value'),
        onError: (error) => print('Error! $error'),
      );

  print('Showing same as above but with error propagation');
  await Result.ok(await ds(() => 1))
      .andThenAsync((y) async => Result.ok(await ds(() => y + 1)))
      .transformAsync((y) async => ds(() => List.generate(y, (index) => index)))
      .withResult((y) => print('Has ${y.length} elements'))
      .andThenAsync((p0) async {
        return Result.error('Bad result: $p0');
      })
      .transformAsync((y) async => ds(() => y.toString()))
      .match(
        onSuccess: (value) => print('Succeeded! $value'),
        onError: (error) => print('Error! $error'),
      );
}

Future<T> ds<T>(T Function() func) async {
  await Future.delayed(t);
  return func();
}
