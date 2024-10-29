class TimeTableResponse {
  ClassTimeTableDTO? classTimeTableDTO;
  bool? isSuccessful;
  String? message;
  bool? isServerException;

  TimeTableResponse({
    this.classTimeTableDTO,
    this.isSuccessful,
    this.message,
    this.isServerException,
  });

  factory TimeTableResponse.fromJson(Map<String, dynamic> json) {
    return TimeTableResponse(
      classTimeTableDTO: json['ClassTimeTableDTO'] != null
          ? ClassTimeTableDTO.fromJson(json['ClassTimeTableDTO'])
          : null,
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isServerException: json['IsServerException'],
    );
  }
}

class ClassTimeTableDTO {
  int? termId;
  int? classSectionId;
  int? classTeacherId;
  int? createdBy;
  List<DayListResponse>? dayLists;

  ClassTimeTableDTO({
    this.termId,
    this.classSectionId,
    this.classTeacherId,
    this.createdBy,
    this.dayLists,
  });

  factory ClassTimeTableDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic>? dayListsJson = json['Daylists'];
    List<DayListResponse> dayLists = dayListsJson != null
        ? dayListsJson.map((e) => DayListResponse.fromJson(e)).toList()
        : [];

    return ClassTimeTableDTO(
      termId: json['TermId'],
      classSectionId: json['ClassSectionId'],
      classTeacherId: json['ClassTeacherId'],
      createdBy: json['CreatedBy'],
      dayLists: dayLists,
    );
  }
}

class DayListResponse {
  String? dayOfWeek;
  List<PeriodsResponse>? periods;

  DayListResponse({
    this.dayOfWeek,
    this.periods,
  });

  factory DayListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic>? periodsJson = json['Periods'];
    List<PeriodsResponse> periods = periodsJson != null
        ? periodsJson.map((e) => PeriodsResponse.fromJson(e)).toList()
        : [];

    return DayListResponse(
      dayOfWeek: json['DayOfWeek'],
      periods: periods,
    );
  }
}

class PeriodsResponse {
  String? subject1;
  String? subject2;
  String? subject3;
  String? subject4;
  String? subject5;
  String? subject6;
  String? subject7;
  String? subject8;
  String? subject9;

  PeriodsResponse({
    this.subject1,
    this.subject2,
    this.subject3,
    this.subject4,
    this.subject5,
    this.subject6,
    this.subject7,
    this.subject8,
    this.subject9,
  });

  factory PeriodsResponse.fromJson(Map<String, dynamic> json) {
    return PeriodsResponse(
      subject1: json['Subject1'],
      subject2: json['Subject2'],
      subject3: json['Subject3'],
      subject4: json['Subject4'],
      subject5: json['Subject5'],
      subject6: json['Subject6'],
      subject7: json['Subject7'],
      subject8: json['Subject8'],
      subject9: json['Subject9'],
    );
  }
}
