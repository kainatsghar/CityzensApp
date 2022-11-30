class OutstandingChallanResponse {
  bool isSuccessful;
  String message;
  bool isException;
  StudentInfo info;
  List<OutstandingChallan> outstandingList;

  OutstandingChallanResponse(
      {this.isSuccessful,
      this.message,
      this.isException,
      this.info,
      this.outstandingList});

  factory OutstandingChallanResponse.fromJson(Map json) {
    var list = json['OutstandingChallan'] as List;
    List<OutstandingChallan> feeRecords =
        list.map((i) => OutstandingChallan.fromJson(i)).toList();
    return OutstandingChallanResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        info: StudentInfo.fromJson(json['StudentInfo'] ?? {}),
        outstandingList: feeRecords);
  }
}

class StudentInfo {
  String name;
  int rollNo;
  String className;
  String centerName;
  String regionName;

  StudentInfo(
      {this.name,
      this.rollNo,
      this.className,
      this.centerName,
      this.regionName});

  factory StudentInfo.fromJson(Map json) {
    return StudentInfo(
        name: json['StudentName'],
        rollNo: json['Student_Id'],
        className: json['Class_Name'],
        centerName: json['Center_Name'],
        regionName: json['Region_Name']);
  }
}

class OutstandingChallan {
  String challanNo;
  String challanType;
  String issueDate;
  String dueDate;
  String validityDate;
  String periodName;
  double originalFee;
  double outstandingFee;

  OutstandingChallan(
      {this.challanNo,
      this.challanType,
      this.issueDate,
      this.dueDate,
      this.validityDate,
      this.periodName,
      this.originalFee,
      this.outstandingFee});

  factory OutstandingChallan.fromJson(Map json) {
    return OutstandingChallan(
        challanNo: json['CHALLAN_NO'],
        challanType: json['CHALLAN_TYPE'],
        issueDate: json['ISSUE_DATE'],
        dueDate: json['DUE_DATE'],
        validityDate: json['VALIDITY_DATE'],
        originalFee: json['ORIGINAL_FEE'],
        outstandingFee: json['OUTSTANDING_FEE'],
        periodName: json['PERIOD_NAME']);
  }
}
