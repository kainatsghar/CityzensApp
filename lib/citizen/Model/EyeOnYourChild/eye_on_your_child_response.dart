class EyeOnYourChildResponse {
  List<StudentUpdateDetails>? studentUpdateDetails;
  List<StudentDetails>? studentDetails;
  String? message;
  bool? isSuccess;

  EyeOnYourChildResponse(
      {this.studentUpdateDetails,
      this.studentDetails,
      this.message,
      this.isSuccess});

  EyeOnYourChildResponse.fromJson(Map<String, dynamic> json) {
    if (json['studentUpdates'] != null) {
      studentUpdateDetails = <StudentUpdateDetails>[];
      json['studentUpdates'].forEach((v) {
        studentUpdateDetails!.add(StudentUpdateDetails.fromJson(v));
      });
    }
    if (json['StudentDtos'] != null) {
      studentDetails = <StudentDetails>[];
      json['StudentDtos'].forEach((v) {
        studentDetails!.add(StudentDetails.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccessful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (studentUpdateDetails != null) {
      data['studentUpdates'] =
          studentUpdateDetails!.map((v) => v.toJson()).toList();
    }
    if (studentDetails != null) {
      data['StudentDtos'] = studentDetails!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    data['IsSuccessful'] = isSuccess;
    return data;
  }
}

class StudentUpdateDetails {
  int? id;
  String? updateName;

  StudentUpdateDetails({this.id, this.updateName});

  StudentUpdateDetails.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    updateName = json['UpdateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['UpdateName'] = updateName;
    return data;
  }
}

class StudentDetails {
  int? studentId;
  String? studentName;

  StudentDetails({this.studentId, this.studentName});

  StudentDetails.fromJson(Map<String, dynamic> json) {
    studentId = json['Student_Id'];
    studentName = json['StudentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Student_Id'] = studentId;
    data['StudentName'] = studentName;
    return data;
  }
}

class DaysDto {
  String? day;

  DaysDto({this.day});
}
