class ResponseMessage {
  bool isSuccessful;
  bool isSuccess;
  String message;
  bool isException;

  ResponseMessage({
    this.isSuccessful,
    this.isSuccess,
    this.message,
    this.isException,
  });

  factory ResponseMessage.fromJson(Map json) {
    return ResponseMessage(
      isSuccess: json['IsSuccess'],
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isException: json['IsServerException'],
    );
  }
}
