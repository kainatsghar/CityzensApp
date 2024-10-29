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
  FetchDataException([message]) : super(message);
}

class BadRequestException extends AppException {
  // ignore: use_super_parameters
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends AppException {
  // ignore: use_super_parameters
  UnauthorisedException([message]) : super(message);
}

class InvalidInputException extends AppException {
  // ignore: use_super_parameters
  InvalidInputException([message]) : super(message);
}
