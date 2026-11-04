class AppointmentResponse {
  String? message;
  bool? isSuccess;
  AppointmentProfile? profile;
  List<AppointmentTimeSlot>? appointmentTimeSlots;
  List<AppointmentReason>? appointmentReasons;
  List<AppointmentTeacherType>? appointmentTeacherTypes;

  AppointmentResponse(
      {this.message,
      this.isSuccess,
      this.profile,
      this.appointmentTimeSlots,
      this.appointmentReasons,
      this.appointmentTeacherTypes});

  AppointmentResponse.fromJson(Map<String, dynamic> json) {
    if (json['Profile'] != null) {
      profile = AppointmentProfile.fromJson(json['Profile']);
    }
    if (json['Config'] != null) {
      appointmentTeacherTypes = <AppointmentTeacherType>[];
      appointmentReasons = <AppointmentReason>[];
      appointmentTimeSlots = <AppointmentTimeSlot>[];
      json['Config'].forEach((v) {
        if (v['Filter'] == 1) {
          appointmentTeacherTypes!.add(AppointmentTeacherType.fromJson(v));
        }
      });

      json['Config'].forEach((v) {
        if (v['Filter'] == 2) {
          appointmentReasons!.add(AppointmentReason.fromJson(v));
        }
      });
      json['Config'].forEach((v) {
        if (v['Filter'] == 3) {
          appointmentTimeSlots!.add(AppointmentTimeSlot.fromJson(v));
        }
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccessful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (profile != null) {
      data['Profile'] = profile!.toJson();
    }
    if (appointmentTeacherTypes != null) {
      data['Config'] = appointmentTeacherTypes!.map((v) {
        v.filter = 1;
        return v.toJson();
      }).toList();
    }
    if (appointmentReasons != null) {
      data['Config'] = appointmentReasons!.map((v) {
        v.filter = 2;
        return v.toJson();
      }).toList();
    }
    if (appointmentTimeSlots != null) {
      data['Config'] = appointmentTimeSlots!.map((v) {
        v.filter = 3;
        return v.toJson();
      }).toList();
    }

    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}

class AppointmentProfile {
  int? studentId;
  String? fullName;
  String? className;

  AppointmentProfile({this.studentId, this.fullName, this.className});

  AppointmentProfile.fromJson(Map<String, dynamic> json) {
    studentId = json['Student_Id'];
    fullName = json['fullname'];
    className = json['Class_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Student_Id'] = studentId;
    data['fullname'] = fullName;
    data['Class_Name'] = className;
    return data;
  }
}

class AppointmentConfig {
  int? id;
  String? column;
  int? filter;

  AppointmentConfig({this.id, this.column, this.filter});

  AppointmentConfig.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    column = json['Column'];
    filter = json['Filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Column'] = column;
    data['Filter'] = filter;
    return data;
  }
}

class AppointmentTimeSlot {
  int? id;
  String? time;
  int? filter;

  AppointmentTimeSlot({this.id, this.time, this.filter});

  AppointmentTimeSlot.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    time = json['Column'];
    filter = json['Filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Column'] = time;
    data['Filter'] = filter;
    return data;
  }
}

class AppointmentTeacherType {
  int? id;
  String? type;
  int? filter;

  AppointmentTeacherType({this.id, this.type, this.filter});

  AppointmentTeacherType.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    type = json['Column'];
    filter = json['Filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Column'] = type;
    data['Filter'] = filter;
    return data;
  }
}

class AppointmentReason {
  int? id;
  String? reason;
  int? filter;

  AppointmentReason({this.id, this.reason, this.filter});

  AppointmentReason.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    reason = json['Column'];
    filter = json['Filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Column'] = reason;
    data['Filter'] = filter;
    return data;
  }
}

class AssignmentRecords {
  String? subject;
  String? description;
  int? classTeacherId;
  String? classWorkDate;
  String? fileName;

  AssignmentRecords(
      {this.subject,
      this.description,
      this.classTeacherId,
      this.classWorkDate,
      this.fileName});

  AssignmentRecords.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    classTeacherId = json['ClassTeacherId'];
    classWorkDate = json['ClassWorkDate'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Subject'] = subject;
    data['Description'] = description;
    data['ClassTeacherId'] = classTeacherId;
    data['ClassWorkDate'] = classWorkDate;
    data['FileName'] = fileName;
    return data;
  }
}

class MeetingResponse {
  String? message;
  bool? isSuccess;
  List<MeetingDetails>? meetingDetails;

  MeetingResponse({
    this.message,
    this.isSuccess,
    this.meetingDetails,
  });

  MeetingResponse.fromJson(Map<String, dynamic> json) {
    if (json['MeetingResponseDto'] != null) {
      meetingDetails = <MeetingDetails>[];
      json['MeetingResponseDto'].forEach((v) {
        meetingDetails!.add(MeetingDetails.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccessful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (meetingDetails != null) {
      data['MeetingResponseDto'] =
          meetingDetails!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}

class MeetingDetails {
  int? studentId;
  int? classSectionId;
  int? meetingReasonId;
  String? classSection;
  String? meetingTime;
  String? meetingReason;
  DateTime? meetingDate;
  String? studentName;
  String? meetingDay;
  int? meetingPersonId;
  int? meetingTimeId;

  MeetingDetails(
      {this.studentId,
      this.classSectionId,
      this.meetingReasonId,
      this.classSection,
      this.meetingTime,
      this.meetingReason,
      this.meetingDate,
      this.studentName,
      this.meetingDay,
      this.meetingPersonId,
      this.meetingTimeId});

  MeetingDetails.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    classSectionId = json['ClassSectionId'];
    meetingReasonId = json['MeetingReasonId'];
    classSection = json['ClassSection'];
    meetingTime = json['MeetingTime'];
    meetingReason = json['MeetingReason'];
    meetingDate = json['MeetingDate'] != null
        ? DateTime.parse(json['MeetingDate'])
        : null;
    studentName = json['StudentName'];
    meetingDay = json['MeetingDay'];
    meetingPersonId = json['MeetingPersonId'];
    meetingTimeId = json['MeetingTimeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['ClassSectionId'] = classSectionId;
    data['MeetingReasonId'] = meetingReasonId;
    data['ClassSection'] = classSection;
    data['MeetingTime'] = meetingTime;
    data['MeetingReason'] = meetingReason;
    data['MeetingDate'] = meetingDate?.toIso8601String();
    data['StudentName'] = studentName;
    data['MeetingDay'] = meetingDay;
    if (meetingPersonId != null) data['MeetingPersonId'] = meetingPersonId;
    if (meetingTimeId != null) data['MeetingTimeId'] = meetingTimeId;
    return data;
  }
}
