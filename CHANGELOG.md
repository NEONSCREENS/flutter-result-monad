## 2.0.0
- Allow nullable types for success and failure types
- Add `andThenSuccess` and `andThenSuccessAsync` methods for allowing returning results without explicit `Result.ok` wrapping to allow more concise syntax
- Add extension methods on `FutureResult` to make async chaining syntax much more concise
- Add `errorCast` method for when need to pass up an error Result with the same error type with different success type.


## 1.0.2
- Tweaks to API documentation
- Added temp file "intermediate" level example and added it to `example.md` as well


## 1.0.1
- Added an `example.md` file for pub.dev.

## 1.0.0
- Initial version.
