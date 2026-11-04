class TimeTableRequest {
  int? classSectionId;
  int? id;
  bool? isTeacher;

  TimeTableRequest({this.classSectionId, this.id, this.isTeacher});

  TimeTableRequest.fromJson(Map<String, dynamic> json) {
    classSectionId = json['classSectionId'];
    id = json['Id'];
    isTeacher = json['IsTeacher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (classSectionId != null) {
      data['classSectionId'] = classSectionId;
    }
    if (id != null) data['Id'] = id;
    if (isTeacher != null) data['IsTeacher'] = isTeacher;
    return data;
  }
}
