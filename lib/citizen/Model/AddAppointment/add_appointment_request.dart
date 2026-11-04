class AddAppointmentRequest {
  int? studentId;
  int? classSectionId;
  int? meetingPersonId;
  int? meetingTimeId;
  int? meetingReasonId;
  String? createdBy;
  String? modifiedBy;
  String? dayName;

  AddAppointmentRequest({
    this.studentId,
    this.classSectionId,
    this.meetingPersonId,
    this.meetingTimeId,
    this.meetingReasonId,
    this.createdBy,
    this.modifiedBy,
    this.dayName,
  });

  AddAppointmentRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    classSectionId = json['ClassSectionId'];
    meetingPersonId = json['MeetingPersonId'];
    meetingTimeId = json['MeetingTimeId'];
    meetingReasonId = json['MeetingReasonId'];
    createdBy = json['CreatedBy'];
    modifiedBy = json['ModifiedBy'];
    dayName = json['DayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['ClassSectionId'] = classSectionId;
    data['MeetingPersonId'] = meetingPersonId;
    data['MeetingTimeId'] = meetingTimeId;
    data['MeetingReasonId'] = meetingReasonId;
    data['CreatedBy'] = createdBy;
    data['ModifiedBy'] = modifiedBy;
    data['DayName'] = dayName;
    return data;
  }
}
