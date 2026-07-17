class ParentEyeOnYourChildResponse {
  String? message;
  bool? isSuccessful;
  List<StudentFileDetails>? fileList;

  ParentEyeOnYourChildResponse(
      {this.message, this.isSuccessful, this.fileList});

  ParentEyeOnYourChildResponse.fromJson(Map<String, dynamic> json) {
    if (json['StudentFileLists'] != null) {
      fileList = <StudentFileDetails>[];
      json['StudentFileLists'].forEach((v) {
        fileList!.add(StudentFileDetails.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccessful = json['IsSuccessful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fileList != null) {
      data['StudentFileLists'] = fileList!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    data['IsSuccessful'] = isSuccessful;
    return data;
  }
}

class StudentFileDetails {
  int? studentId;
  String? fileName1;
  String? fileName2;
  String? fileName3;
  String? filePath1;
  String? filePath2;
  String? filePath3;
  String? studentUpdate;

  StudentFileDetails(
      {this.studentId,
      this.fileName1,
      this.fileName2,
      this.fileName3,
      this.filePath1,
      this.filePath2,
      this.filePath3,
      this.studentUpdate});

  StudentFileDetails.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    fileName1 = json['FileName1'];
    fileName2 = json['FileName2'];
    fileName3 = json['FileName3'];
    filePath1 = json['FilePath1'];
    filePath2 = json['FilePath2'];
    filePath3 = json['FilePath3'];
    studentUpdate = json['UpdateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['FileName1'] = fileName1;
    data['FileName2'] = fileName2;
    data['FileName3'] = fileName3;
    data['FilePath1'] = filePath1;
    data['FilePath2'] = filePath2;
    data['FilePath3'] = filePath3;
    data['UpdateName'] = studentUpdate;
    return data;
  }
}
