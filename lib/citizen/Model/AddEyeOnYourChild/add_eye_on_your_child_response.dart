class AddEyeOnYourChildResponse {
  String? message;
  bool? isSuccess;

  AddEyeOnYourChildResponse({this.message, this.isSuccess});

  AddEyeOnYourChildResponse.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}
