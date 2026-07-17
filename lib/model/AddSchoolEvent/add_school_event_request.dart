class AddSchoolEventRequest {
  String? classId;
  String? classSectionId;
  int? classTeacherId;
  String? eventName;
  String? eventNote;
  String? eventDate;

  AddSchoolEventRequest({
    this.classId,
    this.classSectionId,
    this.classTeacherId,
    this.eventName,
    this.eventNote,
    this.eventDate,
  });

  AddSchoolEventRequest.fromJson(Map<String, dynamic> json) {
    classId = json['ClassId'];
    classSectionId = json['ClassSectionId'];
    classTeacherId = json['ClassTeacherId'];
    eventName = json['EventName'];
    eventNote = json['EventNote'];
    eventDate = json['EventDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClassId'] = classId;
    data['ClassSectionId'] = classSectionId;
    data['ClassTeacherId'] = classTeacherId;
    data['EventName'] = eventName;
    data['EventNote'] = eventNote;
    data['EventDate'] = eventDate;
    return data;
  }
}
