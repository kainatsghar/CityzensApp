class WithdrawalResponse {
  StudentInfoDto? studentInfo;
  List<WithdrawalReasonsDto>? reasons;
  bool? isSuccessful;
  String? message;

  WithdrawalResponse({
    this.studentInfo,
    this.reasons,
    this.isSuccessful,
    this.message,
  });

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalResponse(
      studentInfo: json['Data'] != null
          ? StudentInfoDto.fromJson(json['Data']['StudentInfoDto'])
          : null,
      reasons: json['Data'] != null
          ? (json['Data']['WithdrawalReasonResponseDtos'] as List)
              .map((i) => WithdrawalReasonsDto.fromJson(i))
              .toList()
          : null,
      isSuccessful: json['IsSuccess'],
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (studentInfo != null) {
      data['StudentInfoDto'] = studentInfo!.toJson();
    }
    if (reasons != null) {
      data['WithdrawalReasonResponseDtos'] =
          reasons!.map((v) => v.toJson()).toList();
    }
    data['IsSuccess'] = isSuccessful;
    data['Message'] = message;
    return data;
  }
}

class StudentInfoDto {
  int? studentId;
  String? name;
  String? className;
  String? sectionName;
  String? phone;
  bool? isSubmitted;
  bool? isProcessing;

  StudentInfoDto(
      {this.studentId,
      this.name,
      this.className,
      this.sectionName,
      this.phone,
      this.isSubmitted,
      this.isProcessing});

  StudentInfoDto.fromJson(Map<String, dynamic> json) {
    studentId = json['Student_Id'];
    name = json['Name'];
    className = json['Class_Name'];
    sectionName = json['Section_Name'];
    phone = json['Phone'];
    isSubmitted = json['IsSubmitted'];
    isProcessing = json['IsProcessing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Student_Id'] = studentId;
    data['Name'] = name;
    data['Class_Name'] = className;
    data['Section_Name'] = sectionName;
    data['Phone'] = phone;
    data['IsSubmitted'] = isSubmitted;
    data['IsProcessing'] = isProcessing;
    return data;
  }
}

class WithdrawalReasonsDto {
  int? id;
  String? reason;

  WithdrawalReasonsDto({
    this.id,
    this.reason,
  });

  WithdrawalReasonsDto.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    reason = json['Reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Reason'] = reason;
    return data;
  }
}
