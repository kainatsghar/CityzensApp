class AddEyeOnYourChildRequest {
  int? studentId;
  int? updateId;
  String? tokenId;
  int? createdBy;
  int? modifiedBy;
  String? fileName1;
  String? fileName2;
  String? fileName3;
  String? fileBaseString1;
  String? fileBaseString2;
  String? fileBaseString3;

  AddEyeOnYourChildRequest({
    this.studentId,
    this.updateId,
    this.tokenId,
    this.createdBy,
    this.modifiedBy,
    this.fileName1,
    this.fileName2,
    this.fileName3,
    this.fileBaseString1,
    this.fileBaseString2,
    this.fileBaseString3,
  });
  AddEyeOnYourChildRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    updateId = json['UpdateId'];
    tokenId = json['tokenId'];
    createdBy = json['CreatedBy'];
    modifiedBy = json['ModifiedBy'];
    fileName1 = json['FileName1'];
    fileName2 = json['FileName2'];
    fileName3 = json['FileName3'];
    fileBaseString1 = json['FileBasestring1'];
    fileBaseString2 = json['FileBasestring2'];
    fileBaseString3 = json['FileBasestring3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (studentId != null) data['StudentId'] = studentId;
    if (updateId != null) data['UpdateId'] = updateId;
    if (tokenId != null) data['tokenId'] = tokenId;
    if (createdBy != null) data['CreatedBy'] = createdBy;
    if (modifiedBy != null) data['ModifiedBy'] = modifiedBy;
    if (fileName1 != null) data['FileName1'] = fileName1;
    if (fileName2 != null) data['FileName2'] = fileName2;
    if (fileName3 != null) data['FileName3'] = fileName3;
    if (fileBaseString1 != null) data['FileBasestring1'] = fileBaseString1;
    if (fileBaseString2 != null) data['FileBasestring2'] = fileBaseString2;
    if (fileBaseString3 != null) data['FileBasestring3'] = fileBaseString3;
    return data;
  }
}
