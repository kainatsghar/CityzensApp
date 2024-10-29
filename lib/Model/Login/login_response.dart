class LoginResponse {
  String? tokenId;
  String? name;
  bool? isSuccessful;
  String? message;
  bool? isException;
  bool? isInvstrEnable;
  int? id;
  UserInfo? info;
  String? userType;
  String? userName;
  int? gradeId;

  LoginResponse(
      {this.tokenId,
      this.name,
      this.isInvstrEnable,
      this.isSuccessful,
      this.message,
      this.isException,
      this.id,
      this.info,
      this.userType,
      this.userName,
      this.gradeId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TokenId'] = tokenId;
    data['Name'] = name;
    data['Id'] = id;
    data['UserType'] = userType;
    data['UserName'] = userName;
    data['IsInvstrMenueEnable'] = isInvstrEnable;
    data['UserInfo'] = info;
    data['GradeId'] = gradeId;
    return data;
  }

  factory LoginResponse.fromJson(Map json) {
    return LoginResponse(
        tokenId: json['TokenId'],
        name: json['Name'],
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        id: json['Id'],
        isInvstrEnable: json['IsInvstrMenueEnable'],
        isException: json['IsServerException'],
        userType: json['UserType'],
        userName: json['UserName'],
        info: UserInfo.fromJson(json['UserInfo'] ?? {}),
        gradeId: json['GradeId']);
  }
}

class UserInfo {
  String? name;
  int? rollNo;
  String? className;
  String? centerName;
  String? regionName;
  String? fatherEmail;
  int? gradeId;

  UserInfo(
      {this.name,
      this.rollNo,
      this.className,
      this.centerName,
      this.regionName,
      this.fatherEmail,
      this.gradeId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['StudentId'] = rollNo;
    data['ClassName'] = className;
    data['CenterName'] = centerName;
    data['RegionName'] = regionName;
    data['FatherEmail'] = fatherEmail;
    data['Grade_Id'] = gradeId;
    return data;
  }

  factory UserInfo.fromJson(Map json) {
    return UserInfo(
        name: json['Name'],
        rollNo: json['StudentId'],
        className: json['ClassName'],
        centerName: json['CenterName'],
        regionName: json['RegionName'],
        fatherEmail: json['FatherEmail'],
        gradeId: json['Grade_Id']);
  }
}
