class OutstandingChallanResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  StudentInfo? info;
  List<OutstandingChallan>? outstandingList;

  OutstandingChallanResponse({
    this.isSuccessful,
    this.message,
    this.isException,
    this.info,
    this.outstandingList,
  });

  factory OutstandingChallanResponse.fromJson(Map json) {
    var list = json['OutstandingChallan'] as List<dynamic>? ?? [];
    List<OutstandingChallan> feeRecords = list
        .map((i) => OutstandingChallan.fromJson(i))
        .toList();
    return OutstandingChallanResponse(
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isException: json['IsServerException'],
      info: StudentInfo.fromJson(json['StudentInfo'] ?? {}),
      outstandingList: feeRecords,
    );
  }

  Map<String, dynamic> toJson() => {
    'IsSuccessful': isSuccessful,
    'Message': message,
    'IsServerException': isException,
    'StudentInfo': info?.toJson(),
    'OutstandingChallan': outstandingList?.map((e) => e.toJson()).toList(),
  };
}

class StudentInfo {
  String? name;
  int? rollNo;
  String? className;
  String? centerName;
  String? regionName;
  String? fatherCnic;
  String? primaryContactNo;

  StudentInfo({
    this.name,
    this.rollNo,
    this.className,
    this.centerName,
    this.regionName,
    this.fatherCnic,
    this.primaryContactNo,
  });

  factory StudentInfo.fromJson(Map json) {
    return StudentInfo(
      name: json['StudentName'],
      rollNo: json['Student_Id'],
      className: json['Class_Name'],
      centerName: json['Center_Name'],
      regionName: json['Region_Name'],
      fatherCnic: json['Father_CNIC'],
      primaryContactNo: json['PrimaryContactNo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'StudentName': name,
    'Student_Id': rollNo,
    'Class_Name': className,
    'Center_Name': centerName,
    'Region_Name': regionName,
    'Father_CNIC': fatherCnic,
    'PrimaryContactNo': primaryContactNo,
  };
}

class OutstandingChallan {
  String? challanNo;
  String? challanType;
  String? issueDate;
  String? dueDate;
  String? validityDate;
  String? periodName;
  double? originalFee;
  double? outstandingFee;

  OutstandingChallan({
    this.challanNo,
    this.challanType,
    this.issueDate,
    this.dueDate,
    this.validityDate,
    this.periodName,
    this.originalFee,
    this.outstandingFee,
  });

  factory OutstandingChallan.fromJson(Map json) {
    return OutstandingChallan(
      challanNo: json['CHALLAN_NO'],
      challanType: json['CHALLAN_TYPE'],
      issueDate: json['ISSUE_DATE'],
      dueDate: json['DUE_DATE'],
      validityDate: json['VALIDITY_DATE'],
      originalFee: json['ORIGINAL_FEE'],
      outstandingFee: json['OUTSTANDING_FEE'],
      periodName: json['PERIOD_NAME'],
    );
  }

  Map<String, dynamic> toJson() => {
    'CHALLAN_NO': challanNo,
    'CHALLAN_TYPE': challanType,
    'ISSUE_DATE': issueDate,
    'DUE_DATE': dueDate,
    'VALIDITY_DATE': validityDate,
    'ORIGINAL_FEE': originalFee,
    'OUTSTANDING_FEE': outstandingFee,
    'PERIOD_NAME': periodName,
  };
}
