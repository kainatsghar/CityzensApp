class LoginRequest {
  String? username;
  String? password;
  String? userType;
  String? fcmToken;
  String? iosFcmToken;
  bool? isIOSDevice;

  LoginRequest(
      {this.username,
      this.password,
      this.userType,
      this.fcmToken,
      this.iosFcmToken,
      this.isIOSDevice});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_Name'] = username;
    data['Password'] = password ?? '';
    data['UserType'] = userType;
    data['FcmToken'] = fcmToken;
    data['IOSFcmToken'] = iosFcmToken;
    data["IsIOSDevice"] = isIOSDevice ?? false;
    return data;
  }
}
