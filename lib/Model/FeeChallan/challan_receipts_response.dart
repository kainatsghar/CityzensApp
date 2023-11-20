class ChallanReceiptResponse {
  bool isSuccessful;
  String message;
  bool isException;
  StudentInfo info;
  List<FeechallanHistory> receiptList;

  ChallanReceiptResponse(
      {this.isSuccessful,
        this.message,
        this.isException,
        this.info,
        this.receiptList});

  factory ChallanReceiptResponse.fromJson(Map json) {
    var list = json['feechallanHistory'] as List;
    List<FeechallanHistory> feeReceipts =
    list.map((i) => FeechallanHistory.fromJson(i)).toList();
    return ChallanReceiptResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        info: StudentInfo.fromJson(json['StudentInfo'] ?? {}),
        receiptList: feeReceipts);
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

class FeechallanHistory {
  String receiptNo;
  String challanType;
  String receiptDate;
  String periodName;
  double amount;
  double overReceipt;

  FeechallanHistory(
      {this.receiptNo,
        this.challanType,
        this.receiptDate,
        this.periodName,
        this.amount,
        this.overReceipt});

  factory FeechallanHistory.fromJson(Map json) {
    return FeechallanHistory(
        receiptNo: json['RECEIPT_NUMBER'],
        challanType: json['CHALLAN_TYPE'],
        receiptDate: json['RECEIPT_DATE'],
        amount: json['AMOUNT'],
        overReceipt: json['OVER_RECEIPT'],
        periodName: json['PERIOD_NAME']);
  }
}
