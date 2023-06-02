class AttendancePercentageResponse {
  bool isSuccessful;
  String message;
  Data data;

  AttendancePercentageResponse({this.isSuccessful, this.message, this.data});

  factory AttendancePercentageResponse.fromJson(Map json) {
    return AttendancePercentageResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        data: Data.fromJson(json['Data'] ?? {}));
  }
}

class Data {
  num attendancePercentage;

  Data({this.attendancePercentage});

  factory Data.fromJson(Map json) {
    return Data(attendancePercentage: json['AttendancePercentage']);
  }
}
