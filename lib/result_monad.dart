/// A Dart implementation of the Result Monad which models success (ok) or
/// failure (error) operation return types to allow for more expressive
/// return generation/processing without using exceptions
///
library result_monad;

export 'src/future_result_extensions.dart';
export 'src/result_monad_base.dart';
export 'src/result_monad_exception.dart';
export 'src/result_monad_exception_wrapping.dart';
