class ResponseMessage {
  bool isSuccessful;
  String message;
  bool isException;

  ResponseMessage({
    this.isSuccessful,
    this.message,
    this.isException,
  });

  factory ResponseMessage.fromJson(Map json) {
    return ResponseMessage(
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isException: json['IsServerException'],
    );
  }
}
