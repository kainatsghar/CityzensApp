class StudentListResponse {
  bool isSuccessful;
  String message;
  bool isException;
  List<Student> studentList;

  StudentListResponse(
      {this.isSuccessful, this.message, this.isException, this.studentList});

  factory StudentListResponse.fromJson(Map json) {
    var list = json['DailyAttandanceDto'] as List;
    List<Student> students = list.map((i) => Student.fromJson(i)).toList();
    return StudentListResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        studentList: students);
  }
}

class Student {
  int studentId;
  String name;
  String day;
  int attnTypeId;
  bool status;

  Student({this.studentId, this.name, this.day, this.attnTypeId, this.status});

  factory Student.fromJson(Map json) {
    return Student(
      studentId: json['StudentId'],
      name: json['Name'],
      attnTypeId: json['AttnType_ID'],
      status: json['Status'],
      day: json['Day'] == '-' ? 'P' : json['Day'],
    );
  }
}
