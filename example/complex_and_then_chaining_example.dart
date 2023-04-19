import 'package:result_monad/result_monad.dart';

void main() async {
  getUser(true)
      .andThen((user) => renameUser(user, "joseph stone"))
      .andThen((user) => validateUser(user))
      .match(
        onSuccess: (value) => print(value),
        onError: (error) => print(error),
      );

  final tempPath = await generateNewName()
      .transform((filename) => filename.replaceAll('-', '_'))
      .transform((filename) => filename.replaceAll(':', '_'))
      .transform((filename) => filename.replaceAll(' ', '_'))
      .andThen((filename) => filename.contains('-') ||
              filename.contains(' ') ||
              filename.contains(':')
          ? Result.error("Can't have dashes, spaces, or colons")
          : Result.ok(filename))
      .andThenAsync((filename) async {
    final tempDir = await getTemporaryDirectory();
    return tempDir.isEmpty
        ? Result.error('Empty result for tempdir')
        : Result.ok('${tempDir}/$filename');
  });

  tempPath.match(
    onSuccess: (value) => print(value),
    onError: (error) => print(error),
  );
}

Result<String, int> generateNewName() => Result.ok('${DateTime.now()}.tmp');

Result<User, AccessError> getUser(bool isAdmin) {
  if (isAdmin) {
    return Result.ok(User("New User"));
  }

  return Result.error(AccessError("Don't have permissions"));
}

Result<User, UserError> validateUser(User user) {
  if (user.name == "New User") {
    return Result.error(UserError("Unknown user"));
  }

  return Result.ok(user);
}

Result<User, InputError> renameUser(User user, String newName) {
  if (newName.length < 5) {
    return Result.error(InputError("Name is too short: $newName"));
  }

  return Result.ok(user.copy(newName: newName));
}

class User {
  final String name;

  User(this.name);

  @override
  String toString() {
    return 'User{name: $name}';
  }

  User copy({String? newName}) => User(newName ?? name);
}

class InputError {
  final String message;

  InputError(this.message);

  @override
  String toString() {
    return 'InputError{message: $message}';
  }
}

class AccessError {
  final String message;

  AccessError(this.message);

  @override
  String toString() {
    return 'AccessError{message: $message}';
  }
}

class UserError {
  final String message;

  @override
  String toString() {
    return 'UserError{message: $message}';
  }

  UserError(this.message);
}

Future<String> getTemporaryDirectory() async {
  return '/tmp';
}
