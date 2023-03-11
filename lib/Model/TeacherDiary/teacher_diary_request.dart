class TeacherDiaryRequest {
  String classTeacherId;

  TeacherDiaryRequest({this.classTeacherId});

  TeacherDiaryRequest.fromJson(Map<String, dynamic> json) {
    classTeacherId = json['classTeacherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classTeacherId'] = this.classTeacherId;
    return data;
  }
}
