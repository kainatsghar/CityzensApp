class MultiChildResponse{
  bool isSuccessful;
  String message;
  bool isException;
  List<ChildInfo> children;

  MultiChildResponse(
      {this.isSuccessful,
        this.message,
        this.isException,
        this.children});

  factory MultiChildResponse.fromJson(Map json) {
    var list = json['StudentInfo'] as List;
    List<ChildInfo> childInfo =
    list.map((i) => ChildInfo.fromJson(i)).toList();
    return MultiChildResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        children:  childInfo);
  }
}

class ChildInfo {
  int studentId;
  String className;
  String studentName;
  String dateOfBirth;
  String regionName;
  String centerName;
  String fatherEmail;
  bool isInvstrMenueEnable;

  ChildInfo(
      {this.studentId,
      this.className,
      this.studentName,
      this.dateOfBirth,
      this.regionName,
      this.centerName,
      this.fatherEmail,
      this.isInvstrMenueEnable});

  factory ChildInfo.fromJson(Map json) {
    return ChildInfo(
        studentId: json['Student_Id'] as int,
        className: json['Class_Name'] as String,
        studentName: json['StudentName'] as String,
        dateOfBirth: json['Date_Of_Birth'] as String,
        regionName: json['Region_Name'] as String,
        centerName: json['Center_Name'] as String,
        fatherEmail: json['FatherEmail'] as String,
        isInvstrMenueEnable: json['IsInvstrMenueEnable'] as bool);
  }
}
