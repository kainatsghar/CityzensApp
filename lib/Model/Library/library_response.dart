class LibraryResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  StudentInfo? info;
  List<LibraryRecords>? listLibrary;

  LibraryResponse(
      {this.isSuccessful,
      this.message,
      this.isException,
      this.info,
      this.listLibrary});

  factory LibraryResponse.fromJson(Map json) {
    var list = json['libraryRecords'] as List;
    List<LibraryRecords> libraryRecords =
        list.map((i) => LibraryRecords.fromJson(i)).toList();
    return LibraryResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        listLibrary: libraryRecords,
        info: StudentInfo.fromJson(json['StudentInfo'] ?? {}));
  }
}

class StudentInfo {
  String? name;
  int? rollNo;
  String? className;
  String? centerName;
  String? regionName;

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
      regionName: json['Region_Name'],
    );
  }
}

class LibraryRecords {
  String? bookTitle;
  String? authorName;
  String? issueDate;
  String? dueDate;
  String? returnDate;
  double? fine;

  LibraryRecords(
      {this.bookTitle,
      this.authorName,
      this.issueDate,
      this.dueDate,
      this.returnDate,
      this.fine});

  factory LibraryRecords.fromJson(Map json) {
    return LibraryRecords(
        bookTitle: json['Title'] as String,
        authorName: json['Author'] as String,
        issueDate: json['IssueDate'] as String,
        dueDate: json['DueDate'] as String,
        returnDate: json['ReturnDate'] as String,
        fine: json['fineAmount'] as double);
  }
}
