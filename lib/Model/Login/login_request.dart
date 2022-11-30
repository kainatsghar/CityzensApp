class LoginRequest {
  String username;
  String password;
  String userType;

  LoginRequest({this.username, this.password,this.userType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_Name'] = username;
    data['Password'] = password;
    data['UserType'] = userType;
    return data;
  }
}