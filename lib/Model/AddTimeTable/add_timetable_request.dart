class AddTimeTableRequest {
  int? termId;
  int? classSectionId;
  int? classTeacherId;
  int? createdBy;
  List<DayList>? dayLists;

  AddTimeTableRequest({
    this.termId,
    this.classSectionId,
    this.classTeacherId,
    this.createdBy,
    this.dayLists,
  });

  AddTimeTableRequest.fromJson(Map<String, dynamic> json) {
    termId = json['TermId'];
    classSectionId = json['ClassSectionId'];
    classTeacherId = json['ClassTeacherId'];
    createdBy = json['CreatedBy'];

    if (json['Daylists'] != null) {
      dayLists = <DayList>[];
      json['Daylists'].forEach((v) {
        dayLists!.add(DayList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TermId'] = termId;
    data['ClassSectionId'] = classSectionId;
    data['ClassTeacherId'] = classTeacherId;
    data['CreatedBy'] = createdBy;
    data['Daylists'] = dayLists?.map((v) => v.toJson()).toList();
    return data;
  }
}

class DayList {
  String? dayOfWeek;
  List<Periods>? periods;

  DayList({this.dayOfWeek, this.periods});

  DayList.fromJson(Map<String, dynamic> json) {
    dayOfWeek = json['DayOfWeek'];
    if (json['Periods'] != null) {
      periods = <Periods>[];
      json['Periods'].forEach((v) {
        periods!.add(Periods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DayOfWeek'] = dayOfWeek;
    data['Periods'] = periods?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Periods {
  String? subject1;
  String? subject2;
  String? subject3;
  String? subject4;
  String? subject5;
  String? subject6;
  String? subject7;
  String? subject8;
  String? subject9;

  Periods({
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

  Periods.fromJson(Map<String, dynamic> json) {
    subject1 = json['Subject1'];
    subject2 = json['Subject2'];
    subject3 = json['Subject3'];
    subject4 = json['Subject4'];
    subject5 = json['Subject5'];
    subject6 = json['Subject6'];
    subject7 = json['Subject7'];
    subject8 = json['Subject8'];
    subject9 = json['Subject9'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Subject1'] = subject1;
    data['Subject2'] = subject2;
    data['Subject3'] = subject3;
    data['Subject4'] = subject4;
    data['Subject5'] = subject5;
    data['Subject6'] = subject6;
    data['Subject7'] = subject7;
    data['Subject8'] = subject8;
    data['Subject9'] = subject9;
    return data;
  }
}
