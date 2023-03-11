class UnverifiedReasonsResponse {
  List<VerificationReason> verificationReasons;
  String message;
  bool isSuccess;

  UnverifiedReasonsResponse(
      {this.verificationReasons, this.message, this.isSuccess});

  UnverifiedReasonsResponse.fromJson(Map<String, dynamic> json) {
    if (json['listOfStudentVerificationReason'] != null) {
      verificationReasons = <VerificationReason>[];
      json['listOfStudentVerificationReason'].forEach((v) {
        verificationReasons.add(new VerificationReason.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }
}

class VerificationReason {
  int reasonId;
  String reasonDescription;

  VerificationReason({this.reasonId, this.reasonDescription});

  VerificationReason.fromJson(Map<String, dynamic> json) {
    reasonId = json['ReasonId'];
    reasonDescription = json['ReasonDescription'];
  }
}
