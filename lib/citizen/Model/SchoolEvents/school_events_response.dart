class SchoolEeventsResponse {
  // Update to DateTime type

  bool? isSuccessful;
  String? message;
  bool? isException;
  List<SchoolEevents>? eventList;

  SchoolEeventsResponse({
    this.isSuccessful,
    this.message,
    this.isException,
    this.eventList,
  });

  SchoolEeventsResponse.fromJson(Map<String, dynamic> json) {
    if (json['eventCalenderList'] != null) {
      eventList = <SchoolEevents>[];
      json['eventCalenderList'].forEach((v) {
        eventList!.add(SchoolEevents.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccessful = json['IsSuccessful'];
    isException = json['IsServerException'];
  }
}

class SchoolEevents {
  int? id;
  int? classSectionId;
  int? classTeacherId;
  String? eventName;
  String? eventNote;
  DateTime? eventDate;

  SchoolEevents({
    this.id,
    this.classSectionId,
    this.classTeacherId,
    this.eventName,
    this.eventNote,
    this.eventDate,
  });

  SchoolEevents.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    classSectionId = json['ClassSectionId'];
    classTeacherId = json['ClassTeacherId'];
    eventName = json['EventName'];
    eventNote = json['EventNote'];
    // Parse 'EventDate' string to DateTime
    eventDate =
        json['EventDate'] != null ? DateTime.parse(json['EventDate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ClassSectionId'] = classSectionId;
    data['ClassTeacherId'] = classTeacherId;
    data['EventName'] = eventName;
    data['EventNote'] = eventNote;
    // Convert DateTime to ISO 8601 string for JSON serialization
    data['EventDate'] = eventDate?.toIso8601String();
    return data;
  }
}
