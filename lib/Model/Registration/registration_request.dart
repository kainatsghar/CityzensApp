class RegistrationRequest {
  String username;
  String mobileNumber;
  String deviceId;
  String userType;
  String pinCode;
  String password;

  RegistrationRequest(
      {this.username, this.mobileNumber, this.deviceId, this.userType, this.pinCode, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_Name'] = username;
    data['MobileNo'] = mobileNumber;
    data['DeviceId'] = deviceId;
    data['UserType'] = userType;
    data['PinCode'] = pinCode;
    data['Password'] = password;
    return data;
  }
}
