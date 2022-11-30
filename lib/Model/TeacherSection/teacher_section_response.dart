class TeacherSectionResponse {
  bool isSuccessful;
  String message;
  bool isException;
  List<Section> section;

  TeacherSectionResponse(
      {this.isSuccessful, this.message, this.isException, this.section});

  factory TeacherSectionResponse.fromJson(Map json) {
    var list = json['ClassSection'] as List;
    List<Section> sessionList = list.map((i) => Section.fromJson(i)).toList();
    return TeacherSectionResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        section: sessionList);
  }
}

class Section {
  int classSectionId;
  String name;

  Section({this.classSectionId, this.name});

  factory Section.fromJson(Map json) {
    return Section(classSectionId: json['ClassSectionId'], name: json['Name']);
  }
}
