import '../../Utils/Errors/ErrorCode409.dart';

import '../../Utils/Services/Results.dart';

class Errors {
  final int statusCode;
  final Map<String, dynamic> error;

  Errors(this.statusCode, this.error) {}

  Result result() {
    switch (statusCode) {
      case 409:
        final trapped = ErrorCode409.fromJson(error);
        return Result(
            statusCode: statusCode,
            error: "${trapped.name} ${trapped.message}");
      default:
        return Result(statusCode: statusCode, error: "");
    }
  }
}
