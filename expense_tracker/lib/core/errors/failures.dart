abstract class Failure {
  final String message;
  final Object? cause;

  const Failure(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.cause]);
}

class DataParseFailure extends Failure {
  const DataParseFailure(super.message, [super.cause]);
}
