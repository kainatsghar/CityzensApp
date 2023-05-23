class LoginRequest {
  String username;
  String password;
  String userType;
  String fcmToken;

  LoginRequest({this.username, this.password, this.userType, this.fcmToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_Name'] = username;
    data['Password'] = password ?? '';
    data['UserType'] = userType;
    data['FcmToken'] = fcmToken;
    return data;
  }
}
