class AppException implements Exception {
  final String? _message;

  AppException([this._message]);

  @override
  String toString() {
    return "$_message";
  }
}

class FetchDataException extends AppException {
  // ignore: use_super_parameters
  FetchDataException([dynamic message]) : super(message);
}

class BadRequestException extends AppException {
  // ignore: use_super_parameters
  BadRequestException([dynamic message]) : super(message);
}

class UnAuthorizedException extends AppException {
  // ignore: use_super_parameters
  UnAuthorizedException([dynamic message]) : super(message);
}

class InvalidInputException extends AppException {
  // ignore: use_super_parameters
  InvalidInputException([dynamic message]) : super(message);
}
