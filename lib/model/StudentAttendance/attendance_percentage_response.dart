class AttendancePercentageResponse {
  bool? isSuccessful;
  String? message;
  AttendancePercentageData? data;

  AttendancePercentageResponse({this.isSuccessful, this.message, this.data});

  factory AttendancePercentageResponse.fromJson(Map json) {
    var dataList = json['Data'] as List?;
    var firstData = (dataList != null && dataList.isNotEmpty) ? dataList.first : {};
    return AttendancePercentageResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        data: AttendancePercentageData.fromJson(firstData));
  }

  Map<String, dynamic> toJson() => {
    'IsSuccessful': isSuccessful,
    'Message': message,
    'Data': data != null ? [data!.toJson()] : [],
  };
}

class AttendancePercentageData {
  int? studentId;
  String? name;
  num? attendancePercentage;
  int? presentDays;
  int? absentDays;
  int? workingDays;
  int? sessionId;
  String? sessionName;
  String? sessionStartDate;
  String? sessionEndDate;

  AttendancePercentageData({
    this.studentId,
    this.name,
    this.attendancePercentage,
    this.presentDays,
    this.absentDays,
    this.workingDays,
    this.sessionId,
    this.sessionName,
    this.sessionStartDate,
    this.sessionEndDate,
  });

  factory AttendancePercentageData.fromJson(Map json) {
    return AttendancePercentageData(
      studentId: json['Student_Id'],
      name: json['Name'],
      attendancePercentage: json['AttendancePercentage'],
      presentDays: json['PresentDays'],
      absentDays: json['AbsentDays'],
      workingDays: json['WorkingDays'],
      sessionId: json['SessionId'],
      sessionName: json['SessionName'],
      sessionStartDate: json['SessionStartDate'],
      sessionEndDate: json['SessionEndDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Student_Id': studentId,
    'Name': name,
    'AttendancePercentage': attendancePercentage,
    'PresentDays': presentDays,
    'AbsentDays': absentDays,
    'WorkingDays': workingDays,
    'SessionId': sessionId,
    'SessionName': sessionName,
    'SessionStartDate': sessionStartDate,
    'SessionEndDate': sessionEndDate,
  };
}
