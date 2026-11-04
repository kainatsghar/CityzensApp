class ChangePasswordRequest {
  String? username;
  String? newPassword;
  String? userType;
  String? oldPassword;

  ChangePasswordRequest({this.username, this.newPassword,this.userType,this.oldPassword});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserName'] = username;
    data['NewPassword'] = newPassword;
    data['UserType'] = userType;
    data['OldPassword'] = oldPassword;
    return data;
  }
}